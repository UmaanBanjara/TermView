class LiveModel {
  final int postId;
  final String thumbnail;
  final String title;
  final String desc;
  final bool is_live;
  final bool is_chat;
  final String? username;
  final String session_id;

  LiveModel({
    required this.postId,
    required this.thumbnail,
    required this.title,
    required this.desc,
    required this.is_live,
    required this.is_chat,
    this.username,
    required this.session_id
  });

  factory LiveModel.fromJson(Map<String,dynamic> json){ //factory
    return LiveModel(
      postId: json['id'] as int,
      thumbnail: json['thumb'] ?? '',
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      is_live: json['is_live'] as bool? ?? false,
      is_chat: json['is_chat'] as bool? ?? false,
      username : json['user_id'] as String?,
      session_id: json['session_id'] ?? '',

    );
  }
  Map<String , dynamic> toJson(){
    return{
      'post_id' : postId,
      'thumbnail' : thumbnail,
      'title' : title,
      'desc' : desc,
      'is_live' : is_live,
      'is_chat' : is_chat,
      'user_id' : username,
      'session_id' : session_id
    };
  }
}