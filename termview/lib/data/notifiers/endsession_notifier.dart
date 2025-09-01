
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/endsession_repository.dart';

class EndState{
  final bool loading;
  final String? error;
  final String? message;

  EndState({
    this.loading = false,
    this.error,
    this.message,
  });

  EndState copyWith({
    bool? loading,
    String? error,
    String? message,
  }){
    return EndState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message
    );
  }
}

class EndsessionNotifier extends StateNotifier<EndState>{
  final EndsessionRepository repository;

  EndsessionNotifier(this.repository) : super(EndState());

  Future<void> endsession({
    required String id
  }) async{
    state = state.copyWith(loading: true , error: null);
    try{
      final result = await repository.endsession(post_id: id);
      state = state.copyWith(
        loading: false,
        message: result['message'] ?? "Session Ended Successfully",
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