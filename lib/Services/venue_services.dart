

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/constant/utils.dart';

class VenueServices {
 static  String baseUrl = Utils.baseUrl;

    fetchEventVenue(int eventId) async {
    final response = await http.get(Uri.parse('{$baseUrl}/venue/$eventId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json[0].toString(); // assuming the API returns a list with a single venue object
    } else {
      throw Exception('Failed to load venue');
    }
  }
}