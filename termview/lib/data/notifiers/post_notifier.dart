import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/repositories/post_repository.dart';

class PostState{
  final bool loading;
  final String? message;
  final String? error;
  final String? postId;
  final String? title;
  final String? description;
  final String? link;
  final String? ses_id;

  PostState({
    this.loading = false,
    this.message,
    this.error,
    this.postId,
    this.title,
    this.description,
    this.link,
    this.ses_id,
  }); 

  PostState copyWith({
    bool? loading,
    String? message,
    String? error,
    String? postId,
    String? title,
    String? description,
    String? link,
    String? ses_id,
  }){
    return PostState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      error: error ?? this.error,
      postId: postId ?? this.postId,
      title: title ?? this.title,
      description: description ?? this.description,
      link: link ?? this.link,
      ses_id: ses_id ?? this.ses_id
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
        postId: result['post_id'].toString(),
        title: result['title'] ?? "Can't get title",
        description: result['desc'] ?? "Can't get description",
        link: result['link'] ?? "Can't get link",
        ses_id: result['ses_id'] ?? "Can't get session_id"

        
      );
    }catch(e){
      state = state.copyWith(
        loading: false,
        error: e.toString()
      );
    }
  }


}