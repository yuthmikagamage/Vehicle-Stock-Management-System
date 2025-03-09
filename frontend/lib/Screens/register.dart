import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _isLoading = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http.post(
          Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration successful!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Registration failed: ${jsonResponse['message'] ?? "Unknown error"}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 26, 123, 226),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Register Account',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Enter your email",
                    border: OutlineInputBorder(),
                    errorText: _isNotValidate ? "Enter correct details" : null,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter a password here",
                    border: OutlineInputBorder(),
                    errorText: _isNotValidate ? "Enter correct details" : null,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : registerUser,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 7, 84, 122),
                      ),
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
