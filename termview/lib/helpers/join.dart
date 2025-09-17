import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:termview/data/providers/sessionControllerProvider.dart';
import 'package:termview/screens/joinedsession.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';


Future<void> joinsession(
  BuildContext context,
  WidgetRef ref,
  String sessionId,
  String? title,
  String? desc,
  bool? is_chat,
) async {
  // Capture the original context for safe use after async operations
  final parentContext = context;
  final text = Theme.of(context).textTheme;
  final storage = const FlutterSecureStorage();

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          'Join Session',
          style: text.bodyLarge,
        ),
        content: Text(
          'Are you sure you want to join this session?',
          style: text.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
            Navigator.pop(dialogContext);
            final token = await storage.read(key: 'access_token');
            if (sessionId.trim().isNotEmpty && token != null) {
              ref.read(Sessioncontrollerprovider).connect(
                'wss://termview-backend.onrender.com/ws/$sessionId?token=$token'
              );
              navigate(parentContext, Joinesesion(sessionId: sessionId,title: title,desc: desc,is_chat: is_chat,));
            } else {
              showTerminalSnackbar(parentContext, "Either SessionId or token is null", isError: true);
            }
          }
          ,
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
