import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Models/Depart_model.dart';
import 'package:project/Services/special_services.dart';
import 'dart:convert';
import 'dart:io';

import '../Models/Batch_model.dart';
import '../Models/user_model.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  File? profileImage;
  List<Batch>? _batches;
  int? _selectedBatchId;

  String? _selectedGender;
  int? _selectedDepartment;

  final List<String> genders = ['Male', 'Female', 'Other'];
   List<Department>? _departments;

  Future<void> getAllBatches() async {
    List<Batch> batches = await SpecialServices().getBatch();

    setState(() {
      _batches = batches;
    });
  }
  Future<void> getAllDepartments() async {
    List<Department> departments = await SpecialServices().getDepartment();

    setState(() {
      _departments = departments;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  // Future<void> _updateUser() async {
  //   try {
  //     // User updatedUser = user(
  //     //   name: nameController.text,
  //     //   email: emailController.text,
  //     //   password: passwordController.text,
  //     //   rollNo: rollNoController.text,
  //     //   userType: userTypeController.text,
  //     //   gender: genderController.text,
  //     //   phone: phoneController.text,
  //     //   age: int.parse(ageController.text),
  //     //   batchId: _selectedBatchId,
  //     // );
  //     //
  //     // final response = await http.put(
  //     //   Uri.parse('your_base_url/updateuser/${widget.user.id}'),
  //     //   headers: {'Content-Type': 'application/json'},
  //     //   body: jsonEncode(updatedUser.toJson()),
  //     // );
  //
  //     if (response.statusCode == 200) {
  //       User updatedUser = User.fromJson(jsonDecode(response.body));
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Profile updated successfully')),
  //       );
  //     } else {
  //       throw Exception('Failed to update user');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: ${e.toString()}')),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getAllBatches();
    getAllDepartments();
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
    rollNoController.text = widget.user.rollNo;
    userTypeController.text = widget.user.userType;
    _selectedGender = widget.user.gender;
    phoneController.text = widget.user.phone;
    ageController.text = widget.user.age.toString();
    _selectedBatchId = widget.user.batchId;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage('assets/profile_image.jpg'), // Replace with actual image asset
                  child: profileImage == null
                      ? const Icon(Icons.camera_alt)
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(image: FileImage(profileImage!), fit: BoxFit.fill),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: rollNoController,
                decoration: const InputDecoration(labelText: 'Roll No'),
              ),
              TextField(
                controller: userTypeController,
                decoration: const InputDecoration(labelText: 'User Type'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: genders.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<int>(
                style: const TextStyle(color: Colors.black),
                value: _selectedBatchId,
                items: _batches?.map((batch) {
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
              DropdownButtonFormField<int>(
                value: _selectedDepartment,
                items: _departments?.map((department) {
                  return DropdownMenuItem<int>(
                    value: department.id,
                    child: Text(department.dep_name.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},

                child: const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
