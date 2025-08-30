class LiveModel {
  final int postId;
  final String thumbnail;
  final String title;
  final String desc;
  final bool is_live;
  final bool is_chat;

  LiveModel({
    required this.postId,
    required this.thumbnail,
    required this.title,
    required this.desc,
    required this.is_live,
    required this.is_chat
  });

  factory LiveModel.fromJson(Map<String,dynamic> json){
    return LiveModel(
      postId: json['post_id'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      desc: json['desc'],
      is_live: json['is_live'],
      is_chat: json['is_chat']

    );
  }
  Map<String , dynamic> toJson(){
    return{
      'post_id' : postId,
      'thumbnail' : thumbnail,
      'title' : title,
      'desc' : desc,
      'is_live' : is_live,
      'is_chat' : is_chat
    };
  }
}