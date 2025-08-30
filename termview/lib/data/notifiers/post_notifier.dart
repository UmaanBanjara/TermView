import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/post_repository.dart';

class PostState{
  final bool loading;
  final String? message;
  final String? error;

  PostState({
    this.loading = false,
    this.message,
    this.error,
  }); 

  PostState copyWith({
    bool? loading,
    String? message,
    String? error,
  }){
    return PostState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      error: error ?? this.error
    );
  }
}

class PostNotifier extends StateNotifier<PostState>{
  final PostRepository repository;

  PostNotifier(this.repository) : super(PostState());

  Future<void> post({
    required String title ,
    required String desc , 
    required Uint8List fileBytes,
    required String fileName,
    required bool enableChat,
    required bool islive,
    required String token,
  })async{
    state = state.copyWith(loading: true , error: null , message: null);

    try{
      final result = await repository.post(title: title, desc: desc, fileBytes: fileBytes, fileName: fileName,enableChat: enableChat , islive: islive,token: token);
      state = state.copyWith(
        loading: false, 
        message: result['message'] ?? "Post uploaded successfully",
        
      );
    }catch(e){
      state = state.copyWith(
        loading: false,
        error: e.toString()
      );
    }
  }


}