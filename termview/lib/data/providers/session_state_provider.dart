import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionState{
  final List<Map<String , dynamic>> chats;
  final List<Map<String , dynamic>> commands;
  final List<Map<String , dynamic>> quizzes;
  final List<Map<String , dynamic>> votes;
  final String? message;
  final int? joined;
  final String? reveal;

  final bool haschat;
  final bool hasquiz;

  SessionState({
    this.chats = const [],
    this.commands = const [],
    this.quizzes = const [],
    this.votes = const [],
    this.message,
    this.joined,
    this.reveal,
    this.haschat =false,
    this.hasquiz = false
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
        message: state.message,
        joined: state.joined,
        reveal: state.reveal,
        haschat: true,
        hasquiz: state.hasquiz
      );
    }

    void addCommand (Map<String , dynamic> command){
      state = SessionState(
        chats: state.chats,
        commands: [...state.commands , command],
        quizzes: state.quizzes,
        votes: state.votes,
        message: state.message,
        joined: state.joined,
        reveal: state.reveal,
        haschat: state.haschat,
        hasquiz: state.hasquiz,
      );
    }

    void addquiz (Map<String , dynamic> quiz){
      state = SessionState(
        chats : state.chats,
        commands : state.commands,
        quizzes: [...state.quizzes , quiz],
        votes: state.votes,
        message: state.message,
        joined: state.joined,
        reveal: state.reveal,
        haschat: state.haschat,
        hasquiz: true
      );
    }
    
    void addvoute (Map<String , dynamic> vote){
      state = SessionState(
        chats: state.chats,
        commands: state.commands,
        quizzes: state.quizzes,
        votes: [...state.votes , vote],
        message: state.message,
        joined: state.joined,
        reveal: state.reveal
      );
    }

    void endMessage(String message){
      state = SessionState(
        chats: state.chats,
        commands: state.commands,
        quizzes: state.quizzes,
        votes: state.votes,
        message: message,
        joined: state.joined,
        reveal: state.reveal
      );
    }

    void updateJoined(int count){
      state = SessionState(
        chats: state.chats,
        commands: state.commands,
        quizzes: state.quizzes,
        votes: state.votes,
        message: state.message,
        joined: count,
        reveal: state.reveal
      );
    }
    void revealAnswer(String answer){
      state = SessionState(
        chats : state.chats,
        commands: state.commands,
        quizzes: state.quizzes,
        votes: state.votes,
        message: state.message,
        joined: state.joined,
        reveal: answer
      );
    }

    void resetChatIndicator() => state = SessionState(
    chats: state.chats,
    commands: state.commands,
    quizzes: state.quizzes,
    votes: state.votes,
    message: state.message,
    joined: state.joined,
    reveal: state.reveal,
    haschat: false,
    hasquiz: state.hasquiz,
);

void resetQuizIndicator() => state = SessionState(
    chats: state.chats,
    commands: state.commands,
    quizzes: state.quizzes,
    votes: state.votes,
    message: state.message,
    joined: state.joined,
    reveal: state.reveal,
    haschat: state.haschat,
    hasquiz: false,
);

  }
  

  final sessionnotifierProvider = StateNotifierProvider<SessionNotifer , SessionState>((ref){
    return SessionNotifer();
  });