import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/user_model.dart';
import '../constant/utils.dart';

class SpecialServices {

  static  String baseUrl = Utils.baseUrl;
  Future <List> getBatch() async {
    final response = await http.get(Uri.parse('${baseUrl}others/getbatch'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json; // assuming the API returns a list with a single event object
    } else {
      throw Exception('Failed to load batches');
    }
  }

  Future <List> getDepartment() async{
    var response = await http.get(Uri.parse("${baseUrl}others/getAllDepartments"));
    if (response.statusCode==200){
      final json = jsonDecode(response.body);
      return json;
    }
    else{
      throw Exception('Failed to load Departments');
    }
  }
}

