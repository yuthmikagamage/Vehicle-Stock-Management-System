import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  List? items;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];

    getVehiclesList(userId);
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
            getVehiclesList(userId);
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

  void getVehiclesList(userId) async {
    try {
      var response = await http.get(
        Uri.parse('$getVehicles?userId=$userId'),
        headers: {"Content-Type": "application/json"},
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse != null && jsonResponse['success'] != null) {
        setState(() {
          items = jsonResponse['success'];
          if (items!.isEmpty) {
            print("Empty vehicle list returned");
          }
        });
      } else {
        print("Invalid response format: $jsonResponse");
        setState(() {
          items = [];
        });
      }
    } catch (e) {
      print("Error fetching vehicles: $e");
      setState(() {
        items = [];
      });
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
      backgroundColor: const Color.fromARGB(255, 2, 76, 137),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0, left: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30.0,
                  ),
                  backgroundColor: Colors.white,
                  radius: 30.0,
                ),
                SizedBox(height: 10),
                Text(
                  "StockTRC",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Add and Remove Vehicles",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: items == null
                    ? Center(child: Text("No vehicles available"))
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, int index) {
                          return Slidable(
                            key: ValueKey(index),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: "Delete",
                                  onPressed: (BuildContext context) {
                                    print('${items![index]}');
                                  },
                                ),
                              ],
                            ),
                            child: Card(
                              borderOnForeground: false,
                              child: ListTile(
                                leading: Icon(Icons.task),
                                title: Text('${items![index]['title']}'),
                                subtitle:
                                    Text('${items![index]['description']}'),
                                trailing: Icon(Icons.arrow_back),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: "Add vehicle",
      ),
    );
  }
}
