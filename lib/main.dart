import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/events/createEventPage.dart';
import 'package:project/profiles/userProfile.dart';
import 'package:project/screens/homepage.dart';
import 'package:project/events/allEvents.dart';
import 'package:project/screens/settingScreen.dart';
import 'package:project/screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const SplashScreen(),
      title: "project",
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _selectedIndex = 0;
  int ?id;

 final List <Widget >_listwidget=[
   const HomePage(),
   const Events(),
   const SettingsScreen(),
   const ProfilePage(),

 ];
 @override
 void initState() {
    super.initState();
    getUserId();
  }

    Future<void> getUserId() async {
      var sp = await SharedPreferences.getInstance();
      setState(() {
        id = sp.getInt('id');
      });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _listwidget[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight *0.6,
          child: Container(
            decoration:  BoxDecoration(  color:Colors.white,
            borderRadius: BorderRadius.circular(20),

            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BottomNavigationBar(
                  backgroundColor: Colors.blue.shade100,
                  selectedFontSize: 10,
                  selectedItemColor: Colors.blue,
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  selectedLabelStyle: const TextStyle(color: Colors.blue),
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  currentIndex: _selectedIndex,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: "Home",
                      activeIcon: Icon(Icons.home_rounded),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.event_outlined),
                      label: "Events",
                      activeIcon: Icon(Icons.event),
                      tooltip: 'create'
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "Setting",
                      activeIcon: Icon(Icons.settings),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle_outlined),
                      label: "Profile",
                      activeIcon: Icon(Icons.account_circle_rounded),
                    ),
                  ]),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
        hoverElevation:4,
          tooltip: 'create',
          elevation: 6,
          backgroundColor: Colors.blue.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> CreateEventPage()));
          },
          splashColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
