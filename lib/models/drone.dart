import 'dart:convert';

class Drone {
  final int id;
  final String name;
  final double ceiling;
  final double speed;
  final double battery;
  final double payload;

  Drone({
    required this.id,
    required this.name,
    required this.ceiling,
    required this.speed,
    required this.battery,
    required this.payload,
  });

  factory Drone.fromJson(Map<String, dynamic> json) {
    return Drone(
      id: json['id'],
      name: json['name'],
      ceiling: json['ceiling'].toDouble(),
      speed: json['speed'].toDouble(),
      battery: json['battery'].toDouble(),
      payload: json['payload'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ceiling': ceiling,
      'speed': speed,
      'battery': battery,
      'payload': payload,
    };
  }

  static List<Drone> parseDroneList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Drone>((json) => Drone.fromJson(json)).toList();
  }
}
