//user model
class UserModel {
  final String userID;
  final String name;
  final String profileUrl;
  final String email;
  final String token;

  UserModel({
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
    );
  }

  //toJson
  Map<String, String> toJson() {
    return {
      'userID': userID,
      'name': name,
      'profileUrl': profileUrl,
      'email': email,
      'token': token,
    };
  }
}
