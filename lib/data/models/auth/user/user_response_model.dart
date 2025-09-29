class UserResponseModel {
  final int id;
  final String name;
  final String email;
  final String role;

  UserResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}
