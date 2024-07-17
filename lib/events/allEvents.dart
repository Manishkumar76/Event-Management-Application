import 'package:flutter/material.dart';
import 'package:project/Services/event_services.dart';
import 'package:project/Models/event_model.dart';
import 'package:shimmer/shimmer.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  var _isSelected;
  late Future<List<Event>> futureEvents;
  var events;

  void getEventList() {
    futureEvents = EventServices().fetchAllEvents();
  }

  @override
  void initState() {
    super.initState();
    getEventList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {

                      setState(() {
                        _isSelected = 0;
                      });
                      _buildFilterEvents(events, _isSelected);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _isSelected == 0 ? Colors.blue : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.grey.shade200),
                    child: Text(
                      "Live",
                      style: TextStyle(
                          color: _isSelected == 0 ? Colors.white : Colors.blue),
                    )),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSelected = 1;
                      });
                      _buildFilterEvents(events, _isSelected);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _isSelected == 1 ? Colors.blue : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.grey.shade200),
                    child: Text(
                      "Upcoming",
                      style: TextStyle(
                          color: _isSelected == 1 ? Colors.white : Colors.blue),
                    )),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSelected = 2;
                      });
                      _buildFilterEvents(events, _isSelected);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _isSelected == 2 ? Colors.blue : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.grey.shade200),
                    child: Text(
                      "Closed",
                      style: TextStyle(
                          color: _isSelected == 2 ? Colors.white : Colors.blue),
                    ))
              ],
            ),
            FutureBuilder<List<Event>>(
                future: futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerEffect();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    events = snapshot.data!;
                    if (_isSelected != null) {
                      return _buildFilterEvents(events, _isSelected);
                    }
                    return _buildEvents(events);
                  } else {
                    return const Text("Events not loaded!");
                  }
                }),
          ],
        ),
      ),
    );
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
}

Widget _buildFilterEvents(List<Event> events, int selected) {
  var currentEventList;
  if (selected == 0) {
    currentEventList = events
        .where((event) => event.eventStartDate==DateTime.now())
        .toList();
  } else if (selected == 1) {
    currentEventList = events
        .where(
            (element) => element.eventRegisterStartDate.isAfter(DateTime.now()))
        .toList();
  } else if (selected == 2) {
    currentEventList = events
        .where((element) => element.eventEndDate.isBefore(DateTime.now()))
        .toList();
  }
  return _buildEvents(currentEventList);
}

Widget _buildEvents(List<Event> events) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: events.length,
          itemExtent: 100,
          itemBuilder: (context, index) {
            final event = events[index];
            return ListTile(

              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 50,
                  height: 40,
                  child: Image.network(event.mainImage,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              title: Text(event.name),
              subtitle: Text(
                '${event.description} .${event.eventEndDate}',
                maxLines: 1,
              ),
            );
          }),
    ),
  );
}
