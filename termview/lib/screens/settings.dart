import 'package:flutter/material.dart';
import 'package:termview/screens/deleteacc/senddelemail.dart';
import 'package:termview/screens/forgotpass/sendemail.dart';
import 'package:termview/widgets/page_transition.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings Page', style: text.bodyLarge,),
            SizedBox(height: 10,),
            ListTile(
              onTap: (){
                navigate(context, Sendemail());
              },
              leading: Icon(Icons.lock_outline),
              title: Text("Forgot Password", style: text.bodyMedium,),
            ),
            ListTile(
              onTap: (){
                navigate(context, SendDelemail());
              },
              leading: Icon(Icons.delete_outline),
              title: Text("Delete Account" , style: text.bodyMedium,),
            ),
            ListTile(
              onTap: (){
                
              },
              leading: Icon(Icons.logout),
              title: Text("Logout" , style: text.bodyMedium,),
            ),
          ],
        ),
      ),
    );
  }
}
