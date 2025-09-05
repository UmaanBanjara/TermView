import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/live_session_provider.dart';
import 'package:termview/helpers/leave.dart';
import 'package:termview/helpers/sharesession.dart';
import 'package:termview/screens/joinedsessionchat.dart';
import 'package:termview/screens/viewallquizes.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Joinesesion extends ConsumerStatefulWidget {
  String? sessionId;
  Joinesesion({this.sessionId,super.key});

  @override
  ConsumerState<Joinesesion> createState() => _JoinesesionState();
}

class _JoinesesionState extends ConsumerState<Joinesesion> {
  final List<String> _termlines = [];
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? channel;

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
      channel!.stream.listen((message) {
      setState(() {
        _termlines.add(message);
        if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  });
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
            Text("Host Name", style: text.bodyLarge),
            Text("Title of the session", style: text.bodyMedium),
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
              child: const Text("10 Joined"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                navigate(context, Joinedsessionchat());
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
                leavesession(context, channel, widget.sessionId!);
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
