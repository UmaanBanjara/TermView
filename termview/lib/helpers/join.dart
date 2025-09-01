import 'package:flutter/material.dart';
import 'package:termview/screens/joinedsession.dart';
import 'package:termview/widgets/page_transition.dart';

Future<void> joinsession(BuildContext context , {required VoidCallback onConfirm})async{
  final text = Theme.of(context).textTheme;
  await showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text('Join Session' , style: text.bodyLarge,),
      content: Text('Are you sure you want to join this session?' , style: text.bodyMedium,),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, 
        style: ElevatedButton.styleFrom(

        )
        ,child: Text('No')),

        ElevatedButton(onPressed: (){
          Navigator.pop(context);
          navigate(context, Joinesesion());
          onConfirm();
        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium,
        )
        ,child: Text('Yes'))
      ],
    );
  });
}