import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/Services/event_services.dart';
import 'package:project/Models/event_model.dart';
import 'package:project/Services/special_services.dart';
import 'package:project/events/eventPage.dart';
import 'package:project/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/Categories_model.dart';
import 'Services/user_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Event>> futureEvents;
  var userId;
  var userType;
  var user;
  var events;
  List<Categories> categories = [];
  bool isLoading = true;
  int? setCategory;

  Future<void> _fetchCategories() async {
    try {
      List<Categories> fetchedCategories = await SpecialServices().getCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load categories: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> getUserDetails() async {
    user = await UserServices().getUserById(1);
  }

  Future<void> getUserType() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userType = sp.getString(SplashScreenState.KeyUser);
      userId = sp.get('userId');
    });
  }

  @override
  void initState() {
    super.initState();
    futureEvents = EventServices().fetchAllEvents();
    _fetchCategories();
    getUserType();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            events = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildInitialBar(),
                  _buildCarouselSlider(events),
                  _buildCategoryButton(),
                  if (setCategory != null) ...[
                    _buildCategorySection(events, setCategory!)
                  ]
                  else...[
                    _buildEventSection(events),
                  ],
                ],
              ),
            );
          } else {
            return const Center(child: Text('No events found'));
          }
        },
      ),
    );
  }

  Widget _buildInitialBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Hi,',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.purple,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'User! 👋',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.purple,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Explore more and participate',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(List<Event> events) {
    return CarouselSlider(
      options: CarouselOptions(height: 200.0, autoPlay: true),
      items: events.map((event) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailPage(eventId: event.id),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('assets/images/badminton.jpg', fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Text(
                        event.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoryButton() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        setCategory = category.id;
                      });
                    },
                    child: Text(category.name),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildCategorySection(List<Event> events, int categoryId) {
    final categoryEvents = events.where((event) => event.categoryId == categoryId).toList();
    return _buildEventSection(categoryEvents);
  }


  Widget _buildEventSection(List<Event> events) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: events.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final event = events[index];
          return Column(
            children: [
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailPage(eventId: event.id),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/badminton.jpg', fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Text(
                          event.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
