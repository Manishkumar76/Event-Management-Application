import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  var result="";

  void changePassword() {
    // Change password logic
    if(_currentPasswordController.text.isEmpty || _newPasswordController.text.isEmpty || _confirmNewPasswordController.text.isEmpty) {
      // Show error message
      setState(() {
        result="all fields are required";
      });
      return;
    }
    else{
      if(_newPasswordController.text != _confirmNewPasswordController.text) {
        // Show error message
        setState(() {
          result="passwords do not match";
        });
        return;
      }
      if(_newPasswordController.text==_confirmNewPasswordController.text){
        setState(() {
          result="";
        });
      }
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(result.isNotEmpty)
              Text(result,style: const TextStyle(color: Colors.red),)
            else const SizedBox(height: 17,),
             TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
            ),
             TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
             TextField(
               controller: _confirmNewPasswordController,
              onChanged: (value) {
                // Confirm new password logic

              } ,

              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                changePassword();
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
