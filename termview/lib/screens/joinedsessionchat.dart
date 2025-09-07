import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Joinedsessionchat extends StatefulWidget {
  final Stream? broadcastStream;
  final WebSocketChannel? channel;
   Joinedsessionchat({this.broadcastStream , this.channel ,super.key});

  @override
  State<Joinedsessionchat> createState() => _JoinedsessionchatState();
}

class _JoinedsessionchatState extends State<Joinedsessionchat> {
  final ScrollController _scrollController = ScrollController();
  List<String> _chatlines = [];
  final TextEditingController _chat = TextEditingController();
  final FocusNode _chatfocus = FocusNode();

  void _sendchat(){
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
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    }

    void _receivemessage(){
      try{
        widget.broadcastStream!.listen((message){
          final decoded = jsonDecode(message);
          if(decoded['type'] == 'chat'){
            setState(() {
              _chatlines.add("${decoded['username']} said: ${decoded['content']}");

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
        leading: BackButton(),
        title: Text("Send Chat" , style: text.bodyLarge,),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black87,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _chatlines.length,
                        itemBuilder: (context , index){
                          return Text(
                            _chatlines[index],
                            style: text.bodyMedium!.copyWith(
                              color: Colors.greenAccent
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chat,
                            focusNode: _chatfocus,
                            cursorHeight: 22,
                            style: text.bodyMedium,
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              
                            ),
                            onSubmitted: (value) => _sendchat()
                          ),
                        ),
                        const SizedBox(width: 8,),
                        ElevatedButton(
                          onPressed: (){
                            _sendchat();
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: text.bodyMedium
                          ),
                          child: Text('Send' , style : text.bodyMedium),
                        )
                      ],
                    )
                  ],
                )
              ),
            )
          ],
          
        ),
      ),
    );
  }
}