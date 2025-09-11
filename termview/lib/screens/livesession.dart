import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/endsession_notifier.dart';
import 'package:termview/data/providers/endsession_provider.dart';
import 'package:termview/data/providers/live_session_provider.dart';
import 'package:termview/helpers/leave.dart';
import 'package:termview/helpers/sharesession.dart';
import 'package:termview/screens/createquiz.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/screens/showlivechat.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Livesession extends ConsumerStatefulWidget {
  String? postId;
  String? title;
  String? description;
  String? link;
  String? ses_id;

  Livesession({
    this.postId,
    this.title,
    this.description,
    this.link,
    this.ses_id,
    super.key,
  });

  @override
  ConsumerState<Livesession> createState() => _LivesessionState();
}

class _LivesessionState extends ConsumerState<Livesession> {
  final TextEditingController _command = TextEditingController();
  final FocusNode _terminalfocus = FocusNode();
  final List<String> _terminalLines = [];
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? channel;
  int? _usercount;
  late Stream broadcastStream;
  bool _hasnewchat = false;

  void _sendCommand() {
    if (_command.text.isNotEmpty && channel != null) {
      channel!.sink.add(jsonEncode({
        "type": "command",
        "commands": _command.text,
      }));
      setState(() {
        _terminalLines.add("> ${_command.text}");
        _command.clear();
        _terminalfocus.requestFocus();
      });
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  void connectwebsocket(String sessionId) async {
    try {
      final ch = await ref
          .read(livesessionnotifierProvider.notifier)
          .live_session(session_id: widget.ses_id!);

      setState(() {
        channel = ch;
      });

      broadcastStream = channel!.stream.asBroadcastStream();
      broadcastStream.listen((message) {
        try {
          final decoded = jsonDecode(message);
          if (decoded['type'] == "usercount") {
            setState(() {
              _usercount = decoded["count"];
            });
          } else if (decoded['type'] == "chat") {
            setState(() {
              _hasnewchat = true;
            });
          }
        } catch (e) {
          print(message);
        }
      });
    } catch (e) {
      showTerminalSnackbar(context, "Failed to connect : $e");
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.ses_id != null) {
        connectwebsocket(widget.ses_id!);
      }
    });
  }

  @override
  void dispose() {
    channel?.sink.close();
    _command.dispose();
    _terminalfocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final sessionstate = ref.watch(livesessionnotifierProvider);
    final endstate = ref.watch(endsessionnotifierProvider);

    ref.listen<EndState>(endsessionnotifierProvider, (previous, next) {
      if (next.message != null && next.message != previous?.message) {
        showTerminalSnackbar(context, next.message!, isError: false);
        navigate(context, Homescreen());
      } else if (next.error != null && next.error != previous?.error) {
        showTerminalSnackbar(context, next.error!, isError: true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 70,
        titleSpacing: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title ?? "Can't get title",
              style: text.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              widget.description ?? "Can't get description",
              style: text.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: Text("${_usercount ?? 0}"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (widget.link != null) {
                      sharesession(context, link: widget.link!);
                    } else {
                      showTerminalSnackbar(context, "No link available",
                          isError: false);
                    }
                  },
                  style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: const Text("Share Session"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(channel != null && broadcastStream != null){
                      navigate(context, Createquiz(
                      channel: channel,
                      broadcastStream: broadcastStream,
                    ));
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: const Text("Create Quiz"),
                ),
                Stack(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (channel != null) {
                          setState(() {
                            _hasnewchat = false;
                          });
                          navigate(
                            context,
                            Showlivechat(
                              channel: channel,
                              broadcastStream: broadcastStream,
                            ),
                          );
                        } else {
                          showTerminalSnackbar(context,
                              "Not Connected yet. Please try again ",
                              isError: false);
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                      child: const Text("Chats"),
                    ),
                    if (_hasnewchat)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (widget.postId != null) {
                      leavesession(context, channel, widget.postId!, ref);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                      backgroundColor: Colors.red),
                  child: const Text("End Session"),
                ),
              ],
            ),
          )
        ],
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
                      style: text.bodyMedium!
                          .copyWith(color: Colors.greenAccent),
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
                    controller: _command,
                    cursorHeight: 22,
                    style: text.bodyMedium,
                    focusNode: _terminalfocus,
                    decoration: const InputDecoration(
                      hintText: "Enter commands",
                    ),
                    onSubmitted: (_) => _sendCommand(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendCommand,
                  style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: const Text('Send'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
