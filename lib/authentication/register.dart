import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/Models/user_model.dart';
import 'package:project/Services/special_services.dart';
import 'package:project/Services/user_services.dart';
import 'loginPage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isShow = false;
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late TextEditingController? _batchController = TextEditingController();
  late TextEditingController? _DeptController = TextEditingController();

  var futureBatch;
  var futureDepartments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      futureBatch = SpecialServices().getBatch();
      futureDepartments = SpecialServices().getDepartment();
    });
  }

  bool isNotValid = false;
  final UserServices _userServices = UserServices();

  void register() async {
    if (_emailController.text.isNotEmpty && _passController.text.isNotEmpty) {
      setState(() {
        isNotValid = false;
      });

      User newUser = User(
        id: 0, // The backend will assign the ID
        profileImage: '', // Handle profile image separately if needed
        name: _nameController.text,
        email: _emailController.text,
        password: _passController.text,
        rollNo: _idController.text,
        userType: 'student', // Default userType, change if needed
        gender: 'Not specified', // Update this field if you have gender input
        phone: _mobileController.text,
        age: 0, // Update this field if you have age input
      );

      try {
        User registeredUser = await _userServices.addUser(newUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (error) {
        print("Error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'An error occurred during registration. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      setState(() {
        isNotValid = true;
      });
    }
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
              const Image(
                image: AssetImage("assets/images/why-image.png"),
                height: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "We need to register you before getting started!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  errorText: isNotValid ? "Enter proper info" : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent)),
                  label: const Text("Name"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
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
              FutureBuilder<List<String>>(
                  future: futureDepartments,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No departments available');
                    } else {
                      return DropdownButtonFormField(
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          hint: const Text('Departments'),
                          value: _DeptController,
                          items: futureDepartments.map((items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (newvalue) {
                            setState(() {
                              _DeptController = newvalue;
                              print(_DeptController);
                            });
                          });
                    }
                  }),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<String>>(
                  future: futureBatch,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No Batches available');
                    } else {
                      return DropdownButtonFormField(
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          hint: const Text('Batch'),
                          value: _batchController,
                          items: futureBatch.map((items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (newvalue) {
                            setState(() {
                              _batchController = newvalue!;
                              print(_batchController);
                            });
                          });
                    }
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(
                  errorText: isNotValid ? "Enter proper info" : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent)),
                  label: const Text("Mobile Number"),
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
                    label: const Text("Password"),
                    suffixIcon: IconButton(
                        icon: Icon(_isShow
                            ? Icons.remove_red_eye_rounded
                            : Icons.remove_red_eye_outlined),
                        onPressed: () {
                          setState(() {
                            _isShow = !_isShow;
                          });
                        })),
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
                onPressed: register,
                child: const Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
