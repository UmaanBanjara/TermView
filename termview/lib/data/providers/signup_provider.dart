import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/signup_notifier.dart';
import 'package:termview/data/repositories/signup_repository.dart';

final signupRepostiryProvider = Provider<SignupRepository>((ref){
  return SignupRepository();
});

final signupNotifierProvider = StateNotifierProvider<SignupNotifier , SignupState>((ref){
  final repository = ref.watch(signupRepostiryProvider);
  return SignupNotifier(repository);
});