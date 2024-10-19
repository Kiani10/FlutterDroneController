import 'dart:convert';

class StationDroneRecord {
  final int id;
  final int droneId;
  final int stationId;

  StationDroneRecord({
    required this.id,
    required this.droneId,
    required this.stationId,
  });

  factory StationDroneRecord.fromJson(Map<String, dynamic> json) {
    return StationDroneRecord(
      id: json['id'],
      droneId: json['droneId'],
      stationId: json['stationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'droneId': droneId,
      'stationId': stationId,
    };
  }

  static List<StationDroneRecord> parseStationDroneRecordList(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<StationDroneRecord>((json) => StationDroneRecord.fromJson(json))
        .toList();
  }
}
