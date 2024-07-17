import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Change Password'),
            leading: Icon(Icons.lock),
            onTap: () {
              // Navigate to change password screen
            },
          ),
          ListTile(
            title: Text('Two-Factor Authentication'),
            leading: Icon(Icons.security),
            onTap: () {
              // Navigate to 2FA setup screen
            },
          ),
          ListTile(
            title: Text('Security Questions'),
            leading: Icon(Icons.help),
            onTap: () {
              // Navigate to security questions setup screen
            },
          ),
          ListTile(
            title: Text('Login Activity'),
            leading: Icon(Icons.history),
            onTap: () {
              // Navigate to login activity screen
            },
          ),
          ListTile(
            title: Text('Authorized Devices'),
            leading: Icon(Icons.devices),
            onTap: () {
              // Navigate to authorized devices screen
            },
          ),
          ListTile(
            title: Text('Account Recovery Options'),
            leading: Icon(Icons.account_circle),
            onTap: () {
              // Navigate to account recovery options screen
            },
          ),
          ListTile(
            title: Text('Privacy Settings'),
            leading: Icon(Icons.privacy_tip),
            onTap: () {
              // Navigate to privacy settings screen
            },
          ),
          ListTile(
            title: Text('Data Protection'),
            leading: Icon(Icons.security),
            onTap: () {
              // Navigate to data protection information screen
            },
          ),
          ListTile(
            title: Text('Session Timeout'),
            leading: Icon(Icons.timer),
            onTap: () {
              // Navigate to session timeout settings screen
            },
          ),
          ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
            onTap: () {
              // Navigate to notifications settings screen
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SecurityScreen(),
  ));
}
