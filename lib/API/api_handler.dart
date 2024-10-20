import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class API {
  final String _baseUrl = "http://192.168.100.11:5000";

  // ==========================
  // User Routes
  // ==========================

  Future<http.Response> login(Map<String, dynamic> credentials) async {
    String url = '$_baseUrl/user/login'; // Use your actual login route
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(credentials),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> getUsers() async {
    String url = '$_baseUrl/users';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getUser(int userId) async {
    String url = '$_baseUrl/user/$userId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> createUser(Map<String, dynamic> userData) async {
    String url = '$_baseUrl/user';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(userData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> updateUser(
      int userId, Map<String, dynamic> userData) async {
    String url = '$_baseUrl/user/$userId';
    var response = await http.put(
      Uri.parse(url),
      body: jsonEncode(userData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> deleteUser(int userId) async {
    String url = '$_baseUrl/user/$userId';
    var response = await http.delete(Uri.parse(url));
    return response;
  }

  // ==========================
  // Operator Routes
  // ==========================

  Future<http.Response> getOperators() async {
    String url = '$_baseUrl/operators';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getOperator(int operatorId) async {
    String url = '$_baseUrl/operator/$operatorId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> createOperator(
      Map<String, dynamic> operatorData) async {
    String url = '$_baseUrl/operator';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(operatorData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> updateOperator(
      int operatorId, Map<String, dynamic> operatorData) async {
    String url = '$_baseUrl/operator/$operatorId';
    var response = await http.put(
      Uri.parse(url),
      body: jsonEncode(operatorData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> deleteOperator(int operatorId) async {
    String url = '$_baseUrl/operator/$operatorId';
    var response = await http.delete(Uri.parse(url));
    return response;
  }

  // ==========================
  // Drone Routes
  // ==========================

  Future<http.Response> getDrones() async {
    String url = '$_baseUrl/drones';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getDrone(int droneId) async {
    String url = '$_baseUrl/drone/$droneId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> createDrone(Map<String, dynamic> droneData) async {
    String url = '$_baseUrl/drone';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(droneData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> updateDrone(
      int droneId, Map<String, dynamic> droneData) async {
    String url = '$_baseUrl/drone/$droneId';
    var response = await http.put(
      Uri.parse(url),
      body: jsonEncode(droneData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> deleteDrone(int droneId) async {
    String url = '$_baseUrl/drone/$droneId';
    var response = await http.delete(Uri.parse(url));
    return response;
  }

  // ==========================
  // Mission Routes
  // ==========================

  Future<http.Response> getMissions() async {
    String url = '$_baseUrl/missions';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getMission(int missionId) async {
    String url = '$_baseUrl/mission/$missionId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> createMission(Map<String, dynamic> missionData) async {
    String url = '$_baseUrl/mission';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(missionData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> updateMission(
      int missionId, Map<String, dynamic> missionData) async {
    String url = '$_baseUrl/mission/$missionId';
    var response = await http.put(
      Uri.parse(url),
      body: jsonEncode(missionData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> deleteMission(int missionId) async {
    String url = '$_baseUrl/mission/$missionId';
    var response = await http.delete(Uri.parse(url));
    return response;
  }

  Future<http.Response> getMissionCoordinates(int missionId) async {
    String url = '$_baseUrl/mission/$missionId/coordinates';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> createMissionCoordinates(
      int missionId, Map<String, dynamic> coordinatesData) async {
    String url = '$_baseUrl/mission/$missionId/coordinate';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(coordinatesData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  // ==========================
  // Station Routes
  // ==========================

  Future<http.Response> getStations() async {
    String url = '$_baseUrl/stations';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getStation(int stationId) async {
    String url = '$_baseUrl/station/$stationId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> createStation(
      Map<String, dynamic> stationData, File image) async {
    String url = '$_baseUrl/station';

    // Create a Multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add the station data fields
    request.fields['station_name'] = stationData['station_name'];
    request.fields['latitude'] = stationData['latitude'].toString();
    request.fields['longitude'] = stationData['longitude'].toString();

    // Add the image file to the request
    var imageFile = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(imageFile);

    // Send the request and get the response
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  Future<http.Response> updateStation(
      int stationId, Map<String, dynamic> stationData) async {
    String url = '$_baseUrl/station/$stationId';
    var response = await http.put(
      Uri.parse(url),
      body: jsonEncode(stationData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> deleteStation(int stationId) async {
    String url = '$_baseUrl/station/$stationId';
    var response = await http.delete(Uri.parse(url));
    return response;
  }

  // ==========================
  // Station Assignment Routes (Drones and Operators)
  // ==========================

  Future<http.Response> getStationDroneRecords() async {
    String url = '$_baseUrl/station_assignments/drones';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getStationDroneRecord(int recordId) async {
    String url = '$_baseUrl/station_assignments/drone/$recordId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> createStationDroneRecord(
      Map<String, dynamic> droneRecordData) async {
    String url = '$_baseUrl/station_assignments/drone';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(droneRecordData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> updateStationDroneRecord(
      int recordId, Map<String, dynamic> droneRecordData) async {
    String url = '$_baseUrl/station_assignments/drone/$recordId';
    var response = await http.put(
      Uri.parse(url),
      body: jsonEncode(droneRecordData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> deleteStationDroneRecord(int recordId) async {
    String url = '$_baseUrl/station_assignments/drone/$recordId';
    var response = await http.delete(Uri.parse(url));
    return response;
  }

  Future<http.Response> getStationOperatorRecords() async {
    String url = '$_baseUrl/station_assignments/operators';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getStationOperatorRecord(int recordId) async {
    String url = '$_baseUrl/station_assignments/operator/$recordId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> createStationOperatorRecord(
      Map<String, dynamic> operatorRecordData) async {
    String url = '$_baseUrl/station_assignments/operator';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(operatorRecordData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> updateStationOperatorRecord(
      int recordId, Map<String, dynamic> operatorRecordData) async {
    String url = '$_baseUrl/station_assignments/operator/$recordId';
    var response = await http.put(
      Uri.parse(url),
      body: jsonEncode(operatorRecordData),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<http.Response> deleteStationOperatorRecord(int recordId) async {
    String url = '$_baseUrl/station_assignments/operator/$recordId';
    var response = await http.delete(Uri.parse(url));
    return response;
  }
}
