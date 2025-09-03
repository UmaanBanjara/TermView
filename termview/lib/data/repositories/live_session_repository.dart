import 'package:web_socket_channel/web_socket_channel.dart';

class LiveSessionRepository {
  final String baseUrl = 'wss://termview.onrender.com/websocket/ws';


  WebSocketChannel connect(String sessionId){
    return WebSocketChannel.connect(
      Uri.parse('$baseUrl/$sessionId')
    );
  }
}