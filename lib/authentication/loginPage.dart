import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/authentication/register.dart';
import 'package:project/main.dart';
import 'package:project/screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/services/user_services.dart';
import '../constant/utils.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isShow = false;
  final TextEditingController _passController = TextEditingController();
  late TextEditingController _idController;
  bool isNotValid = false;
  var id = ''; // Initialize id as an empty string
  var clicked = 1;
  UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_idController.text.isEmpty || _passController.text.isEmpty) {
      setState(() {
        isNotValid = true;
        clicked=1;
      });
    } else {
      setState(() {
        isNotValid = false;
        clicked = 0;
      });
      try {
        var user = await userServices.loginUser(_idController.text, _passController.text);
        var sp = await SharedPreferences.getInstance();
        sp.setBool(SplashScreenState.KeyLogin, true);
        sp.setInt('user_id', user.id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(context) => const MainPage()),
        );
      } catch (error) {
        setState(() {
          clicked = 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to login user: $error'), // Display error message
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> refreshIndicator() async {
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
                    topRight: Radius.circular(300),
                  ),
                  child: Image(
                    image: AssetImage("assets/images/image.png"),
                    height: 250,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "You need to sign in yourself before getting started!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    id = value;
                  });
                },
                controller: _idController,
                decoration: InputDecoration(
                  errorText: isNotValid ? "Enter proper info" : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passController,
                obscureText: !_isShow,
                decoration: InputDecoration(
                  errorText: isNotValid ? "Enter proper info" : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isShow ? Icons.remove_red_eye_outlined : Icons.remove_red_eye_rounded,
                    ),
                    onPressed: () {
                      setState(() {
                        _isShow = !_isShow;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
               ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () => refreshIndicator(),
                child: Text(
                  clicked == 1
                      ?
                  "Login":'loading...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  forgotPassword(context, id);
                },
                child: const Text(
                  "Forgotten!",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void forgotPassword(context, String id) async {
    final response = await http.post(
      Uri.parse('${Utils.baseUrl}user/forgot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': id}),
    );
    if (response.statusCode == 200) {
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
