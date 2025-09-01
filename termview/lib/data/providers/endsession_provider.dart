import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/endsession_notifier.dart';
import 'package:termview/data/repositories/endsession_repository.dart';

final endsessionrepositoryProvider = Provider<EndsessionRepository>((ref){
  return EndsessionRepository();
});

final endsessionnotifierProvider = StateNotifierProvider<EndsessionNotifier , EndState>((ref){
  final repository = ref.watch(endsessionrepositoryProvider);
  return EndsessionNotifier(repository);
});