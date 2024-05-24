import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/constant/utils.dart';
import 'package:project/eventModels/eventPage.dart';
import 'package:project/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'authentication/loginPage.dart';
import 'eventModels/createEventPage.dart';
import 'navbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String apiUrl = '${Utils.baseUrl}user/profile';
  final String eventUrl = '${Utils.baseUrl}events/filter';

  late var events = null;
  late var _userData = null;
  late var id = null;
  late var _category = null;

  static var userType = null;
  var clicked = 0;

  @override
  void initState() {
    super.initState();
    usertype();
  }

  //*check the user is admin or not
  Future<void> usertype() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      userType = sp.getString(SplashScreenState.KeyUser);
    });

    fetchProfileData(userType);
    getData();
  }

  Future<void> fetchProfileData(var user) async {
    final http.Response response;

    //*for admin
    if (user == 'Organizer') {
      var sp = await SharedPreferences.getInstance();
      setState(() {
        id = sp.getString('email');
      });

      response = await http.post(Uri.parse("${Utils.baseUrl}admin/profile"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'email': id}));

      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    }

    //*for user
    else {
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
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    }
  }

  Future getData() async {
    final response = await http.get(
      Uri.parse('${Utils.baseUrl}events/Events'),
    );
    if (response.statusCode == 200) {
      // print(response.body);
      setState(() {
        events = jsonDecode(response.body);
      });
    } else {
      throw "there is something wrong";
    }
  }

  Future refresh() async {
    setState(() {
      clicked = 0;
    });

    await Future.delayed(const Duration(seconds: 1), getData);
  }

  Future Filter() async {
    setState(() {
      events = null;
    });
    await Future.delayed(const Duration(seconds: 2), filteredEvent);
  }

  Future filteredEvent() async {
    final response = await http.post(
      Uri.parse(eventUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "category": _category,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        events = jsonDecode(response.body);
      });
    } else {
      throw "there is something wrong";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawerEnableOpenDragGesture: false,
      // endDrawerEnableOpenDragGesture: false,
      extendBodyBehindAppBar: true,

      drawer: Navbar(
        userdata: _userData,
        usertype: userType,
      ),
      body: NestedScrollView(
        headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.blue.shade50,
                scrolledUnderElevation: 10.0,
                centerTitle: true,
                floating: true,
                snap: true,
                title: const Text("Home",
                    style: TextStyle(

                        fontSize: 20,)),
                actions: <Widget>[
                  IconButton(
                    onPressed: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.remove(SplashScreenState.KeyLogin);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
            ]),
        body:
        SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                // const RiveAnimation.asset("assets/rive/shapes.riv"),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                        height: 62,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Hi, ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                     "User",
                                    // _userData == null
                                    //     ? ""
                                    //     : _userData['U_name'].toString().toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    "!👋",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.search_rounded),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                              suffixIcon:
                                  const Icon(Icons.mic_none_rounded)),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "View all",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          clicked = 1;
                                          _category = "Sports";
                                        });

                                        Filter();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: clicked == 1
                                              ? Colors.blue
                                              : Colors.grey.shade50),
                                      child: Row(
                                        children: [
                                          Icon(
                                              Icons
                                                  .sports_tennis_outlined,
                                              color: clicked == 1
                                                  ? Colors.white
                                                  : Colors.purple),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "Sports",
                                            style: TextStyle(
                                                color: clicked == 1
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: clicked == 2
                                              ? Colors.blue
                                              : Colors.grey.shade50),
                                      onPressed: () {
                                        setState(() {
                                          clicked = 2;
                                          _category = "Technical";
                                        });
                                        Filter();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.computer,
                                              color: clicked == 2
                                                  ? Colors.white
                                                  : Colors.purple),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "Technical",
                                            style: TextStyle(
                                                color: clicked == 2
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: clicked == 3
                                              ? Colors.blue
                                              : Colors.grey.shade50),
                                      onPressed: () {
                                        setState(() {
                                          clicked = 3;
                                          _category = "Cultural";
                                        });
                                        Filter();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                              Icons.music_note_outlined,
                                              color: clicked == 3
                                                  ? Colors.white
                                                  : Colors.purple),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "Cultural",
                                            style: TextStyle(
                                                color: clicked == 3
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: clicked == 4
                                              ? Colors.blue
                                              : Colors.grey.shade50),
                                      onPressed: () {
                                        setState(() {
                                          clicked = 4;
                                          _category = "Quiz";
                                        });
                                        Filter();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.question_mark,
                                              color: clicked == 4
                                                  ? Colors.white
                                                  : Colors.purple),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "Quiz",
                                            style: TextStyle(
                                                color: clicked == 4
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: clicked == 5
                                              ? Colors.blue
                                              : Colors.grey.shade50),
                                      onPressed: () {
                                        setState(() {
                                          clicked = 5;
                                          _category = "Travel";
                                        });
                                        Filter();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                              Icons.trip_origin_rounded,
                                              color: clicked == 5
                                                  ? Colors.white
                                                  : Colors.purple),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "Travel",
                                            style: TextStyle(
                                                color: clicked == 5
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: events == null
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.blue,
                              strokeCap: StrokeCap.round,
                              backgroundColor:
                                  Colors.lightBlue.shade100,
                            ))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: events.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return EventCard(
                                  event: events[index],
                                  index: index,
                                  id: id.toString(),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: userType == 'Organizer'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>CreateEvent()));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
class EventCard extends StatelessWidget {
  late final id;
  final Map<String, dynamic> event;
  final index;
  final user;

  EventCard({super.key, required this.event, required this.index, this.id,this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailPage(
                      eventId: event['id'],
                      userid: id,
                  user: user,
                    )));
      },
      child: Container(
        width: 300, // Adjust the width based on your design
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "${event['imageUrl']}", // Replace with event image URL
                height: 250,

                // color: Colors.white,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                right: 20,
                top: 50,
                child:
            Container(child:user=="Organizer"? IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)):null)),
            Positioned(
              bottom: 50,
              left: 20,
              child: Text(
                event['eventName'],
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  Text(
                    '${event['venue']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          border: const Border(
                              top: BorderSide(width: 1),
                              bottom: BorderSide(width: 1)),
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(event['E_date'].toString().substring(0, 10),
                            style: const TextStyle(color: Colors.white)),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: const Border(
                            top: BorderSide(width: 1),
                            bottom: BorderSide(width: 1)),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(event['E_time'].toString(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // Text('Location: ${event['venue']}',style: const TextStyle(color: Colors.white)),
            const SizedBox(
              height: 8,
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     // Container(
//     //   decoration: BoxDecoration(
//     //       border: const Border( top: BorderSide(width: 1),bottom:BorderSide(width: 1) ),
//     //       borderRadius: BorderRadius.circular(10)
//     //   ),
//     //   child: Padding(
//     //     padding: const EdgeInsets.all(3.0),
//     //     child: Text(event['category'],style: const TextStyle(color: Colors.white)),
//     //   ),
//     // ),
//
//     Container(
//       decoration: BoxDecoration(
//         border: const Border( top: BorderSide(width: 1),bottom:BorderSide(width: 1) ),
//           borderRadius: BorderRadius.circular(10)
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(3.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Icon(event['status']=="Closed"?Icons.highlight_off_outlined:Icons.online_prediction_outlined,
//               color: event['status']=="Closed"?Colors.red:Colors.green,),
//             const SizedBox(width: 8,),
//             Text(event['status'],style: const TextStyle(color: Colors.white)),
//           ],
//         ),
//       ),
//     ),
//   ],
// ),
