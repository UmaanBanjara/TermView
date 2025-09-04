import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Joinedsessionchat extends StatefulWidget {
  const Joinedsessionchat({super.key});

  @override
  State<Joinedsessionchat> createState() => _JoinedsessionchatState();
}

class _JoinedsessionchatState extends State<Joinedsessionchat> {
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? channel;
  List<String> _chatlines = [];
  final TextEditingController _chat = TextEditingController();
  final FocusNode _chatfocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    void _sendchat(){
      if(_chat.text.isNotEmpty){
        setState(() {
          _chatlines.add(_chat.text);
          _chat.clear();
          _chatfocus.requestFocus();
        });
        WidgetsBinding.instance.addPostFrameCallback((_){
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    }
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