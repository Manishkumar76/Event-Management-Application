

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/homepage.dart';



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp( const MyApp());
}

class MyApp extends StatelessWidget{
   const MyApp({super.key ,});

  @override
  Widget build(BuildContext context) {

   return  MaterialApp(
    home:HomePage(),
    title:"project" ,
    debugShowCheckedModeBanner: false,
   );
  }
}

// class MainPage extends StatefulWidget {
//    const MainPage({super.key,});
//
//   @override
//   State<MainPage> createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return const Homepage();
//   }
// }