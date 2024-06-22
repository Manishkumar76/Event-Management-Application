import 'dart:convert';
// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project/Models/Depart_model.dart';
import 'package:project/Models/Batch_model.dart';
import 'package:project/Models/Categories_model.dart';
import '../constant/utils.dart';

class SpecialServices {
  static String baseUrl = Utils.baseUrl;

  Future<List<Batch>> getBatch() async {
    final response = await http.get(Uri.parse('${baseUrl}others/getbatch'));
    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      return result.map((json) => Batch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load batches');
    }
  }

  Future<List<Department>> getDepartment() async {
    final response = await http.get(Uri.parse("${baseUrl}others/getAllDepartments"));
    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      return result.map((json) => Department.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Departments');
    }
  }

  Future <List<Categories>> getCategories() async{
    final response = await http.get(Uri.parse('${baseUrl}others/getAllCategories'));
    if (response.statusCode==200){
      final List<dynamic> results= jsonDecode(response.body);
      return results.map((json)=> Categories.fromJson(json)).toList();
    }
    else{
      throw Exception('failed to load Categories');
    }
  }
}
