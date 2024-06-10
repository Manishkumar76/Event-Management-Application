

import 'package:project/Models/venue_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/constant/utils.dart';

class VenueServices {
 static  String baseUrl = Utils.baseUrl;

    Future<Venue> fetchEventVenue(int eventId) async {
    final response = await http.get(Uri.parse('{$baseUrl}/venue/$eventId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Venue.fromJson(json[0]); // assuming the API returns a list with a single venue object
    } else {
      throw Exception('Failed to load venue');
    }
  }
}