import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/live_session_provider.dart';
import 'package:termview/helpers/sharesession.dart';
import 'package:termview/helpers/userleavesession.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/screens/joinedsessionchat.dart';
import 'package:termview/screens/viewallquizes.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Joinesesion extends ConsumerStatefulWidget {
  String? sessionId;
  String? title;
  String? desc;
  Joinesesion({this.sessionId,this.title,this.desc,super.key});

  @override
  ConsumerState<Joinesesion> createState() => _JoinesesionState();
}

class _JoinesesionState extends ConsumerState<Joinesesion> {
  final List<String> _termlines = [];
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? channel;
  int? _usercount;
  late Stream? broadcastStream;

  @override
  void initState(){
    super.initState();
    Future.microtask((){
    if(widget.sessionId!=null){
      _connectwebsocket(widget.sessionId!);
    }
    });

  }

  void _connectwebsocket(String sessionId)async{
    try{
    
      final ch = await ref.read(livesessionnotifierProvider.notifier).live_session(session_id: widget.sessionId!);
      setState(() {
        channel = ch;
      });
      broadcastStream = channel!.stream.asBroadcastStream();
      
      broadcastStream!.listen((message) {
      try{
        final decoded = jsonDecode(message);

        if(decoded['type'] == 'usercount'){
          setState(() {
            _usercount = decoded['count'];
          });
        }

        else if (decoded['type'] == 'endsession'){
          showTerminalSnackbar(context, decoded['message'] , isError: false);

          Future.delayed(const Duration(seconds: 1), (){
            navigate(context, Homescreen());
          });
        }

        else if (decoded['type'] == 'message'){
          setState(() {
            _termlines.add(decoded['content']);
          });
          if(_scrollController.hasClients){
            WidgetsBinding.instance.addPostFrameCallback((_){
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            });
          }
        }
      }
      catch(e){
        showTerminalSnackbar(context, "Something went wrong. Please try again" , isError: true);
        return;
      }

  
});


    }
    catch(e){
      showTerminalSnackbar(context, "Something went wrong" , isError: true);
    }
   
    
  }
  @override
void dispose() {
  channel?.sink.close();
  _scrollController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 70,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.title ?? "Not Found"}", style: text.bodyLarge , overflow: TextOverflow.ellipsis,maxLines: 1,),
            Text("${widget.desc ?? "Not Found"}", style: text.bodyMedium , overflow: TextOverflow.ellipsis, maxLines: 1,),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                navigate(context, Viewallquizes());
              },
              style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
              child: const Text("Quizes"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                navigate(context, Viewallquizes());
              },
              style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
              child:  Text("${_usercount ?? 0}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                if(channel != null){
                navigate(context, Joinedsessionchat(channel: channel,broadcastStream: broadcastStream,));

                }
              },
              style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
              child: const Text("Chat"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                sharesession(context , link: "Hello World");
              },
              style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
              child: const Text("Share"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                usersleavesession(context , channel);
              },
              style: ElevatedButton.styleFrom(
                  textStyle: text.bodyMedium, backgroundColor: Colors.redAccent),
              child: const Text("Leave"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
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
                        itemCount: _termlines.length,
                        itemBuilder: (context , index){
                          return Text(
                           _termlines[index],
                          style: text.bodyMedium!.copyWith(
                            color: Colors.greenAccent
                          ),

                          );
                        },
                      ),
                      
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ));
  }
}
