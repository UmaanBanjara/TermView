from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from typing import List

router = APIRouter()

#keeps track of connected clientes per session
active_connection = dict[str, List[WebSocket]] = {}

class ConnectionManager:
    def __init__(self):
        self.connections : dict[str , List[WebSocket]] = {}

    async def connect(self , session_id : str , websocket : WebSocket):
        await WebSocket.accept()
        if session_id not in self.connections:
            self.connections[session_id] = []
        self.connections[session_id].append(websocket)
    
    async def disconnect(self , session_id : str , websocket : WebSocket):
        self.connections[session_id].remove(websocket)
        if not self.connections[session_id]:
            del self.connections[session_id]
    
    async def broadcast(self , session_id : str , message : str):
        if session_id in self.connections:
            for connection in self.connections[session_id]: 
                await connection.send_text(message)
    

manager = ConnectionManager() #manager to access the ConnectionManager class

@router.websocket("/ws/{session_id}")
async def websocket_endpoint(websocket : WebSocket , session_id : str):
    await manager.connect(session_id , websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(session_id , f"Host says : {data}")
    except WebSocketDisconnect:
        manager.disconnect(session_id , websocket)
