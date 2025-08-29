import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/quiz_notifier.dart';
import 'package:termview/data/repositories/quiz_repository.dart';

final quizrepositoryProvider = Provider<QuizRepository>((ref){
  return QuizRepository();
});

final quiznotifierProvider = StateNotifierProvider<QuizNotifier , QuizState>((ref){
  final repository = ref.watch(quizrepositoryProvider);
  return QuizNotifier(repository);
});