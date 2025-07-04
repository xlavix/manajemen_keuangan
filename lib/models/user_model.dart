import 'dart:typed_data';

class User {
  final int? id;
  final String username;
  final String password;
  final Uint8List? photo;
  final String? colorTheme;

  User({
    this.id,
    required this.username,
    required this.password,
    this.photo,
    this.colorTheme,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'photo': photo,
      'colorTheme': colorTheme,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      photo: map['photo'],
      colorTheme: map['colorTheme'],
    );
  }
}
