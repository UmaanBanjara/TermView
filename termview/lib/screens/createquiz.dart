import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/sessionControllerProvider.dart';
import 'package:termview/data/providers/session_state_provider.dart';
import 'package:termview/screens/livequizpage.dart';
import 'package:termview/widgets/page_transition.dart';

class Createquiz extends ConsumerStatefulWidget {
  const Createquiz({super.key});

  @override
  ConsumerState<Createquiz> createState() => _CreatequizState();
}

class _CreatequizState extends ConsumerState<Createquiz> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ques = TextEditingController();
  final TextEditingController _ans = TextEditingController();
  final TextEditingController _op1 = TextEditingController();
  final TextEditingController _op2 = TextEditingController();
  final TextEditingController _op3 = TextEditingController();
  final TextEditingController _op4 = TextEditingController();

  @override
  void dispose(){
    _ques.dispose();
    _ans.dispose();
    _op1.dispose();
    _op2.dispose();
    _op3.dispose();
    _op4.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final sessionstate = ref.watch(sessionnotifierProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Time for a Quiz!',
          style: text.bodyLarge,
        ),
        leading: const BackButton(),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _ques,
                  cursorHeight: 22,
                  style: text.bodyMedium,
                  decoration:
                      const InputDecoration(hintText: "Enter your question"),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? "Question cannot be empty"
                          : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _op1,
                  cursorHeight: 22,
                  style: text.bodyMedium,
                  decoration: const InputDecoration(hintText: "Option 1"),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? "Option 1 cannot be empty"
                          : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _op2,
                  cursorHeight: 22,
                  style: text.bodyMedium,
                  decoration: const InputDecoration(hintText: "Option 2"),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? "Option 2 cannot be empty"
                          : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _op3,
                  cursorHeight: 22,
                  style: text.bodyMedium,
                  decoration: const InputDecoration(hintText: "Option 3"),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? "Option 3 cannot be empty"
                          : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _op4,
                  cursorHeight: 22,
                  style: text.bodyMedium,
                  decoration: const InputDecoration(hintText: "Option 4"),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? "Option 4 cannot be empty"
                          : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ans,
                  cursorHeight: 22,
                  style: text.bodyMedium,
                  decoration: const InputDecoration(
                      hintText: "Enter Answer of the question"),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? "Answer cannot be empty"
                          : null,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            final quizData = {
                              "ques" : _ques.text.trim(),
                              "op1" : _op1.text.trim(),
                              "op2" : _op2.text.trim(),
                              "op3" : _op3.text.trim(),
                              "op4" : _op4.text.trim(),
                              "ans" : _ans.text.trim()
                            };
                            ref.read(Sessioncontrollerprovider).sendQuiz(quizData);
                            _ques.clear();
                            _op1.clear();
                            _op2.clear();
                            _op3.clear();
                            _op4.clear();
                            _ans.clear();
                            navigate(context, Livequizpage(host: true,user: false,));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 50),
                            textStyle: text.bodyMedium),
                        child: const Text("Create"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            textStyle: text.bodyMedium,
                            minimumSize: const Size(0, 50)),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
