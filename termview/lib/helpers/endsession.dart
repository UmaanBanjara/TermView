import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/endsession_provider.dart';
Future<void> endsession(BuildContext context , WidgetRef ref , String sessionId) async{
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
          ref.read(endsessionnotifierProvider.notifier).endsession(id: sessionId);
          
        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium
        ),
        child: Text('End'))
      ],
    );
  });
}