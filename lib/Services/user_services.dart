import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/constant/utils.dart';
import '../Models/user_model.dart';

class UserServices {
  String baseUrl = Utils.baseUrl;

  Future<User> addUser(User user) async {
    final response = await http.post(
      Uri.parse('${baseUrl}user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      print(response.body);
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add user');
    }
  }
  Future<User> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Future.error('error');
    }
  }


  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('${baseUrl}user/getusers'));

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('${baseUrl}user/getuser/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateuser/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteuser/$id'));

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception('Failed to delete user');
    }
  }
}
