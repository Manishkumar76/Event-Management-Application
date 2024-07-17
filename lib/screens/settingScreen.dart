import 'package:flutter/material.dart';
import 'package:project/screens/securityScreen.dart';

import '../Services/user_services.dart';
import '../authentication/loginPage.dart';
import '../profiles/editProfile.dart';
// import '../profiles/userProfile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: IconButton(onPressed: () {  }, icon: const Icon(Icons.arrow_back_ios_new_rounded),),
        // ),
        centerTitle: true,
        title: const Text('Settings',style: TextStyle(fontWeight: FontWeight.w700),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [

            const Text("Account",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
            // ListTile(
            //   title: const Text('Edit profile',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
            //   leading: const Icon(Icons.edit),
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProfileScreen(use,)));
            //   },
            //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
            // ),
            ListTile(
              title: const Text('Security',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
              leading: const Icon(Icons.security),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>const SecurityScreen()));
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              title: const Text('Notifications',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
              leading: const Icon(Icons.notifications),
              onTap: () {

              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              title: const Text('Privacy',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
              leading: const Icon(Icons.lock),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),

            const Text("Support & About",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
            ListTile(
              title: const Text('Help & Support',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
              leading: const Icon(Icons.help),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              title: const Text('Terms and Policies',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
              leading: const Icon(Icons.policy),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),

            const Text("Actions",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
            ListTile(
              title: const Text('Report a problem',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
              leading: const Icon(Icons.report),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              title: const Text('Add account',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
              leading: const Icon(Icons.add),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              title: const Text('Log out',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
              leading: const Icon(Icons.logout),
              onTap: () {
                try{
                  UserServices().removeUserId();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );}catch(err){
                  throw Exception("Error in logging out");
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
