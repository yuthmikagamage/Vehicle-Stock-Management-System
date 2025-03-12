import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/config.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({required this.token, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  late String userId;
  TextEditingController _vehicleTile = TextEditingController();
  TextEditingController _vehicleDesc = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
  }

  void addVehicle() async {
    if (_vehicleTile.text.isNotEmpty && _vehicleDesc.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      var regBody = {
        "userId": userId,
        "title": _vehicleTile.text,
        "description": _vehicleDesc.text
      };

      try {
        var response = await http.post(
          Uri.parse(addCar),
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
              SnackBar(content: Text('Vehicle added successfully!')),
            );
            _vehicleTile.clear();
            _vehicleDesc.clear();
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add vehicle!')),
            );
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Vehicle"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _vehicleTile,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Vehicle Title",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _vehicleDesc,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Vehicle Description",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      addVehicle();
                    },
                    child: Text("Add"))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: $userId'),
            if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: "Add vehicle",
      ),
    );
  }
}
