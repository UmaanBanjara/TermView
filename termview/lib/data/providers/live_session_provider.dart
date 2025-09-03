import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/live_session_notifier.dart';
import 'package:termview/data/repositories/live_session_repository.dart';

final livesessionrepositoryProvider = Provider<LiveSessionRepository>((ref){
  return LiveSessionRepository();
});

final livesessionnotifierProvider = StateNotifierProvider<LiveSessionNotifier , LiveSessionState>((ref){
  final repository = ref.watch(livesessionrepositoryProvider);
  return LiveSessionNotifier(repository);
});

//provider for livesession