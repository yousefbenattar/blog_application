class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;

  User({this.id,this.name,this.email,this.image,this.token});
  // map json to user model
  factory User.fromJson(Map<String,dynamic> json){
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['image'],
      image: json['user']['email'],
      token: json['token']
    );
  }
}