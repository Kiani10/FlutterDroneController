import 'dart:convert';

class Login {
  final int id;
  final String name;
  final String passwrd;
  final String role;

  Login({
    required this.id,
    required this.name,
    required this.passwrd,
    required this.role,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      id: json['id'],
      name: json['name'],
      passwrd: json['passwrd'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'passwrd': passwrd,
      'role': role,
    };
  }

  static List<Login> parseLoginList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Login>((json) => Login.fromJson(json)).toList();
  }
}
