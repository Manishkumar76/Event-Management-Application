import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/constant/utils.dart';

class EventDetailPage extends StatefulWidget {
  late final eventId;
  late final userid;
  late final user;
  EventDetailPage({super.key, required this.eventId, required this.userid,required this.user});

  @override
  _EventDetailPageState createState() =>
      _EventDetailPageState(eventID: eventId, u_id: userid, userType: user);
}

class _EventDetailPageState extends State<EventDetailPage> {
  late var eventID;
  late var u_id;
  late final userType;
  late var events=null;
  _EventDetailPageState(
      {required this.eventID, required this.u_id, required this.userType});
  late var eventData = null;
  var participated = false;
  late var result = "";

  @override
  void initState() {
    super.initState();
    userType=="Organizer"?fetchParticipatedData():null;
    userType == "Student" ? fetchParticipated() : null;

    fetchEventDetails();
  }

  Future fetchEventDetails() async {
    try {
      final response = await http.post(
          Uri.parse('${Utils.baseUrl}events/eventdata'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'id': eventID}));

      if (response.statusCode == 200) {
        setState(() {
          eventData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load event details');
      }
    } catch (err) {
      rethrow;
    }
    if (eventData['status'] == "Closed") {
      setState(() {
        participated = true;
        result = "No you can't participate! Registration closed.";
      });
    }
  }



  Future fetchParticipated() async {
    final response = await http.post(
        Uri.parse('${Utils.baseUrl}events/participatedData'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'id': eventID, 'u_id': u_id}));
    if (response.body.isNotEmpty) {
      setState(() {
        participated = true;
        result = "You have participated!";
      });
    } else {
      throw Exception('Failed to load event details');
    }
  }

  Future fetchParticipatedData() async {
    final response = await http.post(
        Uri.parse('${Utils.baseUrl}events/EventParticipatedList'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'event_id': eventID}));
    if (response.statusCode==200) {
      setState(() {
        events=jsonDecode(response.body);
        print(events);
      });
    } else {
      throw Exception('Failed to load event data');
    }
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Registration"),
          content: const Text(
            "Do you want to Participate? ",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    participated = true;
                  });
                  participateInEvent();
                  Navigator.pop(context);
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("NO"))
          ],
        ),
      );

  Future participateInEvent() async {
    print(eventData['status']);
    var bodyData = {'event_id': eventID, 'u_id': u_id};

    try {
      final response = await http.post(
        Uri.parse('${Utils.baseUrl}events/participate'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        setState(() {
          participated = true;
          result = "you have participated!";
        });
      } else {
        // Handle API errors or other issues
        print(
            'Failed to participate in the event. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error participating in the event: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Event Details'),
          ),
      body: eventData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(200),
                          bottomRight: Radius.circular(50)),
                      child: Image.asset(
                        "${eventData['imageUrl']}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Name of Event",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(eventData['eventName'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      )),
                                  const Icon(Icons.emoji_emotions_outlined)
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Event's Date",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      eventData['E_date']
                                          .toString()
                                          .substring(0, 10).split(' ').reversed.join(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),),
                                  const Icon(Icons.date_range_outlined)
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Time",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(eventData['E_time'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      )),
                                  const Icon(Icons.access_time_outlined)
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Venue",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(eventData['venue'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      )),
                                  const Icon(Icons.location_on_outlined)
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Description",
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                            Text(eventData['E_description'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),

                         Container(
                           child: userType == 'Organizer'?null:SizedBox(
                             child: participated == false
                                 ? ElevatedButton(
                               onPressed: openDialog,
                               child: const Text('Participate'),
                             )
                                 : Text(
                               result,
                               style: const TextStyle(
                                   color: Colors.purple,
                                   fontWeight: FontWeight.w500),
                             ),
                           ),
                         ),

                      ],
                    ),
                  ),

                  if(userType == 'Organizer')Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Participated By ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),

                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: events?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              var data = events![index];
                              return ListTile(
                                splashColor: Colors.purpleAccent.shade100,
                                style:ListTileStyle.list,
                                leading: Text('${index+1}'),
                                title: Text(data['U_name'].toString()),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(data['department'].toString()),
                                    Text(data['batch'].toString()),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
      // bottomSheet: BottomSheet(onClosing: (){}, builder: ),
    );
  }
}
