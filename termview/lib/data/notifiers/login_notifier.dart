import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:termview/data/repositories/login_repository.dart';

class LoginState{
  final bool loading;
  final String? error;
  final String? message;


  LoginState({
    this.loading = false,
    this.error,
    this.message,
    
  });

  LoginState copyWith({
    bool? loading,
    String? error,
    String? message,  
    int? userId,
  }){
    return LoginState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}
class LoginNotifier extends StateNotifier<LoginState> {
  final LoginRepository repository;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  LoginNotifier(this.repository) : super(LoginState());

  Future<void> login(String email , String password)async{
    state = state.copyWith(loading: true , error: null , message: null);

    try{
      final result = await repository.login(email: email, password: password);
      
      //store the JWT TOKEN securely

      final token = result['access_token'];
      if (token != null){
        await _storage.write(key: "access_token", value: token);
      }
      

      state = state.copyWith(
        loading: false,
        message: result['message'],
        error: null,
      );
    }
    catch(e){
    state = state.copyWith(
      loading: false,
      error: e.toString()
    );
  }
  }

  Future<String?> getToken() async{
    return await _storage.read(key: "access_token");

  }
  
  
}