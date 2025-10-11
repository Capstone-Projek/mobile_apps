class ChangeProfileRequest {
  final String email;
  final String name;

  ChangeProfileRequest({required this.email, required this.name});

  Map<String, dynamic> toJson() => {"email": email, "name": name};
}
