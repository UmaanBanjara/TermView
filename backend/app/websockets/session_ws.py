from fastapi import WebSocket, APIRouter, WebSocketDisconnect, Query
import subprocess
from typing import Dict
import asyncio
import json
from app.utils.current_user import get_user_id_from_token
from app.utils.get_username import getusername
from app.CRUD.chat_crud import new_chat
from app.CRUD.command_crud import new_command
from app.CRUD.quiz_crud import new_quiz
from app.utils.chatandcommand import get_chat_history, get_command_history, get_quiz_history
import os

os.environ["PATH"] += os.pathsep + "/usr/bin"

router = APIRouter()

class ConnectionManager:
    def __init__(self):
        # Nested dictionary: session_id -> {user_id -> websocket}
        self.connections: Dict[str, Dict[str, WebSocket]] = {}

    async def connect(self, session_id: str, user_id: str, websocket: WebSocket):
        await websocket.accept()
        if session_id not in self.connections:
            self.connections[session_id] = {}
        self.connections[session_id][user_id] = websocket
        print(
            f"Connection added: SessionId={session_id}, UserId={user_id}, Total Users={len(self.connections[session_id])}"
        )

        # Send previous chats
        chats = get_chat_history(session_id)
        for chat in chats:
            message = json.dumps({
                'type': 'chat',
                'content': chat.message,
                'username': getusername(chat.user_id) or "Unknown"
            })
            await websocket.send_text(message)

        # Send previous commands
        commands = get_command_history(session_id)
        for command in commands:
            message = json.dumps({
                'type': 'command',
                'commands': command.command_txt
            })
            await websocket.send_text(message)

        # Send previous quizzes
        quizes = get_quiz_history(session_id)
        for q in quizes:
            quiz_message = json.dumps({
                'type': 'quiz',
                'ques': q.ques,
                'op1': q.a1,
                'op2': q.a2,
                'op3': q.a3,
                'op4': q.a4,
                'ans': q.ans
            })
            await websocket.send_text(quiz_message)

        await self.broadcast_user_count(session_id)

    async def disconnect(self, session_id: str, user_id: str):
        if session_id in self.connections and user_id in self.connections[session_id]:
            del self.connections[session_id][user_id]
            print(
                f"Connection closed: SessionId={session_id}, UserId={user_id}, Remaining Users={len(self.connections[session_id])}"
            )
        if session_id in self.connections and not self.connections[session_id]:
            del self.connections[session_id]
            print(f"Session cleared: {session_id} (no active users)")
        else:
            await self.broadcast_user_count(session_id)

    async def broadcast(self, session_id: str, message: str):
        if session_id in self.connections:
            tasks = [
                self._safe_send(session_id, user_id, ws, message)
                for user_id, ws in self.connections[session_id].items()
            ]
            await asyncio.gather(*tasks)

    async def broadcast_user_count(self, session_id: str):
        if session_id in self.connections:
            count = len(self.connections[session_id])
            message = json.dumps({"type": "usercount", "count": count})
            tasks = [
                self._safe_send(session_id, user_id, ws, message)
                for user_id, ws in self.connections[session_id].items()
            ]
            await asyncio.gather(*tasks)

    async def end_session(self, session_id: str):
        if session_id in self.connections:
            message = json.dumps({
                "type": "endsession",
                "message": "Host has ended the session. Thanks for tuning in"
            })
            tasks = [
                self._safe_send(session_id, user_id, ws, message)
                for user_id, ws in self.connections[session_id].items()
            ]
            await asyncio.gather(*tasks)

            # Close all WebSocket connections
            for ws in self.connections[session_id].values():
                await ws.close()
            del self.connections[session_id]
            print(f"Session ended: {session_id} - all users disconnected")

    async def _safe_send(self, session_id: str, user_id: str, websocket: WebSocket, message: str):
        try:
            await websocket.send_text(message)
        except Exception:
            await self.disconnect(session_id, user_id)


manager = ConnectionManager()


@router.websocket("/ws/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: str, token: str = Query(...)):
    user_id = get_user_id_from_token(token)
    if not user_id:
        await websocket.close(code=1008)
        return

    await manager.connect(session_id, str(user_id), websocket)

    try:
        while True:
            data = await websocket.receive_text()
            decoded = json.loads(data)
            msg_type = decoded.get("type")

            if msg_type == "endsession":
                await manager.end_session(session_id)

            elif msg_type == "chat":
                username = getusername(int(user_id)) or "Unknown"
                content = decoded.get("content")

                # Save to DB
                new_chat(session_id=session_id, user_id=int(user_id), message=content)

                # Broadcast
                message_to_broadcast = json.dumps({
                    "type": "chat",
                    "content": content,
                    "username": username
                })
                await manager.broadcast(session_id, message_to_broadcast)

            elif msg_type == "vote":
                username = getusername(int(user_id)) or "Unknown"
                message_to_broadcast = json.dumps({
                    "type": "vote",
                    "choosed": decoded.get("choosed"),
                    "username": username
                })
                await manager.broadcast(session_id, message_to_broadcast)

            elif msg_type == "command":
                commands = decoded.get("commands")

                # Save to DB
                new_command(session_id=session_id, command_txt=commands)

                try:
                    # Run command inside Docker sandbox
                    result = subprocess.run(
                        [
                            "/usr/bin/docker", "run", "--rm", "--memory=100m", "--cpus=0.5", "--network=none", "command-sandbox",
                            "sh", "-c", commands
                        ],
                        capture_output=True,
                        text=True,
                        timeout=5
                    )
                    output = result.stdout.strip() or result.stderr.strip()
                except subprocess.TimeoutExpired:
                    output = "Error: Command timed out"
                except Exception as e:
                    output = f"Error: {str(e)}"

                # Broadcast output
                message_to_broadcast = json.dumps({
                    "type": "command_output",
                    "command": commands,
                    "output": output
                })
                await manager.broadcast(session_id, message_to_broadcast)

            elif msg_type == "quiz":
                # Save to DB
                new_quiz(
                    user_id=int(user_id),
                    ques=decoded.get("ques"),
                    a1=decoded.get("op1"),
                    a2=decoded.get("op2"),
                    a3=decoded.get("op3"),
                    a4=decoded.get("op4"),
                    ans=decoded.get("ans"),
                    session_id=session_id
                )

                # Broadcast
                quiz_broadcast = json.dumps({
                    "type": "quiz",
                    "ques": decoded.get("ques"),
                    "op1": decoded.get("op1"),
                    "op2": decoded.get("op2"),
                    "op3": decoded.get("op3"),
                    "op4": decoded.get("op4"),
                    "ans": decoded.get("ans"),
                })
                await manager.broadcast(session_id, quiz_broadcast)

            else:
                # Forward other messages as-is
                await manager.broadcast(session_id, json.dumps(decoded))

    except WebSocketDisconnect:
        await manager.disconnect(session_id, str(user_id))
    except Exception as e:
        print(f"Unexpected error: {e}")
        await manager.disconnect(session_id, str(user_id))
