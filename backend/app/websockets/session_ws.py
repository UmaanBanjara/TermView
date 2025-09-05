from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from typing import List

router = APIRouter()

class ConnectionManager:
    def __init__(self):
        self.connections: dict[str, List[WebSocket]] = {}

    async def connect(self, session_id: str, websocket: WebSocket):
        await websocket.accept()
        if session_id not in self.connections:
            self.connections[session_id] = []
        self.connections[session_id].append(websocket)
    
    async def disconnect(self, session_id: str, websocket: WebSocket):
        if session_id in self.connections:
            if websocket in self.connections[session_id]:
                self.connections[session_id].remove(websocket)
            if not self.connections[session_id]:
                del self.connections[session_id]
    
    async def broadcast(self, session_id: str, message: str):
        if session_id in self.connections:
            to_remove = []
            for connection in self.connections[session_id]:   
                try:
                    await connection.send_text(message)
                except Exception:
                    to_remove.append(connection)
            for conn in to_remove:
                await self.disconnect(session_id, conn)
        

manager = ConnectionManager()

@router.websocket("/ws/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: str):
    await manager.connect(session_id, websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(session_id, f"Host says: {data}")
            print(f"Host Said: {data}")
    except WebSocketDisconnect:
        await manager.disconnect(session_id, websocket)
