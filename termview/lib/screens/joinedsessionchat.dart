import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/sessionControllerProvider.dart';
import 'package:termview/data/providers/session_state_provider.dart';

class Joinedsessionchat extends ConsumerStatefulWidget {
  Joinedsessionchat({super.key});

  @override
  ConsumerState<Joinedsessionchat> createState() => _JoinedsessionchatState();
}

class _JoinedsessionchatState extends ConsumerState<Joinedsessionchat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();
  final FocusNode _chatFocus = FocusNode();

  @override
  void dispose(){
    _scrollController.dispose();
    _chatController.dispose();
    _chatFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sessionstate = ref.watch(sessionnotifierProvider);
    ref.listen<SessionState>(sessionnotifierProvider ,(previous , next){
      if(previous?.chats.length != next.chats.length){
        if(_scrollController.hasClients){
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Send Chat", style: textTheme.bodyLarge),
        centerTitle: false,
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
                        itemCount: sessionstate.chats.length,
                        itemBuilder: (context, index) {
                          final chat = sessionstate.chats[index];
                          return Text(
                          "${chat['username']}, said : ${chat['content']}",
                          style: textTheme.bodyMedium!.copyWith(color: Colors.greenAccent),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            focusNode: _chatFocus,
                            cursorHeight: 22,
                            style: textTheme.bodyMedium,
                            decoration: const InputDecoration(
                              hintText: "What's on your mind?",
                            ),
                            onSubmitted: (_) {
                              if(_chatController.text.trim().isNotEmpty){
                                final chatText = _chatController.text.trim();
                                ref.read(Sessioncontrollerprovider).sendChat(chatText);
                                _chatController.clear();
                                _chatFocus.requestFocus();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if(_chatController.text.trim().isNotEmpty){
                                final chatText = _chatController.text.trim();
                                ref.read(Sessioncontrollerprovider).sendChat(chatText);
                                _chatController.clear();
                                _chatFocus.requestFocus();
                              }
                          },
                          style: ElevatedButton.styleFrom(textStyle: textTheme.bodyMedium),
                          child: Text('Send', style: textTheme.bodyMedium),
                        ),
                      ],
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
