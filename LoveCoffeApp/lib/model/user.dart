class User {
  String? id;
  String name;
  String email;
  String password;

  User(
      {this.id,
      required this.name,
      required this.email,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'password': password};
}
