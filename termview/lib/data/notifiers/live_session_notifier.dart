
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/live_session_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveSessionState{
  final bool loading;
  final String? error;
  final String? message;

  LiveSessionState({
    this.loading = false,
    this.error,
    this.message
  });

  LiveSessionState copyWith({
    bool? loading,
    String? error,
    String? message
  }){
    return LiveSessionState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message
    );
  }
}
class LiveSessionNotifier extends StateNotifier<LiveSessionState>{ //statenotifier for livesession
  final LiveSessionRepository repository;

  LiveSessionNotifier(this.repository) : super(LiveSessionState());

  Future<WebSocketChannel> live_session({
    required String session_id,
  })async{
    state = state.copyWith(loading: true , error: null);
    try{
      final channel = await repository.connect(session_id);
      state = state.copyWith(loading: false ,message : "Connection made successfully" );
      return channel;
    }
    catch(e){
      state = state.copyWith(
        loading: false,
        error: "Failed to make connection"
      );
      rethrow;
    }
  }
}