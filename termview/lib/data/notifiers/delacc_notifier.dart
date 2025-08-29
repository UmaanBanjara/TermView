
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/delacc_repository.dart';

class DelaccState{
  final bool loading;
  final String? error;
  final String? message;

  DelaccState({
    this.loading = false,
    this.error,
    this.message,
  });

  DelaccState copyWith({
    bool? loading,
    String? error,
    String? message,
  }){
    return DelaccState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message:  message ?? this.message
    );
  }
}
class DelaccNotifier extends StateNotifier<DelaccState>{
  final DelaccRepository repository;

  DelaccNotifier(this.repository) : super(DelaccState());

  Future<void> delacc({
    required String old_p,
    required String token
  })async{
    state = state.copyWith(loading: true , error: null , message:  null);
    try{
      final result = await repository.delacc(old_p: old_p, token: token);
      state = state.copyWith(
        loading: false,
        message: result['Success'] ?? "Deleted Successfully"
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