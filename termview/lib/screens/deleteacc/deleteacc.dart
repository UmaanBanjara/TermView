import 'package:flutter/material.dart';
import 'package:termview/screens/loginscreen.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Deleteacc extends StatefulWidget {
  const Deleteacc({super.key});

  @override
  State<Deleteacc> createState() => _DeleteaccState();
}

class _DeleteaccState extends State<Deleteacc> {
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                          showTerminalSnackbar(context, 'Account deleted successfully', isError: false);
                          navigate(context, Loginscreen());
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: text.bodyMedium,
                      ),
                      child: Text('Delete account'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: text.bodyMedium,
                      ),
                      child: Text('Cancel'),
                    ),
                  ),

          ],
        ),
      ),
    );
  }
}