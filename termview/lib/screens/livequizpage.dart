import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Livequizpage extends StatefulWidget {
  final bool? host;
  final bool? user;
  final WebSocketChannel? channel;
  final Stream? broadcastStream;

  const Livequizpage({
    this.host,
    this.user,
    this.channel,
    this.broadcastStream,
    super.key,
  });

  @override
  State<Livequizpage> createState() => _LivequizpageState();
}

class _LivequizpageState extends State<Livequizpage> {
  late Map<String, dynamic> _quiz = {
    'question': '',
    'options': ['', '', '', ''],
    'answer': '',
  };

  int? _selectedOption;
  final List<String> _votelines = [];
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _quizSubscription;

  void _listenQuizStream() {
    if (widget.broadcastStream == null) {
      print("[Livequizpage] No broadcast stream available");
      return;
    }

    print("[Livequizpage] Listening to broadcastStream...");

    _quizSubscription = widget.broadcastStream!.listen((message) {
      print("[Livequizpage] Raw message: $message");

      try {
        final decoded = jsonDecode(message);
        print("[Livequizpage] Decoded: $decoded");

        if (decoded['type'] == 'quiz') {
          if (!mounted) return;
          setState(() {
            _selectedOption = null; // reset selection
            _quiz = {
              'question': decoded['ques']?.toString() ?? '',
              'options': [
                decoded['op1']?.toString() ?? '',
                decoded['op2']?.toString() ?? '',
                decoded['op3']?.toString() ?? '',
                decoded['op4']?.toString() ?? '',
              ],
              'answer': decoded['ans']?.toString() ?? '',
            };
          });
          print("[Livequizpage] Quiz Updated: $_quiz");
        }

        if (decoded['type'] == 'vote') {
          if (!mounted) return;
          setState(() {
            _votelines.add(
                "${decoded['username'] ?? 'Unknown'} chose: ${decoded['choosed'] ?? ''}");
          });
          if (_scrollController.hasClients) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            });
          }
          print("[Livequizpage] Vote Added: $_votelines");
        }

        if (decoded['type'] == 'correct') {
          print(
              "[Livequizpage] Correct Answer Revealed: ${decoded['correctanswer']}");
          showTerminalSnackbar(
            context,
            'The Correct Answer is: ${decoded['correctanswer'] ?? ''}',
            isError: false,
          );
        }
      } catch (e, st) {
        print("[Livequizpage] ERROR decoding message: $e\n$st");
      }
    }, onError: (err) {
      print("[Livequizpage] Stream error: $err");
    }, onDone: () {
      print("[Livequizpage] Stream closed");
    });
  }

  @override
  void initState() {
    super.initState();
    _listenQuizStream();
  }

  @override
  void dispose() {
    print("[Livequizpage] Disposing...");
    _quizSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Live Quiz Monitor", style: text.bodyLarge),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // ----------------- USER VIEW -----------------
            if (widget.user == true) ...[
              Text("Question", style: text.bodyLarge),
              const SizedBox(height: 5),
              Text(
                _quiz['question']?.toString().isNotEmpty == true
                    ? _quiz['question']
                    : "(Waiting for quiz...)",
                style: text.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text("Options", style: text.bodyLarge),
              const SizedBox(height: 5),
              ...List.generate(4, (index) {
                final option = _quiz['options'][index]?.toString() ?? '';
                return ListTile(
                  title: Text(
                    option.isNotEmpty ? option : "(waiting...)",
                    style: text.bodyMedium,
                  ),
                  leading: Radio<int>(
                    value: index,
                    groupValue: _selectedOption,
                    onChanged: (val) {
                      setState(() => _selectedOption = val);
                      print(
                          "[Livequizpage] User selected option: $val -> $option");
                    },
                  ),
                );
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedOption = null);
                        print("[Livequizpage] Selection cancelled");
                      },
                      child: Text("Cancel", style: text.bodyMedium),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedOption == null) {
                          showTerminalSnackbar(context,
                              "Please select an option before sending",
                              isError: true);
                          print("[Livequizpage] Send blocked: no selection");
                          return;
                        }
                        final selectedAnswer =
                            _quiz['options'][_selectedOption!]?.toString() ?? '';
                        widget.channel?.sink.add(jsonEncode({
                          'type': 'vote',
                          'choosed': selectedAnswer,
                        }));
                        showTerminalSnackbar(
                            context, "Vote sent: $selectedAnswer",
                            isError: false);
                        print("[Livequizpage] Vote sent: $selectedAnswer");
                      },
                      child: Text("Send", style: text.bodyMedium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ----------------- HOST VIEW -----------------
            if (widget.host == true) ...[
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.black87,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _votelines.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          _votelines[index],
                          style: text.bodyMedium
                              ?.copyWith(color: Colors.greenAccent),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final answer = _quiz['answer']?.toString() ?? '';
                  widget.channel?.sink.add(jsonEncode({
                    'type': 'correct',
                    'correctanswer': answer,
                  }));
                  print("[Livequizpage] Reveal Answer sent: $answer");
                },
                child: Text("Reveal Answer", style: text.bodyMedium),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
