import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/live_session_provider.dart';
import 'package:termview/screens/joinedsession.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

Future<void> joinsession(BuildContext context , WidgetRef ref , String sessionId )async{
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

        ElevatedButton(
        onPressed: () async {
          Navigator.pop(context); 
          try {
            final success = await ref.read(livesessionnotifierProvider.notifier)
                .live_session(session_id: sessionId);

            if (success) {
              navigate(context, Joinesesion(sessionId: sessionId,));
            } else {
              showTerminalSnackbar(context, "Failed to join session", isError: true);
            }
          } catch (e) {
            showTerminalSnackbar(context, "Connection error: $e", isError: true);
          }
        },
        child: Text('Yes'),
      )

      ],
    );
  });
}