import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Models/event_model.dart';
import 'package:project/Models/venue_model.dart';
import 'package:project/Services/event_services.dart';
import 'package:project/Services/venue_services.dart';
import 'package:project/constant/utils.dart';

class EventDetailPage extends StatefulWidget {
  late final eventId;
  
  EventDetailPage({super.key, required this.eventId, required user});

  @override
  // ignore: library_private_types_in_public_api
  _EventDetailPageState createState() =>
      _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {

  late final userType;
  
  late Future<Event> futureEvent;
  late Future<Venue> futureEvent_venue;

  @override
  void initState() {
    super.initState();
    futureEvent = EventServices().fetchEventDetails(widget.eventId);
    futureEvent_venue = VenueServices().fetchEventVenue(widget.eventId);
  }

  // Future fetchEventDetails() async {
  //   try {
  //     final response = await http.post(
  //         Uri.parse('${Utils.baseUrl}events/eventdata'),
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode({'id': eventID}));
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         eventData = json.decode(response.body);
  //       });
  //     } else {
  //       throw Exception('Failed to load event details');
  //     }
  //   } catch (err) {
  //     rethrow;
  //   }
  //   if (eventData['status'] == "Closed") {
  //     setState(() {
  //       participated = true;
  //       result = "No you can't participate! Registration closed.";
  //     });
  //   }
  // }
  //
  //
  //
  // Future fetchParticipated() async {
  //   final response = await http.post(
  //       Uri.parse('${Utils.baseUrl}events/participatedData'),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({'id': eventID, 'u_id': u_id}));
  //   if (response.body.isNotEmpty) {
  //     setState(() {
  //       participated = true;
  //       result = "You have participated!";
  //     });
  //   } else {
  //     throw Exception('Failed to load event details');
  //   }
  // }
  //
  // Future fetchParticipatedData() async {
  //   final response = await http.post(
  //       Uri.parse('${Utils.baseUrl}events/EventParticipatedList'),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({'event_id': eventID}));
  //   if (response.statusCode==200) {
  //     setState(() {
  //       events=jsonDecode(response.body);
  //       print(events);
  //     });
  //   } else {
  //     throw Exception('Failed to load event data');
  //   }
  // }
  //
  // Future openDialog() => showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text("Registration"),
  //         content: const Text(
  //           "Do you want to Participate? ",
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 setState(() {
  //                   participated = true;
  //                 });
  //                 participateInEvent();
  //                 Navigator.pop(context);
  //               },
  //               child: const Text("Yes")),
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text("NO"))
  //         ],
  //       ),
  //     );
  //
  // Future participateInEvent() async {
  //   print(eventData['status']);
  //   var bodyData = {'event_id': eventID, 'u_id': u_id};
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${Utils.baseUrl}events/participate'),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(bodyData),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         participated = true;
  //         result = "you have participated!";
  //       });
  //     } else {
  //       // Handle API errors or other issues
  //       print(
  //           'Failed to participate in the event. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Handle network errors
  //     print('Error participating in the event: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Event Details'),
          ),
      body: FutureBuilder<Event>(
        future: futureEvent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final event = snapshot.data!;
            return SingleChildScrollView(
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
                        "assets/images/${event.mainImage}",
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
                                  Text('${event.name}',
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
                              "Event's Registeration Date",
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
                                      '${event.eventRegisterStartDate.toString().substring(0, 10).split(' ').reversed.join()}-${event.eventRegisterEndDate.toString().substring(0, 10).split(' ').reversed.join()}',
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
                                      '${event.eventStartDate}'
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
                                  Text('${event.eventStartTime}',
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
                                  Text('',
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
                            Text('E_description',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                        const SizedBox(height: 20),

                         Container(
                           child:SizedBox(
                             child:ElevatedButton(
                               onPressed: (){},
                               child: const Text('Participate'),
                             )
                            
                             ),
                         ),

                      ],
                    ),
                  ),
                ],
              ),
            );
      // bottomSheet: BottomSheet(onClosing: (){}, builder: ),
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
    
    }
    }
