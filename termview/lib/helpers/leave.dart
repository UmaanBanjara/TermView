import 'package:flutter/material.dart';

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
              await channel.sink.close();
              showTerminalSnackbar(parentContext, "Disconnected From Session" , isError: false);

            }
            catch(e){
              showTerminalSnackbar(parentContext, "Connection error : $e" , isError: true);
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