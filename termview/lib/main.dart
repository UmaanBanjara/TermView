import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/screens/joinedsession.dart';
import 'package:termview/screens/loginscreen.dart';
import 'package:termview/theme/termview_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'access_token');

  runApp(
    ProviderScope(
      child: MyApp(
        token: token,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({this.token, super.key}); 

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: token != null ? '/' : '/login',
      routes: [
        GoRoute(path: '/', builder: (context, state) {
          return Homescreen();
        },),
        GoRoute(path: '/login' , builder: (context , state){
          return Loginscreen();
        }),
        GoRoute(path: '/live' , builder: (context , state){
          final sessionId = state.uri.queryParameters['session_id'];
          return Joinesesion(sessionId: sessionId,);
        })
      ]

    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: TermviewTheme.darkTheme,
      routerConfig: router,

    );
  }
}
