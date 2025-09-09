import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/screens/loginscreen.dart';
import 'package:termview/theme/termview_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  Future<String?> _getToken() async {
    final _storage = FlutterSecureStorage();
    return _storage.read(key: 'access_token');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TermviewTheme.darkTheme,
      home: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: TermviewTheme.darkTheme.scaffoldBackgroundColor,
              body: Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              ),
            );
          }

          final token = snapshot.data;
          return token != null ? Homescreen() : Loginscreen();
        },
      ),
    );
  }
}
