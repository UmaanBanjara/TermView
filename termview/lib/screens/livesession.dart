import 'package:flutter/material.dart';
import 'package:termview/helpers/endsession.dart';
import 'package:termview/screens/createquiz.dart';
import 'package:termview/screens/showlivechat.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Livesession extends StatefulWidget {
  const Livesession({super.key});

  @override
  State<Livesession> createState() => _LivesessionState();
}

class _LivesessionState extends State<Livesession> {
  final TextEditingController _command = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 70,
        titleSpacing: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Session Title" , style: text.bodyLarge,),
            Text("host username" , style: text.bodyMedium,),
            
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: text.bodyMedium,
              ),
              child: const Text("10 Joined"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: text.bodyMedium,
              ),
              child: const Text("Share Session"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                navigate(context, Createquiz());
              },
              style: ElevatedButton.styleFrom(
                textStyle: text.bodyMedium,
              ),
              child: const Text("Create Quiz"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                navigate(context, Showlivechat());
              },
              style: ElevatedButton.styleFrom(
                textStyle: text.bodyMedium,
              ),
              child: const Text("Chats"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                endsession(context, onConfirm: (){
                  showTerminalSnackbar(context, 'Session ended' , isError: false); 
                });
              },
              style: ElevatedButton.styleFrom(
                textStyle: text.bodyMedium,
                backgroundColor: Colors.red,
              ),
              child: const Text("End Session"),
            ),
          ),
        ],
        
      ),

      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.black87,
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text("Terminal Commands" , style: text.bodyMedium,),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _command,
                    cursorHeight: 22,
                    style: text.bodyMedium,
                    decoration: InputDecoration(
                      hintText: "Enter commands",
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                ElevatedButton(onPressed: (){
        
                }, 
                style: ElevatedButton.styleFrom(
                  textStyle: text.bodyMedium
                )
                ,child: Text('Send'))
              ],
            )
          ],
        ),
      ),
    );
  }
}