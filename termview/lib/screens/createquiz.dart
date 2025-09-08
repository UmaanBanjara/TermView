import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:termview/data/notifiers/quiz_notifier.dart';
import 'package:termview/data/providers/login_provider.dart';
import 'package:termview/data/providers/quiz_provider.dart';
import 'package:termview/screens/livequizpage.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Createquiz extends ConsumerStatefulWidget {
  final WebSocketChannel? channel;
  final Stream? broadcastStream;
  const Createquiz({this.broadcastStream, this.channel ,super.key});

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

  void _createquiz(){
    try{
    
      if(_ques.text.isNotEmpty && _ans.text.isNotEmpty && _op1.text.isNotEmpty && _op2.text.isNotEmpty && _op3.text.isNotEmpty && _op4.text.isNotEmpty && widget.channel != null){
      widget.channel!.sink.add(jsonEncode({
        "type" : "quiz",
        "ques" : _ques.text,
        "ans" : _ans.text,
        "op1" : _op1.text,
        "op2" : _op2.text,
        "op3" : _op3.text,
        "op4" : _op4.text
      }));
      WidgetsBinding.instance.addPostFrameCallback((_){
        if(widget.channel != null && widget.broadcastStream != null){

        
        showTerminalSnackbar(context, "Quiz is live" ,isError: false);
        navigate(context, Livequizpage(host: true,user: false,channel: widget.channel!,broadcastStream: widget.broadcastStream!,));

        }
      });
    }
    }
    catch(e){
      showTerminalSnackbar(context, "Something went wrong : $e" , isError: true);
      return;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final quizstate = ref.watch(quiznotifierProvider);
    ref.listen<QuizState>(quiznotifierProvider , (previous , next){
      if(next.message!=null && next.message != previous?.message){
        showTerminalSnackbar(context, next.message! , isError: false);
        Navigator.pop(context);
      }
      else if (next.error != null && next.error != previous?.error){
        WidgetsBinding.instance.addPostFrameCallback((_){
          showTerminalSnackbar(context, next.error! , isError: true);
          return;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Time for a Quiz!' , style: text.bodyLarge,),
        leading: BackButton(),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _ques,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter your question"
                ),
                validator: (value) => value == null || value.isEmpty ? "Question cannot be empty" : null,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _op1,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Option 1"
                ),
                validator: (value) => value == null || value.isEmpty ? "Option 1 cannot be empty" : null,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _op2,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Option 2"
                ),
                validator: (value) => value == null || value.isEmpty ? "Option 2 cannot be empty" : null,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _op3,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Option 3"
                ),
                validator: (value) => value == null || value.isEmpty ? "Option 3 cannot be empty" : null,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _op4,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Option 4"
                ),
                validator: (value) => value == null || value.isEmpty ? "Option 4 cannot be empty" : null,
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _ans,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter Answer of the question"
                ),
                validator: (value) => value == null || value.isEmpty ? "Answer cannot be empty" : null,
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: quizstate.loading ? Center(child: SpinKitFadingFour(color: Colors.white,),)
                    :
                    ElevatedButton(
                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          final token = await ref.read(LoginnotifierProvider.notifier).getToken();
                          if(token == null){
                            showTerminalSnackbar(context, "Invalid Token" , isError: true);
                            return;
                          }
                          await ref.read(quiznotifierProvider.notifier).quiz(
                            token: token, 
                            ques: _ques.text, 
                            a1: _op1.text,
                            a2: _op2.text, 
                            a3: _op3.text, 
                            a4: _op4.text, 
                            ans: _ans.text
                          );

                          _createquiz();
                        }
                        
                      }, 
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(0, 50),
                        textStyle: text.bodyMedium
                      ),
                      child: Text("Create")
                    ),
                  ), 
                  SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      style: ElevatedButton.styleFrom(
                        textStyle: text.bodyMedium,
                        minimumSize: Size(0, 50)
                      ),
                      child: Text('Cancel')
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
