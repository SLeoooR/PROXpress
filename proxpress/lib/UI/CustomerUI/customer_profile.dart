import 'package:flutter/material.dart';
import 'package:proxpress/Load/user_load.dart';
import 'package:proxpress/UI/login_screen.dart';
import 'package:proxpress/services/database.dart';
import 'package:proxpress/models/user.dart';
import 'package:provider/provider.dart';
import 'package:proxpress/models/customers.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}
class _CustomerProfileState extends State<CustomerProfile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    if (user != null) {
      return user == null ? LoginScreen() : SingleChildScrollView(
        child: StreamBuilder<Customer>(
          stream: DatabaseService(uid: user.uid).customerData,
          builder: (context,snapshot) {
            if (snapshot.hasData) {
              Customer customerData = snapshot.data;

              return Column(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20,),
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(customerData.avatarUrl),
                          backgroundColor: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: 360,
                          child: TextButton.icon(
                            icon: Icon(Icons.edit_rounded, size: 15, color: Colors.red),
                            label: Text('Edit Profile', style: TextStyle(fontSize: 15, color: Colors.red),),
                            style : ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(BorderSide(color: Colors.red))
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/customerUpdate');
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            '${customerData.fName} ${customerData.lName}',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Container(
                            padding: EdgeInsets.only(top: 5, left: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Container(padding:  EdgeInsets.only(right: 5), child: Icon(Icons.home_rounded, size: 20,)),
                                    Text(customerData.address, style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(padding:  EdgeInsets.only(right: 5), child: Icon(Icons.alternate_email_rounded, size: 20,)),
                                    Text(customerData.email, style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(padding:  EdgeInsets.only(right: 5), child: Icon(Icons.phone_rounded, size: 20,)),
                                    Text(customerData.contactNo, style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return UserLoading();
            }
          }
        ),
      );
    } else {
      return Container();
    }
  }
}