import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/sessionControllerProvider.dart';
import 'package:termview/screens/homescreen.dart';
Future<void> leavesession (BuildContext context , WidgetRef ref ) async{
  final text = Theme.of(context).textTheme;
  await showDialog(context: context, builder: (context){
    return AlertDialog(
      title:  Text('End Session' , style: text.bodyLarge,),
      content:  Text("Are you sure you want to leave this session?" , style: text.bodyMedium,),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text('Cancel' )),
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
          ref.read(Sessioncontrollerprovider).disconnect();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Homescreen()), (route) => false);

        }, 
        style: ElevatedButton.styleFrom(
          textStyle: text.bodyMedium
        ),
        child: Text('End'))
      ],
    );
  });
}