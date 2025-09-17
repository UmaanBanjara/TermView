import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionState{
  final List<Map<String , dynamic>> chats;
  final List<Map<String , dynamic>> commands;
  final List<Map<String , dynamic>> quizzes;
  final List<Map<String , dynamic>> votes;

  SessionState({
    this.chats = const [],
    this.commands = const [],
    this.quizzes = const [],
    this.votes = const []
  });


}
  class SessionNotifer extends StateNotifier<SessionState>{
    SessionNotifer() : super(SessionState());

    void addChat (Map<String , dynamic> chat){
      state = SessionState(
        chats: [...state.chats , chat],
        commands: state.commands,
        quizzes: state.quizzes,
        votes: state.votes,
      );
    }

    void addCommand (Map<String , dynamic> command){
      state = SessionState(
        chats: state.chats,
        commands: [...state.commands , command],
        quizzes: state.quizzes,
        votes: state.votes,
      );
    }

    void addquiz (Map<String , dynamic> quiz){
      state = SessionState(
        chats : state.chats,
        commands : state.commands,
        quizzes: [...state.quizzes , quiz],
        votes: state.votes,
      );
    }
    
    void addvoute (Map<String , dynamic> vote){
      state = SessionState(
        chats: state.chats,
        commands: state.commands,
        quizzes: state.quizzes,
        votes: [...state.votes , vote]
      );
    }
  }

  final sessionnotifierProvider = StateNotifierProvider<SessionNotifer , SessionState>((ref){
    return SessionNotifer();
  });