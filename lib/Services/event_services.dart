import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/Models/event_model.dart';
import 'package:project/constant/utils.dart';


class EventServices {
  static  String baseUrl = Utils.baseUrl;

  Future<Event> fetchEventDetails(int eventId) async {
    final response = await http.get(Uri.parse('${baseUrl}events/event/$eventId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Event.fromJson(json[0]); // assuming the API returns a list with a single event object
    } else {
      throw Exception('Failed to load event');
    }
  }

  Future<Event> createEvent(Event event) async {
    final response = await http.post(
      Uri.parse('${baseUrl}events/store'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create event');
    }
  }

  Future<Event> updateEvent(Event event) async {
    final response = await http.put(
      Uri.parse('$baseUrl/event/${event.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Event.fromJson(json);
    } else {
      throw Exception('Failed to update event');
    }
  }

  Future<Event> deleteEvent(int eventId) async {
    final response = await http.delete(Uri.parse('${baseUrl}events/event/$eventId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Event.fromJson(json);
    } else {
      throw Exception('Failed to delete event');
    }
  }

  Future<List<Event>> fetchAllEvents() async {
    final response = await http.get(Uri.parse('${baseUrl}events/events'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map<Event>((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> fetchEventsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/events?category_id=$categoryId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map<Event>((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> fetchEventsByDepartment(int departmentId) async {
    final response = await http.get(Uri.parse('$baseUrl/events?department_id=$departmentId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map<Event>((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> fetchEventsByOrganizer(int organizerId) async {
    final response = await http.get(Uri.parse('$baseUrl/events?organizer_id=$organizerId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map<Event>((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> fetchEventsByVenue(int venueId) async {
    final response = await http.get(Uri.parse('$baseUrl/events?venue_id=$venueId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map<Event>((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

}


