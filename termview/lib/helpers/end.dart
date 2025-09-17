import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/endsession_provider.dart';
import 'package:termview/data/providers/sessionControllerProvider.dart';
Future<void> endsession(BuildContext context,WidgetRef ref , String postId) async{
  final parentContext = context;
  final text = Theme.of(context).textTheme;


  await showDialog(context: context, builder: (dialogContext){
    return AlertDialog(
      title:  Text('End Session' , style: text.bodyLarge,),
      content:  Text("Are you sure you want to end this session?" , style: text.bodyMedium,),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(dialogContext);
        }, child: const Text('No' )),
        ElevatedButton(onPressed: (){
          Navigator.pop(dialogContext);
          ref.read(endsessionnotifierProvider.notifier).endsession(id: postId);

          ref.read(Sessioncontrollerprovider).endSession();
          
          
        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium
        ),
        child: Text('Yes'))
      ],
    );
  });
}