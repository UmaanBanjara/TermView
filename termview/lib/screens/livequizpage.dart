import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/session_state_provider.dart';
import 'package:termview/data/providers/sessionControllerProvider.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/widgets/snackbar.dart';

class Livequizpage extends ConsumerStatefulWidget {
  final bool? host;
  final bool? user;

  const Livequizpage({
    this.host,
    this.user,
    super.key,
  });

  @override
  ConsumerState<Livequizpage> createState() => _LivequizpageState();
}

class _LivequizpageState extends ConsumerState<Livequizpage> {
  int? _selectedOption;
  final ScrollController _scrollController = ScrollController();

  void _sendVote(String vote) {
    ref.read(Sessioncontrollerprovider).sendVote(vote);
    setState(() => _selectedOption = null);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final sessionState = ref.watch(sessionnotifierProvider);
    final currentQuiz = sessionState.quizzes.isNotEmpty ? sessionState.quizzes.last : null;
    ref.listen<SessionState>(sessionnotifierProvider , (previous , next){
      if(next.message != null && next.message != previous?.message){
        showTerminalSnackbar(context, next.message! , isError: false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> Homescreen()) , (route) => false);
      }
    });
    ref.listen<SessionState>(sessionnotifierProvider , (previous , next){
      if(next.reveal != null && next.reveal != previous?.reveal){
        showTerminalSnackbar(context, "The answer is ${next.reveal}" , isError: false);
      }
    });
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
                currentQuiz?['ques'] ?? "(Waiting for quiz...)",
                style: text.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text("Options", style: text.bodyLarge),
              const SizedBox(height: 5),
              ...List.generate(4, (index) {
                final optionText = currentQuiz?["op${index + 1}"] ?? "(waiting...)";
                return ListTile(
                  title: Text(optionText, style: text.bodyMedium),
                  leading: Radio<int>(
                    value: index,
                    groupValue: _selectedOption,
                    onChanged: (val) {
                      setState(() => _selectedOption = val);
                    },
                  ),
                );
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _selectedOption = null),
                      child: Text("Cancel", style: text.bodyMedium),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedOption != null && currentQuiz != null) {
                          final selectedAnswer = currentQuiz["op${_selectedOption! + 1}"];
                          _sendVote(selectedAnswer);
                        }
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
                  child: currentQuiz == null
                      ? Center(
                          child: Text(
                            "Waiting for quiz...",
                            style: text.bodyMedium!.copyWith(color: Colors.white),
                          ),
                        )
                      : ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          children: [
                            Text(
                              "Q: ${currentQuiz["ques"]}",
                              style: text.bodyLarge!.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            // Show each option and votes
                            ...List.generate(4, (index) {
                              final optionText = currentQuiz["op${index + 1}"];
                              final votesForOption = sessionState.votes
                                  .where((v) => v["choosed"] == optionText)
                                  .toList();

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${index + 1}. $optionText - Votes: ${votesForOption.length}",
                                      style: const TextStyle(color: Colors.greenAccent),
                                    ),
                                    // Show usernames who voted for this option
                                    ...votesForOption.map((v) => Padding(
                                          padding: const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            v["username"] ?? "Unknown",
                                            style: const TextStyle(color: Colors.white70),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.read(Sessioncontrollerprovider).revealAnswer(currentQuiz?["ans"]);
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
