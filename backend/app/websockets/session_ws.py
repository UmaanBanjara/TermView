from fastapi import WebSocket, APIRouter, WebSocketDisconnect, Query
from typing import Dict
import asyncio
import json
import aiohttp
from app.utils.current_user import get_user_id_from_token
from app.utils.get_username import getusername

router = APIRouter()

class ConnectionManager:
    def __init__(self):
        self.connections: Dict[str, Dict[str, WebSocket]] = {}

    async def connect(self, session_id: str, user_id: str, websocket: WebSocket):
        await websocket.accept()
        if session_id not in self.connections:
            self.connections[session_id] = {}
        self.connections[session_id][user_id] = websocket
        print(f"Connection added: SessionId={session_id}, UserId={user_id}, Total Users={len(self.connections[session_id])}")

        await self.broadcast_user_count(session_id)

    async def disconnect(self, session_id: str, user_id: str):
        if session_id in self.connections and user_id in self.connections[session_id]:
            del self.connections[session_id][user_id]
            print(f"Connection closed: SessionId={session_id}, UserId={user_id}, Remaining Users={len(self.connections[session_id])}")
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
            message = json.dumps({"type": "usercount", "count": len(self.connections[session_id])})
            tasks = [
                self._safe_send(session_id, user_id, ws, message)
                for user_id, ws in self.connections[session_id].items()
            ]
            await asyncio.gather(*tasks)

    async def end_session(self, session_id: str):
        if session_id in self.connections:
            message = json.dumps({"type": "endsession", "message": "Host has ended the session. Thanks for tuning in"})
            tasks = [
                self._safe_send(session_id, user_id, ws, message)
                for user_id, ws in self.connections[session_id].items()
            ]
            await asyncio.gather(*tasks)

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


async def call_command_api(session_id: str, command: str):
    """Call external API and broadcast result without blocking."""
    url = "https://docker-executor.onrender.com/execute"
    payload = {"cmd": command}
    print(f"Calling api : {url} with payload {payload}")
    headers = {"Content-Type": "application/json"}

    try:
        async with aiohttp.ClientSession() as session:
            async with session.post(url, json=payload, headers=headers) as resp:
                print("Response Status : ", resp.status)
                if resp.status == 200:
                    result = await resp.json()
                else:
                    result = {"error": f"API returned status {resp.status}"}
    except Exception as e:
        result = {"error": f"API call failed: {e}"}

    await manager.broadcast(session_id, json.dumps({
        "type": "command_result",
        "command": command,
        "result": result
    }))


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
                await manager.broadcast(session_id, json.dumps({
                    "type": "chat",
                    "content": content,
                    "username": username
                }))

            elif msg_type == "vote":
                username = getusername(int(user_id)) or "Unknown"
                await manager.broadcast(session_id, json.dumps({
                    "type": "vote",
                    "choosed": decoded.get("choosed"),
                    "username": username
                }))

            elif msg_type == "revealanswer":
                await manager.broadcast(session_id , json.dumps({
                    "type" : "revealanswer",
                    "answer" : decoded.get("answer")
                }))

            elif msg_type == "command":
                commands = decoded.get("commands")
                asyncio.create_task(call_command_api(session_id, commands))
                

            elif msg_type == "quiz":
                await manager.broadcast(session_id, json.dumps({
                    "type": "quiz",
                    "ques": decoded.get("ques"),
                    "op1": decoded.get("op1"),
                    "op2": decoded.get("op2"),
                    "op3": decoded.get("op3"),
                    "op4": decoded.get("op4"),
                    "ans": decoded.get("ans")
                }))

            else:
                await manager.broadcast(session_id, json.dumps(decoded))

    except WebSocketDisconnect:
        await manager.disconnect(session_id, str(user_id))
    except Exception as e:
        print(f"Unexpected error: {e}")
        await manager.disconnect(session_id, str(user_id))
