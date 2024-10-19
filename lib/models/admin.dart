import 'dart:convert';

class Admin {
  final int id;
  final String department;

  Admin({
    required this.id,
    required this.department,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department': department,
    };
  }

  static List<Admin> parseAdminList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Admin>((json) => Admin.fromJson(json)).toList();
  }
}
