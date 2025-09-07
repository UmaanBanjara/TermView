import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveSessionRepository {
  final String baseUrl = 'wss://termview.onrender.com/ws';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<WebSocketChannel> connect(String session_id)async{
    try{
      final token = await _storage.read(key: "access_token");
      print(token);
      if(token == null)throw Exception("Token Not Found");
      final channel = WebSocketChannel.connect(
        Uri.parse('$baseUrl/$session_id?token=$token')
      );

      await Future.delayed(Duration(milliseconds: 500));

      return channel;
    }
    catch(e){
      throw Exception("Websocket connection failed : $e");
    }
  }//repo for livesesson
  
}