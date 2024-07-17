import 'package:flutter/material.dart';
import 'package:project/Models/Batch_model.dart';
import 'package:project/Models/Depart_model.dart';
import 'package:project/Models/user_model.dart';
import 'package:project/Services/special_services.dart';
import 'package:project/services/user_services.dart';
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
  String? _batchController;
  String? _deptController;



  int? _selectedDepartmentId;
  int? _selectedBatchId;
  List<Department> _departments = [];
  List<Batch> _bathces = [];

  @override
  void initState() {
    super.initState();
_fetchDepartments();
_fetchBatches();
  }
  Future<void> _fetchDepartments() async {
    try {
      SpecialServices specialServices = SpecialServices();
      List<Department> departments = await specialServices.getDepartment();

      setState(() {
        _departments = departments;
      });
    } catch (e) {
      print('Failed to load departments: $e');
    }
  }

  Future<void> _fetchBatches() async {
    // Replace with actual fetch method for venues
    // This is just a placeholder
    List<Batch> batch = await SpecialServices().getBatch(); // Replace with actual fetch logic
    setState(() {
      _bathces = batch;
    });
  }
  bool isNotValid = false;
  bool isPressed=false;
  final UserServices _userServices = UserServices();

  void register() async {
    if (_emailController.text.isNotEmpty &&
        _passController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _idController.text.isNotEmpty &&
        _mobileController.text.isNotEmpty &&
        _selectedDepartmentId != null &&
        _selectedBatchId != null) {
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
        gender: "Male/Female", // Update this field if you have gender input
        phone: _mobileController.text,
        age: 0,
        departmentId: _selectedDepartmentId!,
        batchId: _selectedBatchId!,
        verifyEmail: '',
        token: '',
      );

      try {
        User registeredUser = await _userServices.addUser(newUser);

        if (registeredUser.id != 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (error) {
        print("Error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred during registration. Please try again.'),
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
              DropdownButtonFormField<int>(
                value: _selectedDepartmentId,
                items: _departments.map((department) {
                  return DropdownMenuItem<int>(
                    value: department.id,
                    child: Text(department.dep_name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartmentId = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a department';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<int>(
                style: const TextStyle(color: Colors.black),
                value: _selectedBatchId,
                items: _bathces.map((batch){
                  return DropdownMenuItem<int>(
                    value: batch.id,
                    child: Text(batch.year.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBatchId = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Batch'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a batch';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _mobileController,
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
                  label: const Text("Mobile Number"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                  label: const Text("Password"),
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
                  backgroundColor: Colors.blue,
                ),
                onPressed:() {
                  setState(() {
                    isPressed=true;
                  });
                  Future.delayed(const Duration(seconds: 3),register);},
                child: Text(
                  isPressed==true?"Loading...":
                  "Register",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
