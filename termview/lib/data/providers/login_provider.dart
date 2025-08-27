import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/login_notifier.dart';
import 'package:termview/data/repositories/login_repository.dart';

final LoginrepositoryProvider = Provider<LoginRepository>((ref){
  return LoginRepository();
});

final LoginnotifierProvider = StateNotifierProvider<LoginNotifier , LoginState >((ref){
  final repository = ref.watch(LoginrepositoryProvider);
  return LoginNotifier(repository);
});