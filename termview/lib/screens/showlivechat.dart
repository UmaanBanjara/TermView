import 'package:flutter/material.dart';

class Showlivechat extends StatefulWidget {
  const Showlivechat({super.key});

  @override
  State<Showlivechat> createState() => _ShowlivechatState();
}

class _ShowlivechatState extends State<Showlivechat> {
  final FocusNode _chatFocus = FocusNode();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                  itemCount: 10, // Placeholder item count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "Hello World",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
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
                    onSubmitted: (_) {
                      // Handle submitted input here
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle send button press here
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
