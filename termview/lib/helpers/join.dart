import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/providers/live_session_provider.dart';
import 'package:termview/screens/joinedsession.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

Future<void> joinsession(
  BuildContext context,
  WidgetRef ref,
  String sessionId,
  String? title,
  String? desc,
) async {
  // Capture the original context for safe use after async operations
  final parentContext = context;
  final text = Theme.of(context).textTheme;

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
              // Close the dialog first
              Navigator.pop(dialogContext);

              // Use Future.microtask to ensure async operation happens after dialog is closed
              Future.microtask(() async {
                try {
                  // Perform the live session join
                  final success = await ref
                      .read(livesessionnotifierProvider.notifier)
                      .live_session(session_id: sessionId);

                  // Navigate to the joined session page using the safe context
                  navigate(parentContext, Joinesesion(sessionId: sessionId , title: title , desc: desc,));
                } catch (e) {
                  // Show snackbar using the safe context
                  showTerminalSnackbar(
                    parentContext,
                    "Connection error: $e",
                    isError: true,
                  );
                }
              });
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
