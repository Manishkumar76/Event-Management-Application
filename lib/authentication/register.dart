import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/constant/utils.dart';


import 'loginPage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isShow=false;
  final TextEditingController _passController= TextEditingController();
  final TextEditingController _nameController= TextEditingController();
  final TextEditingController _idController= TextEditingController();
  final TextEditingController _mobileController= TextEditingController();
  final TextEditingController _emailController= TextEditingController();
  var _DeptController;
  var _batchController;
  bool isNotValid=false;

  void register() async {
    if (_emailController.text.isNotEmpty && _passController.text.isNotEmpty) {
      setState(() {
        isNotValid = false;
      });

      // var registerBody = {
      //   "u_name": _nameController.text,
      //   "Email": _emailController.text,
      //   "u_id": _idController.text,
      //   "mobile_no": _mobileController.text,
      //   "pass_word": _passController.text,
      //   "department":_DeptController,
      //   "batch":_batchController
      // };

      try {
        var response = await http.post(
          Uri.parse("${Utils.baseUrl}user/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "u_name": _nameController.text,
            "Email": _emailController.text,
            "u_id":  _idController.text,
            "mobile_no": _mobileController.text,
            "pass_word": _passController.text,
            "department":_DeptController,
            "batch":_batchController
          }), // Convert the map to a JSON string
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          // print(response.body);
        } else {
          if( response.statusCode==401) {
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This Account Is Already Exists !. Please Create New Account.'),
              duration: Duration(seconds: 3),
            ),
          );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred during registration. Please try again.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (error) {
        // Handle the error
        print("Error: $error");
      }
    } else {
      setState(() {
        isNotValid = true;
      });
    }
  }

  List listvalue=[
    'CSE','Civil','Pharmacy','Electrical Engineering','Electronics & Communication','Architecture','CSE- AI & ML','Mathematics','BBA','BCA','Physics','Chemistry','Food Science & Technology','Agriculture'
  ];
  List listvalue2=[
    "2017","2018","2019","2020","2021","2022","2023","2024","2025","2026",
    "2027","2028","2029","2030","2031"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
        child:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const Image(image:AssetImage("assets/images/why-image.png"),height: 300,),
             const  SizedBox(
                height: 20,
              ),
             const  Text(
                "We need to register you before getting started!",
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const  SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  errorText: isNotValid?"Enter proper info":null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.black)
                  ),
                  enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.blueAccent)
                  ),
                  label: const Text("Name"),
                ),
              ),
              const  SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  errorText: isNotValid?"Enter proper info":null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.black)
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const  BorderSide(color: Colors.blueAccent)
                  ),
                  label: const Text("Email"),
                ),
              ),
              const  SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  errorText: isNotValid?"Enter proper info":null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.black)
                  ),
                  enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.blueAccent)
                  ),
                  label: const Text("Roll Number"),
                ),
              ),
              const  SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                style: const TextStyle(fontSize: 15,color: Colors.black),
                dropdownColor: Colors.white,
                decoration: InputDecoration(

                 enabledBorder: OutlineInputBorder(borderSide:const BorderSide(width: 1,color: Colors.blueAccent)
                 ,borderRadius: BorderRadius.circular(10)
                 ),
                  border: OutlineInputBorder(borderSide:const BorderSide(width: 1,color: Colors.blueAccent)
                      ,borderRadius: BorderRadius.circular(10)),
                ),
                hint: const Text('Departments'),
                  value: _DeptController,
                  items:listvalue.map((items){
                    return DropdownMenuItem(
                        value: items,
                        child:Text(items));
                  }).toList(),
                  onChanged: (newvalue){
                    setState(() {
                      _DeptController=newvalue;
                      print(_DeptController);
                    });
              }),

              const   SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                  style: const TextStyle(fontSize: 15,color: Colors.black),
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(

                    enabledBorder: OutlineInputBorder(borderSide:const BorderSide(width: 1,color: Colors.blueAccent)
                        ,borderRadius: BorderRadius.circular(10)
                    ),
                    border: OutlineInputBorder(borderSide:const BorderSide(width: 1,color: Colors.blueAccent)
                        ,borderRadius: BorderRadius.circular(10)),
                  ),
                  hint: const Text('Batch'),
                  value: _batchController,
                  items:listvalue2.map((items){
                    return DropdownMenuItem(
                        value: items,
                        child:Text(items));
                  }).toList(),
                  onChanged: (newvalue){
                    setState(() {
                      _batchController=newvalue;
                      print(_batchController);
                    });
                  }),

              const   SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(
                  errorText: isNotValid?"Enter proper info":null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.black)
                  ),
                  enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.blueAccent)
                  ),
                  label: const Text("Mobile Number"),
                ),
              ),

            const   SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passController,
                obscureText: _isShow?false:true,
                decoration: InputDecoration(
                    errorText: isNotValid?"Enter proper info":null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.black)
                  ),
                  enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const  BorderSide(color: Colors.blueAccent)
                  ),
                  label: const Text("password"),

                  suffixIcon: IconButton(icon:Icon(_isShow?Icons.remove_red_eye_rounded:Icons.remove_red_eye_outlined), onPressed: () { setState(() {
                    _isShow= !_isShow;

                  }); },)
                ),
              ),
             const  SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),), backgroundColor: Colors.blue),
                  onPressed: ()=> register(),
                  child: const Text("Register",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.white),)),
            ],
          ),
        ),
      ),
    );
  }
}


