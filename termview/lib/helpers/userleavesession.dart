import 'package:flutter/material.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/widgets/page_transition.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
Future<void> usersleavesession(BuildContext context , WebSocketChannel? ch) async{
  final parentContext = context;
  final text = Theme.of(context).textTheme;
  await showDialog(context: context, builder: (dialogContext){
    return AlertDialog(
      title:  Text('Leave Session' , style: text.bodyLarge,),
      content:  Text("Are you sure you want to leave this session?" , style: text.bodyMedium,),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(dialogContext);
        }, child: const Text('Cancel' )),
        ElevatedButton(onPressed: (){
          Navigator.pop(dialogContext);
          
         ch?.sink.close();
         navigate(context, Homescreen());
          
          
        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium
        ),
        child: Text('Leave'))
      ],
    );
  });
}