import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/authentication/organizerLogin.dart';
import 'package:project/authentication/register.dart';
import 'package:project/constant/utils.dart';
import 'package:project/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isShow = false;
  final TextEditingController _passController = TextEditingController();
  late TextEditingController _idController = TextEditingController();
  bool isNotValid = false;
  var id;
  var clicked=1;
  static const u_id = 'u_id';
  // final FlutterSecureStorage storage = FlutterSecureStorage();
  Future<void> login() async {
    final userbody = {
      'u_id': _idController.text,
      'pass_word': _passController.text,
    };
    if (_idController.text.isEmpty && _passController.text.isEmpty) {
      setState(() {
        isNotValid = true;
      });
    } else {
      setState(() {
        isNotValid = false;
      });
      final response = await http.post(Uri.parse('${Utils.baseUrl}user/login'),
          body: userbody);

      if (response.statusCode == 200) {

        var sp = await SharedPreferences.getInstance();
        sp.setBool(SplashScreenState.KeyLogin, true);
        sp.setString(SplashScreenState.KeyUser, 'Student');
        sp.setInt('userId', int.parse(_idController.text));

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
    setState(() {
      clicked=1;
    });
  }

  Future refreshIndicator()async{
    setState(() {
      clicked = 0;
    });

    await Future.delayed(const Duration(seconds: 2), login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const Hero(
                  tag: "yes",
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(550),
                          bottomRight: Radius.circular(650),
                          topLeft: Radius.circular(600),
                          topRight: Radius.circular(300)),
                      child: Image(
                        image: AssetImage("assets/images/image.png"),
                        height: 250,
                        fit: BoxFit.fitHeight,
                      ))),
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
                onChanged: (value) {
                  id = value;
                },
                style: TextStyle(),
                controller: _idController,
                decoration: InputDecoration(
                  errorText: isNotValid ? "Enter proper info" : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent)),
                  label: const Text("Roll Number"),
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
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye_rounded),
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
              clicked==1? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue),
                  onPressed: () => refreshIndicator(),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  )):const Center(child:  CircularProgressIndicator()),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    forgotPassword(context, id);
                  },
                  child: const Text(
                    "forgotten!",
                    style: TextStyle(color: Colors.blue),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have not Account?"),
                  const SizedBox(
                    width: 8,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationPage()));
                      },
                      child: const Text("Sign Up"))
                ],
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(400, 40)),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Organizer()));
                  },
                  child: const SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Only For Admin",
                          style: TextStyle(color: Colors.blue),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void forgotPassword(context, String id) async {
    final response = await http.post(
      Uri.parse('${Utils.baseUrl}3000/user/forgot'),
      body: jsonEncode({'email': id}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      // Password reset successful
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Password reset email sent.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Password reset failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to reset password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
