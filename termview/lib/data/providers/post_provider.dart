import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/post_notifier.dart';
import 'package:termview/data/repositories/post_repository.dart';

final PostrepositoryProvider = Provider<PostRepository>((ref){
  return PostRepository();
});

final PostnotiferProvider = StateNotifierProvider<PostNotifier , PostState>((ref){
  final repository = ref.watch(PostrepositoryProvider);
  return PostNotifier(repository);
});