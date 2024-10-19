import 'dart:convert';

class Mission {
  final int id;
  final String missionDatetime;
  final String locationPad;
  final String? img;
  final int droneId;

  Mission({
    required this.id,
    required this.missionDatetime,
    required this.locationPad,
    this.img,
    required this.droneId,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      missionDatetime: json['missionDatetime'],
      locationPad: json['locationPad'],
      img: json['img'],
      droneId: json['droneId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'missionDatetime': missionDatetime,
      'locationPad': locationPad,
      'img': img,
      'droneId': droneId,
    };
  }

  static List<Mission> parseMissionList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Mission>((json) => Mission.fromJson(json)).toList();
  }
}
