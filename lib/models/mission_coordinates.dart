import 'dart:convert';

class MissionCoordinates {
  final int id;
  final int missionId;
  final double latitude;
  final double longitude;

  MissionCoordinates({
    required this.id,
    required this.missionId,
    required this.latitude,
    required this.longitude,
  });

  factory MissionCoordinates.fromJson(Map<String, dynamic> json) {
    return MissionCoordinates(
      id: json['id'],
      missionId: json['missionId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'missionId': missionId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static List<MissionCoordinates> parseCoordinatesList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<MissionCoordinates>((json) => MissionCoordinates.fromJson(json))
        .toList();
  }
}
