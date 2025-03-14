import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/Screens/ChatPage.dart';
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
  int _selectedIndex = 0;

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

  void deleteItem(id) async {
    var regBody = {
      "id": id,
    };

    var responce = await http.post(
      Uri.parse(deleteVehicles),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    var jsonResponce = jsonDecode(responce.body);
    if (jsonResponce['status']) {
      getVehiclesList(userId);
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatPage(token: widget.token)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 26, 123, 226),
              const Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 60.0, left: 30.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.car_crash,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    backgroundColor: const Color.fromARGB(255, 39, 129, 201),
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
                                children: [
                                  SlidableAction(
                                    backgroundColor:
                                        const Color.fromARGB(255, 39, 129, 201),
                                    borderRadius: BorderRadius.circular(30.0),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: "Delete",
                                    onPressed: (BuildContext context) {
                                      print('${items![index]["_id"]}');
                                      deleteItem('${items![index]["_id"]}');
                                    },
                                  ),
                                ],
                              ),
                              child: Card(
                                borderOnForeground: false,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16.0),
                                  leading: Icon(Icons.car_rental),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 39, 129, 201),
        tooltip: "Add vehicle",
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: Colors.white,
            ),
            label: 'Chat',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 39, 129, 201),
      ),
    );
  }
}
