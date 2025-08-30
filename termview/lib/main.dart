import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/screens/loginscreen.dart';
import 'package:termview/theme/termview_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'access_token');

  runApp(
    ProviderScope(
      child: MyApp(
        startScreen: token != null ? Homescreen() : Loginscreen(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen; 
  const MyApp({required this.startScreen, super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TermviewTheme.darkTheme,
      home: startScreen, 
    );
  }
}
