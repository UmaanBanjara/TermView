import 'package:flutter/material.dart';
Future<void> chatsetting(BuildContext context , {required VoidCallback onConfirm}) async{
  final text = Theme.of(context).textTheme;
  await showDialog(context: context, builder: (context){
    return AlertDialog(
      title:  Text('Change chat setting' , style: text.bodyLarge,),
      content:  Text("Choose one to change the chat setting?" , style: text.bodyMedium,),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text('Chat Off' )),
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
          onConfirm();
        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium
        ),
        child: Text('Chat On'))
      ],
    );
  });
}