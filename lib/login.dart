import 'package:dronecontroller/API/api_handler.dart';
import 'package:dronecontroller/screens/admin/dashboard.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final API api = API(); // Instantiate your API handler class

  bool _isLoading = false; // Track loading state

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    // Collect email and password from the text fields
    String email = _emailController.text;
    String password = _passwordController.text;

    // Call the API login function
    try {
      var response = await api.login({'name': email, 'passwrd': password});
      if (response.statusCode == 200) {
        // If login successful, navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else {
        // Handle incorrect credentials or other errors
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text('Incorrect email or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network or API errors
      print('Error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred during login. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white60,
        ),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Drone.png',
                  height: 240,
                ),
                SizedBox(height: 15),
                Text(
                  'Welcome to Drone Controller',
                  style: TextStyle(
                    fontSize: 24.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800], // Orange text color
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _emailController, // Controller for email input
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: Colors.amber[800]), // Orange hint text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: Icon(Icons.email,
                        color: Colors.amber[800]), // Orange icon color
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                PasswordField(
                    controller:
                        _passwordController), // Replaced TextField with custom PasswordField widget
                SizedBox(height: 30),
                _isLoading
                    ? CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                        onPressed: _login, // Call _login function on press
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.amber[800],
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    print('Signup Clicked');
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Text(
                          '  Signup',
                          style:
                              TextStyle(fontSize: 25, color: Colors.amber[800]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Controller for password input
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle:
            TextStyle(color: Colors.amber[800]), // Orange hint text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon:
            Icon(Icons.lock, color: Colors.amber[800]), // Orange icon color
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.amber[800],
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      obscureText: _obscureText,
    );
  }
}
