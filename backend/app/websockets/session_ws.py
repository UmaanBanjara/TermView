from fastapi import WebSocket, APIRouter, WebSocketDisconnect, Query, HTTPException
from typing import Dict
import asyncio
import json
from app.utils.current_user import get_user_id_from_token  # your JWT helper

router = APIRouter()  # router


class ConnectionManager:
    def __init__(self):
        # Nested dictionary: session_id -> {user_id -> websocket}
        self.connections: Dict[str, Dict[str, WebSocket]] = {}

    # Connect a user to a session
    async def connect(self, session_id: str, user_id: str, websocket: WebSocket):
        await websocket.accept()  # Accept the websocket connection
        if session_id not in self.connections:
            self.connections[session_id] = {}
        self.connections[session_id][user_id] = websocket
        print(
            f"Connection added: SessionId={session_id}, UserId={user_id}, Total Users={len(self.connections[session_id])}"
        )
        await self.broadcastUserAccount(session_id)

    # Disconnect a user
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
            await self.broadcastUserAccount(session_id)

    # Broadcast a message to all users in a session
    async def broadcast(self, session_id: str, message: str):
        if session_id in self.connections:
            tasks = [
                self._safe_send(session_id, user_id, ws, message)
                for user_id, ws in self.connections[session_id].items()
            ]
            await asyncio.gather(*tasks)

    # Broadcast current user count to all users
    async def broadcastUserAccount(self, session_id: str):
        if session_id in self.connections:
            count = len(self.connections[session_id])
            message = json.dumps({"type": "usercount", "count": count})
            tasks = [
                self._safe_send(session_id, user_id, ws, message)
                for user_id, ws in self.connections[session_id].items()
            ]
            await asyncio.gather(*tasks)

    # End a session and notify all users
    async def EndSession(self, session_id: str):
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

    # Send a message safely to a single WebSocket
    async def _safe_send(self, session_id: str, user_id: str, websocket: WebSocket, message: str):
        try:
            await websocket.send_text(message)
        except Exception:
            await self.disconnect(session_id, user_id)  # Disconnect if sending fails


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
            decoded = json.loads(data)  # always JSON
            msg_type = decoded.get("type")

            if msg_type == "endsession":
                await manager.EndSession(session_id)
            else:
                # broadcast the JSON exactly as received
                await manager.broadcast(session_id, json.dumps(decoded))

    except WebSocketDisconnect:
        await manager.disconnect(session_id, str(user_id))
    except Exception as e:
        print(f"Unexpected error: {e}")
        await manager.disconnect(session_id, str(user_id))
