import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project/authentication/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KeyLogin='logedin';

  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a splash screen
    isLogedin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "yes",
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your college logo or name here
              Container(
                height: 110,
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
          
                  ),
                  child: Image.asset('assets/images/mrsptu.jpg', width: 100, height: 100,)),
              Shimmer.fromColors(
                baseColor: Colors.black,
                highlightColor: Colors.redAccent,
                child: const Text(
                  'GZSCCET, MRSPTU Bathinda',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              // Loading indicator
            ],
          ),
        ),
      ),
    );
  }

  void isLogedin()async {

    var sp=await SharedPreferences.getInstance();
   var Islogedin= sp.getBool(KeyLogin);
   
    Timer(const Duration(seconds: 4), () {
      if(Islogedin!=null){

        if(Islogedin){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MainPage()));
        }
        else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }

    });
  }
}