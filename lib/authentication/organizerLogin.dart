import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/utils.dart';
import '../splashScreen.dart';

class Organizer extends StatefulWidget {
  const Organizer({super.key});

  @override
  _OrganizerState createState() => _OrganizerState();
}

class _OrganizerState extends State<Organizer> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late var isNotValid = false;
  late var _isShow = false;

  Future<void> _login() async {
    print(_emailController.text);
    print(_passController.text);
    var userbody = {
      'email': _emailController.text,
      'pass_word': _passController.text
    };
    if (_emailController.text.isEmpty && _passController.text.isEmpty) {
      setState(() {
        isNotValid = true;
      });
    } else {
      setState(() {
        isNotValid = false;
      });
      final response = await http.post(Uri.parse('${Utils.baseUrl}admin/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userbody));

      if (response.statusCode == 200) {
        var sp = await SharedPreferences.getInstance();
        sp.setBool(SplashScreenState.KeyLogin, true);
        sp.setString(SplashScreenState.KeyUser, 'Organizer');

        sp.setString('email', _emailController.text);
        print('Login successful');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        // Navigate to the next screen or perform any other action
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'This account is not exist!.Enter Existing Account if have not please sign up '),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Something went Wrong! please wait and try again letter.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Hero(
                    tag: "yes",
                    child: SizedBox(
                      height: 250,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(550),
                              bottomRight: Radius.circular(650),
                              topLeft: Radius.circular(600),
                              topRight: Radius.circular(300)),
                          child: Image(
                            image: AssetImage("assets/images/image2.jpg"),
                            height: 250,
                            fit: BoxFit.fitHeight,
                          )),
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "You need to Sign in yourself before getting started!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {},
                  style: const TextStyle(),
                  controller: _emailController,
                  decoration: InputDecoration(
                    errorText: isNotValid ? "Enter proper info" : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent)),
                    label: const Text("Email"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passController,
                  obscureText: _isShow ? false : true,
                  decoration: InputDecoration(
                    errorText: isNotValid ? "Enter proper info" : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent)),
                    label: const Text("password"),
                    suffixIcon: IconButton(
                      icon: Icon(_isShow
                          ? Icons.remove_red_eye_rounded
                          : Icons.remove_red_eye_outlined),
                      onPressed: () {
                        setState(() {
                          _isShow = !_isShow;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blue),
                    onPressed: () => _login(),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    )),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
