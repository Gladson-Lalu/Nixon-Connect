//user model
class UserModel {
  final String id;
  final String userID;
  final String name;
  final String profileUrl;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.userID,
    required this.name,
    required this.profileUrl,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: json['userID'] ?? '',
      name: json['name'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      id: json['id'] ?? '',
    );
  }

  //toJson
  Map<String, String> toJson() {
    return {
      'id': id,
      'userID': userID,
      'name': name,
      'profileUrl': profileUrl,
      'email': email,
      'token': token,
    };
  }
}
