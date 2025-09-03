import 'package:web_socket_channel/web_socket_channel.dart';

class LiveSessionRepository {
  final String baseUrl = 'wss://termview.onrender.com/ws';
  Future<WebSocketChannel> connect(String session_id)async{
    try{
      final channel = WebSocketChannel.connect(
        Uri.parse('$baseUrl/$session_id')
      );

      await Future.delayed(Duration(milliseconds: 500));

      return channel;
    }
    catch(e){
      throw Exception("Websocket connection failed : $e");
    }
  }//repo for livesesson
  
}