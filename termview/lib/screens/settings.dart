import 'package:flutter/material.dart';
import 'package:termview/screens/deleteacc/deleteacc.dart';
import 'package:termview/screens/forgotpass/resetpass.dart';
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(),
        centerTitle: false,
        title: Text('Settings', style: text.bodyLarge,),

      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: (){
                  navigate(context, Resetpass());
                },
                leading: Icon(Icons.lock_outline),
                title: Text("Change Password", style: text.bodyMedium,),
              ),
              ListTile(
                onTap: (){
                  navigate(context, Deleteacc());
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
      ),
    );
  }
}
