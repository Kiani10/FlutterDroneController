import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class API {
  //final String _baseUrl = "http://192.168.18.87:5000";
  final String _baseUrl = "http://192.168.100.11:5000";

  // ==========================
  // User Routes
  // =========================
  Future<http.Response> login(Map<String, dynamic> credentials) async {
    String url = '$_baseUrl/user/login';
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

  Future<http.Response> getSpecificDrones(int operatorId) async {
    String url = '$_baseUrl/drones/specific/$operatorId';
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

  Future<http.Response> getMissions(int operatorId) async {
    String url = '$_baseUrl/missions/$operatorId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getMission(int missionId) async {
    String url = '$_baseUrl/mission/$missionId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  // Future<http.Response> createMission(
  //     Map<String, dynamic> missionData, File? image) async {
  //   String url = '$_baseUrl/mission';
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: jsonEncode(missionData),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   return response;
  // }

  Future<http.Response> createMission(
      Map<String, dynamic> missionData, File? image) async {
    String url = '$_baseUrl/mission';

    // Create a Multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add the mission data fields
    request.fields['mission_datetime'] = missionData['mission_datetime'];
    request.fields['location_pad'] = missionData['location_pad'];
    request.fields['status'] = missionData['status'];
    request.fields['drone_id'] = missionData['drone_id'].toString();

    // Add the coordinates if they exist
    List<dynamic> coordinates = missionData['coordinates'];
    for (int i = 0; i < coordinates.length; i++) {
      request.fields['coordinates[$i][latitude]'] =
          coordinates[i]['latitude'].toString();
      request.fields['coordinates[$i][longitude]'] =
          coordinates[i]['longitude'].toString();
    }

    // Add the image file to the request if it exists
    if (image != null) {
      var imageFile = await http.MultipartFile.fromPath('img', image.path);
      request.files.add(imageFile);
    }

    // Send the request and get the response
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  // Future<http.Response> updateMission(
  //     int missionId, Map<String, dynamic> missionData) async {
  //   String url = '$_baseUrl/mission/$missionId';
  //   var response = await http.put(
  //     Uri.parse(url),
  //     body: jsonEncode(missionData),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   return response;
  // }
  Future<http.Response> updateMission(int missionId, int status) async {
    String url = '$_baseUrl/mission/$missionId';

    // Define the data to update the mission status
    Map<String, dynamic> data = {
      'status': status, // Set the new status to 2
    };

    // Make the PUT request with the data as the JSON body
    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data), // Encode the data as JSON
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

  // Future<http.Response> updateStation(
  //     int stationId, Map<String, dynamic> stationData,
  //     [File? file]) async {
  //   String url = '$_baseUrl/station/$stationId';

  //   if (file != null) {
  //     // If a file is provided, use MultipartRequest for image upload
  //     var request = http.MultipartRequest('PUT', Uri.parse(url));

  //     // Add the station data as fields in the multipart request
  //     request.fields['station_name'] = stationData['station_name'];
  //     request.fields['latitude'] = stationData['latitude'].toString();
  //     request.fields['longitude'] = stationData['longitude'].toString();

  //     // Attach the image file
  //     var imageFile =
  //         await http.MultipartFile.fromPath('location_pad_img', file.path);
  //     request.files.add(imageFile);

  //     // Send the multipart request and await the response
  //     var streamedResponse = await request.send();
  //     return await http.Response.fromStream(streamedResponse);
  //   } else {
  //     // If no image file is provided, send a simple PUT request with JSON body
  //     var response = await http.put(
  //       Uri.parse(url),
  //       body: jsonEncode(stationData),
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     return response;
  //   }
  // }
  Future<http.Response> updateStation(
      int stationId, Map<String, dynamic> stationData,
      [File? file]) async {
    String url = '$_baseUrl/station/$stationId';

    // Create a MultipartRequest for sending form data
    var request = http.MultipartRequest('PUT', Uri.parse(url));

    // Add the station data as fields in the multipart request
    stationData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // If a file is provided, attach it to the request
    if (file != null) {
      var imageFile =
          await http.MultipartFile.fromPath('location_pad_img', file.path);
      request.files.add(imageFile);
    }

    // Send the multipart request and await the response
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
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
