class UserModel {
  String username;
  String email;
  String password;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
  });

  factory UserModel.fromMap({required Map data}) => UserModel(
        username: data['username'],
        email: data["email"],
        password: data["password"],
      );
}
