
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/quiz_repository.dart';

class QuizState{
  final bool loading;
  final String? error;
  final String? message;

  QuizState({
    this.loading = false,
    this.error,
    this.message
  });

  QuizState copyWith({
    bool? loading,
    String? error,
    String? message,
  }){
    return QuizState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message
    );
  }
}
class QuizNotifier extends StateNotifier<QuizState>{
  final QuizRepository repository;

  QuizNotifier(this.repository) : super(QuizState());

  Future<void> quiz({
    required String token,
    required String ques,
    required String a1,
    required String a2,
    required String a3,
    required String a4,
    required String ans
  })async{
    state = state.copyWith(
      loading: false
    );
    try{
      final result = await repository.quiz(token: token, ques: ques, a1: a1, a2: a2, a3: a3, a4: a4, ans: ans);
      state = state.copyWith(
        loading: false,
        message: result['detail'] ?? "Quiz Created Successfully"
      );
    }
    catch(e){
      state = state.copyWith(
        error: e.toString()
      );
    }
  }
}