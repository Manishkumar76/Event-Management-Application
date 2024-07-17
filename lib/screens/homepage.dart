import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/Services/event_services.dart';
import 'package:project/Models/event_model.dart';
import 'package:project/Services/special_services.dart';
import 'package:project/events/eventPage.dart';
import 'package:project/screens/shimmerEffectPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Categories_model.dart';
import '../Models/user_model.dart';
import '../Models/venue_model.dart';
import '../Services/user_services.dart';
import '../profiles/userProfile.dart';
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late Future<List<Event>> futureEvents;
  var userId = null;
  User? user;
  List<Event>? events;
  List<Categories> categories = [];
  bool isLoading = true;
  bool isLoadingEvents = false;
  int? setCategory;
  List <Venue>? _venues;
  late Future<Map<String, dynamic>> futureVenue;
  Future<void> _fetchvenues() async{
    try{
      List<Venue> venues=  await SpecialServices().getAllvenues();
      setState(() {
        _venues=venues;
      });
    }catch(error){
      print('Error fetching venues: $error');
  }}
  Future<void> _fetchCategories() async {
    try {
      List<Categories> fetchedCategories =
          await SpecialServices().getCategories();
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
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      setState(() {
        userId = sp.getInt('user_id')!;
      });
      print(userId);
      User fetchedUser = await UserServices().getUserById(userId);

      print(fetchedUser);
      setState(() {
        user = fetchedUser;
      });
    } catch (error) {
      throw Exception("user data not load");
    }
  }
  Future<void> _fetchEventsByCategory(int categoryId) async {
    setState(() {
      isLoadingEvents = true;
    });
    try {
      List<Event> fetchedEvents =
          await EventServices().fetchEventsByCategory(categoryId);
      setState(() {
        events = fetchedEvents;
        isLoadingEvents = false;
      });
    } catch (error) {
      setState(() {
        isLoadingEvents = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchvenues();
    getUserDetails();
    futureEvents = EventServices().fetchAllEvents();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management'),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
          child: const Icon(Icons.person),
        ),
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ShimmerEffectPage());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            events = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  user != null
                      ? _buildInitialBar(user!)
                      : const CircularProgressIndicator(),
                  _buildCarouselSlider(events!),
                  _buildCategoryButton(),
                  if (isLoadingEvents)
                    const Center(child: CircularProgressIndicator())
                  else if (setCategory != null) ...[
                    _buildCategorySection(events!, setCategory!)
                  ] else ...[
                    _buildEventSection(events!),
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
  Widget _buildInitialBar(User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
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
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${user.name}! 👋',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.purple,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Padding(
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
    );
  }
  String formatDateString(String dateString) {
    // Extract year, month, and day
    String year = dateString.substring(0, 4);
    String month = dateString.substring(5, 7);
    String day = dateString.substring(8, 10);
    // Return in dd-MM-yyyy format
    return '$day-$month-$year';
  }
  Future<String> venue(int id) async {
    try {
      final response = await SpecialServices().fetchVenue(id);
      return response['venue_name'] ?? 'Venue not found'; // Adjust according to your API response
    } catch (error) {
      return 'Error loading venue';
    }
  }
  Widget _buildCarouselSlider(List<Event> events) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 250.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.easeInCirc,
          pauseAutoPlayOnTouch: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          viewportFraction: 0.8,
          initialPage: 0,
          reverse: false,
          enableInfiniteScroll: true,
          onPageChanged: (index, reason) {
          }),
      items: events.map((event) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailPage(eventId: event.id, userId: user!.id,),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(event.mainImage,
                            fit: BoxFit.cover),
                      ),
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
                    Positioned(
                        bottom: 30,
                        left: 20,
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.white),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              formatDateString(event.eventStartDate.toString()),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(event.eventStartTime.toString(),
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ))
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
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              shrinkWrap: false,
              itemBuilder: (context, index) {

                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: setCategory == category.id
                          ? Colors.blue
                          : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        setCategory = category.id;
                        _fetchEventsByCategory(category.id);
                      });
                    },
                    child: Text(
                      category.name,
                      style: TextStyle(
                          color: setCategory == category.id
                              ? Colors.white
                              : Colors.blue),
                    ),
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
    final categoryEvents =
        events.where((event) => event.categoryId == categoryId).toList();
    return _buildEventSection(categoryEvents);
  }
  Widget _buildEventSection(List<Event> events) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 350,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          shrinkWrap: true,
          itemExtent: 300,
          padding: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {

            final event = events[index];
            final venue= _venues!.firstWhere((element) => element.id==event.venueId);
            return GestureDetector(
              onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (_)=>EventDetailPage(eventId: event.id, userId: user!.id,)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(event.mainImage,
                              fit: BoxFit.cover,
                              height: 150,
                              width: double.infinity
                        ),),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.name,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined),
                                    const SizedBox(width: 4),
                                    Text(
                                      formatDateString(
                                          event.eventStartDate.toString()),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      event.eventStartTime.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined),
                                    const SizedBox(width: 4),
                                    Text("${ venue.name} - ${venue.address}",
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
