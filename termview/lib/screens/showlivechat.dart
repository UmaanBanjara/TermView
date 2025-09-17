import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/sessionControllerProvider.dart';
import 'package:termview/data/providers/session_state_provider.dart';

class Showlivechat extends ConsumerStatefulWidget {
  const Showlivechat({super.key});

  @override
  ConsumerState<Showlivechat> createState() => _ShowlivechatState();
}

class _ShowlivechatState extends ConsumerState<Showlivechat> {
  final FocusNode _chatFocus = FocusNode();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose(){
    _chatFocus.dispose();
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sessionstate = ref.watch(sessionnotifierProvider);
    ref.listen<SessionState>(sessionnotifierProvider , (previous , next){
      if(previous?.chats.length != next.chats.length){
        if(_scrollController.hasClients){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
      }
      
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const BackButton(),
        centerTitle: false,
        title: Text('Live Chat', style: textTheme.bodyLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.black87,
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                controller: _scrollController,
                itemCount: sessionstate.chats.length,
                itemBuilder: (context, index) {
                  final chat = sessionstate.chats[index];
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${chat['username']}",
                          style: textTheme.bodyMedium!.copyWith(color: Colors.blueAccent), // username color
                        ),
                        TextSpan(
                          text: " said: ",
                          style: textTheme.bodyMedium!.copyWith(color: Colors.grey), // separator color
                        ),
                        TextSpan(
                          text: "${chat['content']}",
                          style: textTheme.bodyMedium!.copyWith(color: Colors.purpleAccent), // message color
                        ),
                      ],
                    ),
                  );
                },
              )

              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    cursorHeight: 22,
                    focusNode: _chatFocus,
                    style: textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                    ),
                    onSubmitted: (_){
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
                  style: ElevatedButton.styleFrom(
                    textStyle: textTheme.bodyMedium,
                  ),
                  child: Text('Send', style: textTheme.bodyMedium),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
