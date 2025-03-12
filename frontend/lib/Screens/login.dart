import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool _isLoading = false;
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      var regbody = {
        "email": emailcontroller.text,
        "password": passwordcontroller.text
      };

      try {
        var response = await http.post(
          Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody),
        );
        setState(() {
          _isLoading = false;
        });

        var jsonResponse = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['message'] ?? "Unknown response"),
          backgroundColor: jsonResponse['status']
              ? const Color.fromARGB(255, 6, 76, 8)
              : const Color.fromARGB(255, 92, 13, 8),
        ));

        if (jsonResponse['status']) {
          var myToken = jsonResponse['token'];
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(token: myToken)));
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: const Color.fromARGB(255, 92, 13, 8),
        ));
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields'),
        backgroundColor: const Color.fromARGB(255, 118, 71, 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        const Color.fromARGB(255, 255, 255, 255),
        const Color.fromARGB(255, 26, 123, 226)
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Login Account',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                  labelText: 'PassWord',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                  child: SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : loginUser,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 84, 122),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              )),
              SizedBox(height: 20),
              Center(
                  child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Dont have account? Register Here',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              )),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ));
  }
}
