import 'dart:typed_data';

class User {
  final int? id;
  final String username;
  final String password;
  final String? email; // <-- TAMBAHKAN INI
  final Uint8List? photo;
  final String? colorTheme;

  User({
    this.id,
    required this.username,
    required this.password,
    this.email, // <-- TAMBAHKAN INI
    this.photo,
    this.colorTheme,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email, // <-- TAMBAHKAN INI
      'photo': photo,
      'colorTheme': colorTheme,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'], // <-- TAMBAHKAN INI
      photo: map['photo'],
      colorTheme: map['colorTheme'],
    );
  }
}