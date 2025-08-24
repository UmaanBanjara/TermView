import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/signup_repository.dart';

class SignupState{
  final bool loading;
  final String? error;
  final String? message;

  SignupState({
    this.loading = false,
    this.error,
    this.message,
  });

  SignupState copyWith({
    bool? loading,
    String? error,
    String? message,
  }){
    return SignupState(
      loading: loading ?? this.loading,
      error: error,
      message: message
    );
  }

}

class SignupNotifier extends StateNotifier<SignupState>{
  final SignupRepository repository;

  SignupNotifier(this.repository) : super(SignupState()); //starting with an empty state

  Future<void> signup(String fname , String lname , String username , String email , String password)async{

    state = state.copyWith(loading: true , error: null , message: null); 

    try{
      final result = await repository.signup(fname: fname , lname: lname , username: username , email: email , password: password);
      state = state.copyWith(
        loading: false,
        message: result['message'],
        error: null
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