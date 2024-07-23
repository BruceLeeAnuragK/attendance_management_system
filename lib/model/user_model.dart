class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String role;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}
