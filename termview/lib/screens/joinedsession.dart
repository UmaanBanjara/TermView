import 'package:flutter/material.dart';
import 'package:termview/helpers/leave.dart';
import 'package:termview/helpers/sharesession.dart';
import 'package:termview/screens/viewallquizes.dart';
import 'package:termview/widgets/page_transition.dart';

class Joinesesion extends StatefulWidget {
  String? sessionId;
  Joinesesion({this.sessionId,super.key});

  @override
  State<Joinesesion> createState() => _JoinesesionState();
}

class _JoinesesionState extends State<Joinesesion> {
  final FocusNode _chatfocus = FocusNode();
  final List<String> _chatlines = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    void _sendchat() {
      if (_chat.text.isNotEmpty) {
        setState(() {
          _chatlines.add("> ${_chat.text}");
          _chat.clear();
          _chatfocus.requestFocus();
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    }

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
                leavesession(context, onConfirm: () {});
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
            // Terminal area
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.black87,
                child: Center(
                  child: Text(
                    "This is the terminal",
                    style: text.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            // Chat area
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                color: Colors.black87,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _chatlines.length,
                        itemBuilder: (context, index) {
                          return Text(
                            _chatlines[index],
                            style: text.bodyMedium!
                                .copyWith(color: Colors.greenAccent),
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
                            style: text.bodyMedium,
                            cursorHeight: 22,
                            decoration: const InputDecoration(
                                hintText: "What's on your mind"),
                            onSubmitted: (_) {
                              _sendchat();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _sendchat();
                          },
                          child: const Text("Send"),
                        ),
                      ],
                    )
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
