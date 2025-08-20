import 'package:flutter/material.dart';
import 'package:termview/screens/createsession.dart';
import 'package:termview/screens/settings.dart';
import 'package:termview/widgets/page_transition.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: Text("TermView", style: text.bodyLarge,),
        actions: [
          Padding(
            padding : EdgeInsets.symmetric(vertical: 8 , horizontal: 8),
            child: ElevatedButton(
              onPressed: (){
                navigate(context, Createsession());
              }, 
              style: ElevatedButton.styleFrom(
                textStyle: text.bodyMedium
              ),
              child: Text('Create Session +')
            ),
          ),
          IconButton(
            onPressed: (){
              navigate(context, Settings());
            }, 
            icon: Icon(Icons.settings)
          ),
        ],
      ),
    );
  }
}
