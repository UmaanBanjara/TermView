import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/session_state_provider.dart';
import 'package:termview/helpers/leave.dart';
import 'package:termview/helpers/sharesession.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/screens/joinedsessionchat.dart';
import 'package:termview/screens/livequizpage.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Joinesesion extends ConsumerStatefulWidget {
  final String? sessionId;
  final String? title;
  final String? desc;
  final bool? is_chat;

  Joinesesion({this.sessionId, this.title, this.desc,this.is_chat, super.key});

  @override
  ConsumerState<Joinesesion> createState() => _JoinesesionState();
}

class _JoinesesionState extends ConsumerState<Joinesesion> {
  final ScrollController _scrollController = ScrollController();

  @override  
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final sessionstate = ref.watch(sessionnotifierProvider);
    ref.listen<SessionState>(sessionnotifierProvider, (previous, next) {
      if ((previous?.commands.length ?? 0) != next.commands.length) {
        if (_scrollController.hasClients) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
        }
      }
    });

    ref.listen<SessionState>(sessionnotifierProvider , (previous , next){
      if(next.message != null && next.message != previous?.message){
        showTerminalSnackbar(context, next.message! , isError: false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> Homescreen()) , (route) => false);
      }
    });
        ref.listen<SessionState>(sessionnotifierProvider , (previous , next){
      if(next.reveal != null && next.reveal != previous?.reveal){
        showTerminalSnackbar(context, "The answer is ${next.reveal}" , isError: false);
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 70,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? "Not Found",
              style: text.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              widget.desc ?? "Not Found",
              style: text.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
              child: Text((sessionstate.joined ?? 0).toString()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigate(context, Livequizpage(user: true,host: false,));
                    ref.read(sessionnotifierProvider.notifier).resetQuizIndicator();
                  },
                  style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: const Text("Quizes"),
                ),
                if(sessionstate.hasquiz)
                    Positioned(
                      right: -2,
                      top : -2,
                      child: Container(
                        width: 10,
                        height: 10 ,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                        ),
                      ),
                    )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if(widget.is_chat!)
                ElevatedButton(
                  onPressed: () {
                    navigate(context, Joinedsessionchat());
                    ref.read(sessionnotifierProvider.notifier).resetChatIndicator();
                  },
                  style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: const Text("Chat"),
                ),
                if(sessionstate.haschat)
                    Positioned(
                      right: -2,
                      top : -2,
                      child: Container(
                        width: 10,
                        height: 10 ,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                        ),
                      ),
                    )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                sharesession(context, link: "Hello World");
              },
              style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
              child: const Text("Share"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: (){
                leavesession(context, ref);
              },
              style: ElevatedButton.styleFrom(
                  textStyle: text.bodyMedium,
                  backgroundColor: Colors.redAccent),
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
                        itemCount: sessionstate.commands.length,
                        itemBuilder: (context, index) {
                          final command = sessionstate.commands[index];
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${command['command'] ?? ''} ',
                                  style: text.bodyMedium!.copyWith(color: Colors.orangeAccent), // command color
                                ),
                                TextSpan(
                                  text: '>>>>>> ',
                                  style: text.bodyMedium!.copyWith(color: Colors.white), // separator color
                                ),
                                TextSpan(
                                  text: '${command['result']?['output'] ?? ''}',
                                  style: text.bodyMedium!.copyWith(color: Colors.greenAccent), // result color
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
