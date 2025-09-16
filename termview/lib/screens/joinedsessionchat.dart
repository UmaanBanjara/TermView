import 'package:flutter/material.dart';

class Joinedsessionchat extends StatefulWidget {
  Joinedsessionchat({super.key});

  @override
  State<Joinedsessionchat> createState() => _JoinedsessionchatState();
}

class _JoinedsessionchatState extends State<Joinedsessionchat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();
  final FocusNode _chatFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                        itemBuilder: (context, index) {
                          return Text(
                            "Hello woldhfkdajf"
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
                            onSubmitted: (_) {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
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
