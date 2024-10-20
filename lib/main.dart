import 'package:dronecontroller/screens/admin/addStation.dart';
import 'package:dronecontroller/screens/admin/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:dronecontroller/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drone Control',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginPage(), // Set the initial screen (login)
      routes: {
        '/login': (context) => LoginPage(),
        '/adminDashboard': (context) => AdminDashboard(
              adminName: '',
            ),
        '/addStation': (context) => AddStationScreen(
              adminName: '',
            ),
        // Add other routes here
      },
    );
  }
}
