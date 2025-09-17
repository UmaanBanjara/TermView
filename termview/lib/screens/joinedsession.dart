import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/sessionControllerProvider.dart';
import 'package:termview/data/providers/session_state_provider.dart';
import 'package:termview/helpers/sharesession.dart';
import 'package:termview/screens/joinedsessionchat.dart';
import 'package:termview/screens/livequizpage.dart';
import 'package:termview/widgets/page_transition.dart';

class Joinesesion extends ConsumerStatefulWidget {
  final String? sessionId;
  final String? title;
  final String? desc;

  Joinesesion({this.sessionId, this.title, this.desc, super.key});

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
    ref.listen<SessionState>(sessionnotifierProvider , (previous,next){
      if(previous?.commands.length != next.commands.length){
      if(_scrollController.hasClients){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
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
            child: Stack(
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigate(context, Livequizpage(user: true,host: false,));
                  },
                  style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: const Text("Quizes"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
              child: Text("HELLO WORLD"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Stack(
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigate(context, Joinedsessionchat());
                  },
                  style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: const Text("Chat"),
                ),
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
                ref.read(Sessioncontrollerprovider).disconnect();
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
                        itemCount:  sessionstate.commands.length ,
                        itemBuilder: (context, index) {
                          final command = sessionstate.commands[index];
                          return Text(
                            command['result']?['output'] ?? command['commands'] ?? '',
                            style: text.bodyMedium!.copyWith(color: Colors.greenAccent),
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
