import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/session_state_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Sessioncontroller {
  final Ref ref;
  WebSocketChannel? _channel;

  Sessioncontroller(this.ref);

  Future<void> connect(String url)async{
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen((message){
      final decoded = jsonDecode(message);

      if(decoded['type'] == 'chat'){
        ref.read(sessionnotifierProvider.notifier).addChat(decoded);
      } else if (decoded['type'] == 'command_result'){
        ref.read(sessionnotifierProvider.notifier).addCommand(decoded);
      } else if (decoded['type'] == 'quiz'){
        ref.read(sessionnotifierProvider.notifier).addquiz(decoded);
      } else if (decoded['type'] == 'vote'){
        ref.read(sessionnotifierProvider.notifier).addvoute(decoded);
      } else if (decoded['type'] == 'endsession'){
        ref.read(sessionnotifierProvider.notifier).endMessage(decoded['message'] ?? "Session ended. Thanks for joining in");        
      } else if (decoded['type'] == 'usercount'){
        ref.read(sessionnotifierProvider.notifier).updateJoined(decoded['count']);
      } else if (decoded['type'] == 'revealanswer'){
        ref.read(sessionnotifierProvider.notifier).revealAnswer(decoded['answer'] ?? "Answer couldn't be found");
      }
    },onError: (error){
      print('Websocket error : $error');
    },onDone: (){
      print('Websocket closed');
    });
  }

  void disconnect(){
    _channel?.sink.close();
    _channel = null;
  }

  void sendChat(String content){
    _channel?.sink.add(jsonEncode(
      {
        "type" : "chat",
        "content" : content
      }
    ));
  }

  void sendCommand(String command){
    _channel?.sink.add(jsonEncode({
      "type" : "command",
      "commands" : command
    }));
  }

  void sendQuiz(Map<String , dynamic> quiz){
    _channel?.sink.add(jsonEncode({
      "type" : "quiz",
      ...quiz
    }));
  }

  void sendVote(String vote){
    _channel?.sink.add(jsonEncode({
      "type" : "vote",
      "choosed" : vote
    }));
  }

  void endSession(){
    _channel?.sink.add(jsonEncode({
      "type" : "endsession",

    }));
  }

  void revealAnswer(String answer){
    _channel?.sink.add(jsonEncode({
      "type" : "revealanswer",
      "answer" : answer
    }));
  }
}

final Sessioncontrollerprovider = Provider<Sessioncontroller>((ref){
  return Sessioncontroller(ref);
});