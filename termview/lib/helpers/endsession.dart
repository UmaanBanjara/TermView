import 'package:flutter/material.dart';
Future<void> endsession(BuildContext context , {required VoidCallback onConfirm}) async{
  final text = Theme.of(context).textTheme;
  await showDialog(context: context, builder: (context){
    return AlertDialog(
      title:  Text('End Session' , style: text.bodyLarge,),
      content:  Text("Are you sure you want to end this session?" , style: text.bodyMedium,),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text('Cancel' )),
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
          onConfirm();
        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium
        ),
        child: Text('End'))
      ],
    );
  });
}