import 'package:flutter/material.dart';
import 'package:termview/screens/loginscreen.dart';
import 'package:termview/theme/termview_theme.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TermviewTheme.darkTheme,
      home: Loginscreen(),
    );
  }
}