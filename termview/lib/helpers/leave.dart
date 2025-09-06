import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/widgets/page_transition.dart';

import 'package:termview/widgets/snackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> leavesession(BuildContext context, WebSocketChannel? channel ,String sessionId) async{
  final parentContext = context;
  final text = Theme.of(context).textTheme;

  if(channel == null){
    showTerminalSnackbar(parentContext, "Not Connected" , isError: true);
    return;
  }
  await showDialog(context: context, builder: (dialogContext){
    return AlertDialog(
      title:  Text('End Session' , style: text.bodyLarge,),
      content:  Text("Are you sure you want to leave this session?" , style: text.bodyMedium,),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(dialogContext);
        }, child: const Text('No' )),
        ElevatedButton(onPressed: (){
          Navigator.pop(dialogContext);

          Future.microtask(()async{
            try{
              channel!.sink.add(jsonEncode({
                "type" : "sessionended"
              }));

              await channel!.sink.close();
              showTerminalSnackbar(parentContext, "Session Ended Successfully" , isError: false);
              navigate(parentContext, Homescreen());
            }
            catch(e){
              showTerminalSnackbar(context, "Connection error, Please try again" , isError: true);
            }
          });
        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium
        ),
        child: Text('Yes'))
      ],
    );
  });
}