import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Joinedsessionchat extends StatefulWidget {
  final Stream? broadcastStream;
  final WebSocketChannel? channel;
  Joinedsessionchat({this.broadcastStream, this.channel, super.key});

  @override
  State<Joinedsessionchat> createState() => _JoinedsessionchatState();
}

class _JoinedsessionchatState extends State<Joinedsessionchat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();
  final FocusNode _chatFocus = FocusNode();
  List<String> _chatLines = [];
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    // Listen to broadcast stream and store subscription
    if (widget.broadcastStream != null) {
      _subscription = widget.broadcastStream!.listen((message) {
        final decoded = jsonDecode(message);
        if (decoded['type'] == 'chat') {
          setState(() {
            _chatLines.add("${decoded['username']} said: ${decoded['content']}");
          });
          _scrollToBottom();
        }
      }, onError: (error) {
        showTerminalSnackbar(context, "Something went wrong: $error", isError: true);
      });
    }
  }

  void _sendChat() {
    if (_chatController.text.isNotEmpty && widget.channel != null) {
      widget.channel!.sink.add(jsonEncode({
        "type": "chat",
        "content": _chatController.text,
      }));

      setState(() {
        _chatController.clear();
        _chatFocus.requestFocus();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _chatController.dispose();
    _chatFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
                        itemCount: _chatLines.length,
                        itemBuilder: (context, index) {
                          return Text(
                            _chatLines[index],
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
                            onSubmitted: (_) => _sendChat(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _sendChat,
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