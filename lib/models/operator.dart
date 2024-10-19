import 'dart:convert';

class Operater {
  final int id;
  final String name;
  final String shift;

  Operater({
    required this.id,
    required this.name,
    required this.shift,
  });

  factory Operater.fromJson(Map<String, dynamic> json) {
    return Operater(
      id: json['id'],
      name: json['name'],
      shift: json['shift'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shift': shift,
    };
  }

  static List<Operater> parseOperaterList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Operater>((json) => Operater.fromJson(json)).toList();
  }
}
