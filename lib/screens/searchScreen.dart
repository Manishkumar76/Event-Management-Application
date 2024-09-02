import 'package:flutter/material.dart';
import 'package:project/Models/event_model.dart';
import 'package:project/Services/event_services.dart';
import 'package:shimmer/shimmer.dart';

class SearchEventPage extends StatefulWidget {
  const SearchEventPage({Key? key}) : super(key: key);

  @override
  _SearchEventPageState createState() => _SearchEventPageState();
}

class _SearchEventPageState extends State<SearchEventPage> {
  final TextEditingController _searchController = TextEditingController();
  var _events = null;
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _searchController.addListener(_filterEvents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEvents() async {
    try {
      List<Event> events = await EventServices().fetchAllEvents();
      setState(() {
        _events = events;
        _filteredEvents = events;
      });
    } catch (e) {
      print('Failed to load events: $e');
    }
  }

  void _filterEvents() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEvents = _events.where((event) {
        return event.name.toLowerCase().contains(query) ||
            event.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search Events...',
            border: InputBorder.none,
          ),
        ),
      ),
      body:_events==null? _buildShimmerEffect():ListView.builder(
        itemCount: _filteredEvents.length,
        itemBuilder: (context, index) {
          Event event = _filteredEvents[index];
          return ListTile(
            leading: Image.network(event.mainImage, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(event.name),
            subtitle: Text(event.description),
            onTap: () {
              // Navigate to event details page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailPage(event: event)));
            },
          );
        },
      ),
    );
  }
}

Widget _buildShimmerEffect() {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: 6,
          itemExtent: 100,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.white,
                  ),
                ),
                title: Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors.white,
                ),
                subtitle: Container(
                  width: double.infinity,
                  height: 14.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 4.0),
                ),
              ),
            );
          }),
    ),
  );
}
