import 'dart:convert';

class StationOperatorRecord {
  final int id;
  final int operatorId;
  final int stationId;

  StationOperatorRecord({
    required this.id,
    required this.operatorId,
    required this.stationId,
  });

  factory StationOperatorRecord.fromJson(Map<String, dynamic> json) {
    return StationOperatorRecord(
      id: json['id'],
      operatorId: json['operatorId'],
      stationId: json['stationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operatorId': operatorId,
      'stationId': stationId,
    };
  }

  static List<StationOperatorRecord> parseStationOperatorRecordList(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<StationOperatorRecord>(
            (json) => StationOperatorRecord.fromJson(json))
        .toList();
  }
}
