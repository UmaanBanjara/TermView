from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from typing import List
import asyncio
import json

router = APIRouter()


class ConnectionManager:
    def __init__(self):
        self.connections: dict[str, List[WebSocket]] = {}

    async def connect(self, session_id: str, websocket: WebSocket):
        await websocket.accept()
        if session_id not in self.connections:
            self.connections[session_id] = []
        self.connections[session_id].append(websocket)
        print(
            f"Connection added : Session ID = {session_id} | total = {len(self.connections[session_id])}"
        )
        await self.broadcast_user(session_id)

    async def disconnect(self, session_id: str, websocket: WebSocket):
        if session_id in self.connections:
            if websocket in self.connections[session_id]:
                self.connections[session_id].remove(websocket)
                print(
                    f"Connection Closed : Session ID = {session_id} , remaining = {len(self.connections[session_id])}"
                )
            if not self.connections[session_id]:
                del self.connections[session_id]
                print(f"Session : {session_id}, Cleared No Active Connections")
            else:
                await self.broadcast_user(session_id)

    async def broadcast(self, session_id: str, message: str):
        if session_id in self.connections:
            tasks = []
            for connection in list(self.connections[session_id]):
                tasks.append(self._safe_send(session_id, connection, message))
            await asyncio.gather(*tasks)

    async def broadcast_user(self, session_id: str):
        if session_id in self.connections:
            tasks = []
            count = len(self.connections[session_id])
            message = json.dumps({"type": "usercount", "count": count})
            for connection in self.connections[session_id]:
                tasks.append(self._safe_send(session_id, connection, message))
            await asyncio.gather(*tasks)

    async def endSession(self , session_id : str):
        if session_id in self.connections:
            message = json.dumps({"type" : "sessionended" , "message" : "Host has ended the session. Thanks for tuning in"})
            tasks = [self._safe_send(session_id , conn , message) for conn in self.connections[session_id]]
            await asyncio.gather(*tasks)

            #close all connections
            for conn in self.connections[session_id]:
                await conn.close()
            del self.connections[session_id]
            print(f"session ended : {session_id} ended all users disconnected")

    async def _safe_send(self, session_id: str, connection: WebSocket, message: str):
        try:
            await connection.send_text(message)
        except Exception:
            await self.disconnect(session_id, connection)


manager = ConnectionManager()


@router.websocket("/ws/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: str):
    await manager.connect(session_id, websocket)
    try:
        while True:
            data = await websocket.receive_text()
            decoded = json.loads(data)
            if decoded.get("type") == "sessionended":
                await manager.endSession(session_id)
            else:
                await manager.broadcast(session_id, f"Host says: {data}")
            print(f"Host Said: {data}")
    except WebSocketDisconnect:
        await manager.disconnect(session_id, websocket)
    except Exception as e:
        print(f"Unexpected Error : {str(e)}")
        await manager.disconnect(session_id, websocket)
