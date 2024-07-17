import 'package:flutter/material.dart';
import 'package:project/Services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/user_model.dart';
import '../authentication/loginPage.dart';
import 'editProfile.dart';

class ProfilePage extends StatefulWidget {


  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = false;
  bool isError = false;
   int ? id;

  Future<void> getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      final sp= await SharedPreferences.getInstance();
      setState(() {
        id=sp.getInt('user_id');
      });
      final response = await UserServices().getUserById(id!);
      setState(() {
        user = response;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      print('Error fetching user details: $error');
    }
  }


  Future<void> openDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              try{
              UserServices().removeUserId();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );}catch(err){
                throw Exception("Error in logging out");
              }
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("NO"),
          ),
        ],
      ),
    );
    if (result == true) {
      // Perform logout action
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),):ListView(
        physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 255,
              width: 400,
              child: Stack(
                alignment:Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () => {

                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(),
                          height: 170,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10.0),
                          child: const ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/mrsptu.jpg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                   Positioned(
                    bottom: 10.0,
                    left: 70.0,
                    right: 70,
                    child: CircleAvatar(
                      maxRadius: 50,
                      minRadius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image:AssetImage('assets/images/sports.jpg'),fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                user?.name.toUpperCase() ?? '',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProfileScreen(user: user!,)))
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, color: Colors.black),
                      Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.more_horiz),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded),
                      Text(
                        "Department : ${user?.departmentId ?? ''}",
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    children: [
                      const Icon(Icons.batch_prediction),
                      Text(
                        'Batch: ${user?.batchId ?? ''}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    children: [
                      const Icon(Icons.mail),
                      Text(
                        '${user?.email ?? ''}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 3,),
            const Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Row(
                children: [
                Icon(Icons.list_alt_rounded),
                Text("Participated",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)
                ],
              ),
              Row(
                children: [
                Icon(Icons.list_alt_rounded),
                Text("Organized",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)
                ],
              )
            ],),
            const Divider(
              thickness: 4,
              color: Colors.black38,
            ),
            ElevatedButton(
              onPressed: () {
                openDialog();
              },
              child: const Text("Logout"),
            )
          ],
        ),
      );
  }
}
