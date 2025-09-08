
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:termview/helpers/chatsetting.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Showlivechat extends StatefulWidget {
  final Stream? broadcastStream;
  final WebSocketChannel? channel;
   Showlivechat({this.channel ,this.broadcastStream ,super.key});

  @override
  State<Showlivechat> createState() => _ShowlivechatState();
}

class _ShowlivechatState extends State<Showlivechat> {
  final FocusNode _chatfocus = FocusNode();
  final TextEditingController _chat = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List _terminalLines = [];
  

  void _sendCommand(){
    if(_chat.text.isNotEmpty && widget.channel != null){
      widget.channel!.sink.add(jsonEncode({
        "type" : "chat",
        "content" : _chat.text
      }));
      setState(() {
        _chat.clear();
        _chatfocus.requestFocus();
      });
      if(_scrollController.hasClients){
        WidgetsBinding.instance.addPostFrameCallback((_){
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    }
  }

  void _receivemessage(){
    try{
      widget.broadcastStream!.listen((message){
        final decoded = jsonDecode(message);
        if(decoded['type'] == 'chat'){
          setState(() {
            _terminalLines.add("${decoded['username']} said: ${decoded['content']}");

            
          });
          if(_scrollController.hasClients){
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        }
        else{
          return;
        }
      });
      
    }
    catch(e){
      showTerminalSnackbar(context, "Something went wrong : $e" , isError: true);
    }
  }
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
    _receivemessage();

    });
  }
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(),
        centerTitle: false,
        title: Text('Live Chat'  , style: text.bodyLarge,),
        
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.black87,
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _terminalLines.length,
                  itemBuilder: (context , index){
                    return Text(
                      _terminalLines[index],
                      style: text.bodyMedium!.copyWith(color: Colors.greenAccent),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chat,
                    cursorHeight: 22,
                    focusNode: _chatfocus,
                    style: text.bodyMedium,
                    decoration: InputDecoration(
                      hintText: "What's on your mind",
                    ),
                    onSubmitted: (_)=>_sendCommand(),
                  ),
                ),
                const SizedBox(width: 8,),
                ElevatedButton(onPressed: (){
                  _sendCommand();
                }, 
                style: ElevatedButton.styleFrom(
                  textStyle: text.bodyMedium
                )
                ,child: Text('Send'))
              ],
            )
          ],
        ),
      ),
    );
  }
}