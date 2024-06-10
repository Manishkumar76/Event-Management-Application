import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/Services/event_services.dart';
import 'package:project/Models/event_model.dart';
import 'package:project/events/eventPage.dart';
import 'package:project/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Event>> futureEvents;
  var userType;
  Future getUserType() async{
    SharedPreferences sp= await SharedPreferences.getInstance();
    userType= sp.getString(SplashScreenState.KeyUser);
  }
  @override
  void initState() {
    super.initState();
    futureEvents = EventServices().fetchAllEvents();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Management'),
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final events = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCarouselSlider(events),
                  _buildCategorySection('Cultural Events', events, 1),
                  _buildCategorySection('Technical Events', events, 2),
                  _buildCategorySection('Sports Events', events, 3),
                  _buildDepartmentSection('Department 1 Events', events, 1),
                  _buildDepartmentSection('Department 2 Events', events, 2),
                ],
              ),
            );
          } else {
            return Center(child: Text('No events found'));
          }
        },
      ),
    );
  }

  Widget _buildCarouselSlider(List<Event> events) {
    return CarouselSlider(
      options: CarouselOptions(height: 200.0, autoPlay: true),
      items: events.map((event) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailPage(eventId: event.id,user:userType),
                  ),
                );
              },
              child: Image.network(event.mainImage, fit: BoxFit.cover),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(String title, List<Event> events, int categoryId) {
    final categoryEvents = events.where((event) => event.categoryId == categoryId).toList();
    return _buildEventSection(title, categoryEvents);
  }

  Widget _buildDepartmentSection(String title, List<Event> events, int departmentId) {
    final departmentEvents = events.where((event) => event.departmentId == departmentId).toList();
    return _buildEventSection(title, departmentEvents);
  }

  Widget _buildEventSection(String title, List<Event> events) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(eventId: event.id,user:userType),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image.network(event.mainImage, width: 100, height: 100, fit: BoxFit.cover),
                        Text(event.name),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
