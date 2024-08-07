import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/utils.dart';

class ClosedEvents extends StatefulWidget {
  const ClosedEvents({super.key});

  @override
  State<ClosedEvents> createState() => _ClosedEventsState();
}

class _ClosedEventsState extends State<ClosedEvents> {
  final String apiUrl = '${Utils.baseUrl}user/profile';
  late var events = null;
  late var _userData = null;
  late var id = null;
  late var notshown = false;

  static var userType = null;
  var clicked = 0;

  @override
  void initState() {
    super.initState();
    usertype();
  }

  Future getData() async {
    final response = await http.get(
      Uri.parse('${Utils.baseUrl}events/ClosedEvents'),
    );
    if (response.statusCode == 200) {
      // print(response.body);
      setState(() {
        events = jsonDecode(response.body);
        if (events == 0) {
          notshown = true;
        }
      });
    } else {
      throw "there is something wrong";
    }
  }

  //*check the user is admin or not
  Future<void> usertype() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      userType = sp.getString('userType');
    });

    fetchProfileData(userType);
    getData();
  }

  Future<void> fetchProfileData(var user) async {
    final response;

    //*for admin
    if (user == 'Organizer') {
      var sp = await SharedPreferences.getInstance();
      setState(() {
        id = sp.getString('email');
      });
      print(id);
      response = await http.post(Uri.parse("${Utils.baseUrl}admin/profile"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'email': id}));

      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
          print(_userData);
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    } else {
      var sp = await SharedPreferences.getInstance();
      setState(() {
        id = sp.getInt('u_id');
      });
      response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'u_id': id}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
          print(_userData);
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                const SliverAppBar(
                  scrolledUnderElevation: 10.0,
                  centerTitle: true,
                  floating: true,
                  snap: true,
                  title: Text("Closed Events",
                      style: TextStyle(
                          color: Color.fromARGB(255, 48, 137, 239),
                          fontSize: 30,
                          fontWeight: FontWeight.w900)),
                  actions: <Widget>[],
                ),
              ]),
          body: Center(
            child: Column(
              children: [
                Flexible(
                  child: events == null
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.blue,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.lightBlue.shade100,
                        ))
                      : notshown == true
                          ? const Center(
                              child: Text(
                              "There is No Any Live Event.",
                              style: TextStyle(color: Colors.red),
                            ))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: events.length,
                              itemBuilder: (BuildContext context, int index) {
                                var event= events[index];
                                return Card(
                                  child: Column(
                                    children: <Widget>[
                                      Image.network(event.mainImage, width: 100, height: 100, fit: BoxFit.cover),
                                      Text(event.name),
                                    ],
                                  ),
                                );
                              },
                            ),
                )
              ],
            ),
          )),
    );
  }
}

