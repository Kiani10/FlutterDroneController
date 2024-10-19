import 'dart:convert';

class Station {
  final int id;
  final String name;
  final String location;
  final String? locationPadImg;

  Station({
    required this.id,
    required this.name,
    required this.location,
    this.locationPadImg,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      locationPadImg: json['locationPadImg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'locationPadImg': locationPadImg,
    };
  }

  static List<Station> parseStationList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Station>((json) => Station.fromJson(json)).toList();
  }
}
