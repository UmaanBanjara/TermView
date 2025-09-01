import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/fetchall_repository.dart';
import 'package:termview/models/live_model.dart';

class FetchallState {
  final bool loading;
  final String? error;
  final String? message;
  final List<LiveModel>? sessions;

  FetchallState({
    this.loading = false,
    this.error,
    this.message,
    this.sessions
  });
  
  FetchallState copyWith({
    bool? loading,
    String? error,
    String? message,
    List<LiveModel>? sessions
  }){
    return FetchallState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message,
      sessions: sessions ?? this.sessions,
      
    );
  }
}

class FetchallNotifier extends StateNotifier<FetchallState>{
  final FetchallRepository repository;

  FetchallNotifier(this.repository) : super(FetchallState());

  Future<void> fetchall()async{
    try{
    state = state.copyWith(loading: true , error: null);
    final sessions = await repository.fetchall();
    state = state.copyWith(
      loading: false,
      sessions: sessions,
      message: sessions.isEmpty ? 'No Live Sessions Available' : 'Live Sessions Fetched Successfully'
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