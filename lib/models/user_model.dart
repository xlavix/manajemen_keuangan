import 'dart:typed_data';

class User {
  final int? id;
  final String username;
  final String password;
  final String? email;
  final Uint8List? photo;
  final String? colorTheme;
  final String? connectedBank;

  User({
    this.id,
    required this.username,
    required this.password,
    this.email,
    this.photo,
    this.colorTheme,
    this.connectedBank,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'photo': photo,
      'colorTheme': colorTheme,
      'connectedBank': connectedBank,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      photo: map['photo'],
      colorTheme: map['colorTheme'],
      connectedBank: map['connectedBank'],
    );
  }
}
