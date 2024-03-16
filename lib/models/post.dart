import 'user.dart';

class Post {
  int? id;
  String? body;
  String? image;
  int? likecount;
  int? commentscount;
  User? user;
  bool? selfLiked;
  Post({
    this.id,
    this.body,
    this.image,
    this.likecount,
    this.commentscount,
    this.user,
    this.selfLiked
  });
  // map json to post model
  factory Post.fromJson(Map<String,dynamic> json){
    return Post(
    id: json['id'],
    body: json['body'],
    image: json['image'],
    likecount: json['likes_count'],
    commentscount: json['comments_count'],
    selfLiked: json['likes'].length > 0,
    user: User(
      id: json['user']['id'],
      name: json['user']['id'],
      email: json['user']['image']
    )
  );
  }
}

