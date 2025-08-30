import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/fetchall_notifier.dart';
import 'package:termview/data/repositories/fetchall_repository.dart';

final fetchallrepositoryProvider = Provider<FetchallRepository>((ref){
  return FetchallRepository();
});

final fetchallnotifierProvider = StateNotifierProvider<FetchallNotifier , FetchallState>((ref){
  final repository = ref.watch(fetchallrepositoryProvider);
  return FetchallNotifier(repository);
});