import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:termview/helpers/chatsetting.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Showlivechat extends StatefulWidget {
  final Stream? broadcastStream;
  final WebSocketChannel? channel;
  Showlivechat({this.channel, this.broadcastStream, super.key});

  @override
  State<Showlivechat> createState() => _ShowlivechatState();
}

class _ShowlivechatState extends State<Showlivechat> {
  final FocusNode _chatFocus = FocusNode();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _terminalLines = [];
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    // Subscribe to the broadcast stream
    if (widget.broadcastStream != null) {
      _subscription = widget.broadcastStream!.listen((message) {
        final decoded = jsonDecode(message);
        if (decoded['type'] == 'chat') {
          setState(() {
            _terminalLines.add("${decoded['username']} said: ${decoded['content']}");
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(),
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
                  itemCount: _terminalLines.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _terminalLines[index],
                      style: textTheme.bodyMedium!.copyWith(color: Colors.greenAccent),
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
    );
  }
}
