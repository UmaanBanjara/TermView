
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/forpass_repository.dart';

class ForpassState{
  final bool loading;
  final String? error;
  final String? message;

  ForpassState({
    this.loading = false,
    this.error,
    this.message
  });

  ForpassState copyWith({
    bool? loading,
    String? error,
    String? message
  }){
    return ForpassState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message
    );
  }
}

class ForpassNotifier extends StateNotifier<ForpassState>{
  final ForpassRepository repository;

  ForpassNotifier(this.repository) : super(ForpassState());

  Future<void> forpass({
    required String old_p,
    required String new_p,
    required String token,

  })async{
    state = state.copyWith(loading: true , error: null ,message: null);
    try{
      final result = await repository.forpass(old_p: old_p, new_p: new_p, token: token);
      state = state.copyWith(
        loading: false,
        message: result['message'] ?? "Password Change Successfully",
      );
    }
    catch(e){
      state = state.copyWith(
        loading: false,
        error: e.toString()
      );
    }
  }
}