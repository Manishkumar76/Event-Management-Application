import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Models/event_model.dart';
import 'package:project/Services/event_services.dart';
import 'package:project/Services/participant_services.dart';
import 'package:project/constant/utils.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;


  const EventDetailPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState(eventId: eventId);
}

class _EventDetailPageState extends State<EventDetailPage> {
  late Future<Event> futureEvent;
  late Future<Map<String, dynamic>> futureVenue;
  var future_participants;
late final int eventId ;
  _EventDetailPageState({required this.eventId});

  Future<Map<String, dynamic>> fetchVenue() async {
    final response = await http.get(Uri.parse('${Utils.baseUrl}others/getVenue/$eventId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Venue not found!');
    }
  }

  String formatDateString(String dateString) {
    // Extract year, month, and day
    String year = dateString.substring(0, 4);
    String month = dateString.substring(5, 7);
    String day = dateString.substring(8, 10);

    // Return in dd-MM-yyyy format
    return '$day-$month-$year';
  }

  void getParticipation() async {
    // Add your participation logic here
     future_participants= ParticipantServices().addParticipant(eventId, 1);
  }

  @override
  void initState() {
    super.initState();
    futureEvent = EventServices().fetchEventDetails(widget.eventId);
    futureVenue = fetchVenue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: FutureBuilder<Event>(
        future: futureEvent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                        "assets/images/badminton.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Name of Event", event.name, Icons.emoji_emotions_outlined),
                        _buildDetailRow("Event's Registration Date",
                            '${formatDateString(event.eventRegisterStartDate.toString().substring(0, 10))} - ${formatDateString(event.eventRegisterEndDate.toString().substring(0, 10))}',
                            Icons.date_range_outlined),
                        _buildDetailRow("Event's Date",
                           formatDateString( event.eventStartDate.toString().substring(0, 10)),
                            Icons.date_range_outlined),
                        _buildDetailRow("Time", event.eventStartTime, Icons.access_time_outlined),
                        FutureBuilder<Map<String, dynamic>>(
                          future: futureVenue,
                          builder: (context, venueSnapshot) {
                            if (venueSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (venueSnapshot.hasError) {
                              return Center(child: Text('Error: ${venueSnapshot.error}'));
                            } else if (venueSnapshot.hasData) {
                              final venue = venueSnapshot.data!;
                              return _buildDetailRow("Venue", venue['name'], Icons.location_on_outlined);
                            } else {
                              return const Center(child: Text('No venue data found'));
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text("Description",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        Text(event.description,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            )),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("Want to Participate! "),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                              onPressed: () {
                                // Add your participation logic here

                              },
                              child: const Text('Participate', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.purple,
              fontSize: 15,
              fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Icon(icon),
            ],
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
