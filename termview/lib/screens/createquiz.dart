import 'package:flutter/material.dart';

class Createquiz extends StatefulWidget {
  const Createquiz({super.key});

  @override
  State<Createquiz> createState() => _CreatequizState();
}

class _CreatequizState extends State<Createquiz> {
  final TextEditingController _ques = TextEditingController();
  final TextEditingController _ans = TextEditingController();
  final TextEditingController _op1 = TextEditingController();
  final TextEditingController _op2 = TextEditingController();
  final TextEditingController _op3 = TextEditingController();
  final TextEditingController _op4 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Time for a Quiz!' , style: text.bodyLarge,),
        leading: BackButton(),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ques,
              cursorHeight: 22,
              style: text.bodyMedium,
              decoration: InputDecoration(
                hintText: "Enter your question"
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _op1,
              cursorHeight: 22,
              style: text.bodyMedium,
              decoration: InputDecoration(
                hintText: "Option 1"
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _op2,
              cursorHeight: 22,
              style: text.bodyMedium,
              decoration: InputDecoration(
                hintText: "Option 2"
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _op3,
              cursorHeight: 22,
              style: text.bodyMedium,
              decoration: InputDecoration(
                hintText: "Option 3"
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _op4,
              cursorHeight: 22,
              style: text.bodyMedium,
              decoration: InputDecoration(
                hintText: "Option 4"
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _ans,
              cursorHeight: 22,
              style: text.bodyMedium,
              decoration: InputDecoration(
                hintText: "Enter Answer of the question"
              ),
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                      child: ElevatedButton(onPressed: (){
                      
                      }, 
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(0, 50),
                        textStyle: text.bodyMedium
                      )
                      ,child: Text("Create")),
                    ), 
            
                  SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                      minimumSize: Size(0, 50)
                    )
                    ,child: Text('Cancel')),
                  ),
 
              ],
            )

          ],
        ),
      ),
    );
  }
}