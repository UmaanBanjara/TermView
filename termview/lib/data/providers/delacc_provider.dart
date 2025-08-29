import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/delacc_notifier.dart';
import 'package:termview/data/repositories/delacc_repository.dart';

final delaccrepositoryProvider = Provider<DelaccRepository>((ref){
  return DelaccRepository();
});

final delaccnotifierProvider = StateNotifierProvider<DelaccNotifier , DelaccState>((ref){
  final repository = ref.watch(delaccrepositoryProvider);
  return DelaccNotifier(repository);
});