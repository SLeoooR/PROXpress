import 'package:flutter/material.dart';
import 'package:proxpress/services/auth.dart';


class CourierDashboard extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton.icon(
          icon: Icon(Icons.logout_rounded),
          label: Text('Logout'),
          onPressed: () async{
            await _auth.signOut();
            Navigator.pushNamed(context, '/loginScreen');
          },
          style: ElevatedButton.styleFrom(primary: Color(0xfffb0d0d), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),),
        );
  }
}
