import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/forpass_notifier.dart';
import 'package:termview/data/repositories/forpass_repository.dart';

final ForpassrepositoryProvider = Provider<ForpassRepository>((ref){
  return ForpassRepository();
});

final ForpassnotifierProvider = StateNotifierProvider<ForpassNotifier , ForpassState>((ref){
  final repository = ref.watch(ForpassrepositoryProvider);
  return ForpassNotifier(repository);
});