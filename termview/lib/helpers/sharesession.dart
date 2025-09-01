import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:termview/widgets/snackbar.dart';
Future<void> sharesession(BuildContext context , {required String link}) async{
  final text = Theme.of(context).textTheme;
  await showDialog(context: context, builder: (context){
    return AlertDialog(
      title:  Text('End Session' , style: text.bodyLarge,),
      content:  Text("Copy Link to ClipBoard" , style: text.bodyMedium,),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text('Cancel' )),
        ElevatedButton(onPressed: (){
          Clipboard.setData(ClipboardData(text: link));
          Navigator.pop(context);
          showTerminalSnackbar(context, 'Link Copied to Clipboard' , isError: false);
        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium
        ),
        child: Text('Copy'))
      ],
    );
  });
}