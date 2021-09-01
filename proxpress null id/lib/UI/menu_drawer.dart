import 'package:flutter/material.dart';
import 'package:proxpress/services/auth.dart';
import 'package:proxpress/Load/user_load.dart';
import 'package:proxpress/services/database.dart';
import 'package:proxpress/models/user.dart';
import 'package:provider/provider.dart';
import 'package:proxpress/models/customers.dart';
import 'package:proxpress/services/default_profile_pic.dart';


class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}
void selectedItem(BuildContext context, int index){
  Navigator.of(context).pop();
  switch (index){
    case 0:
      Navigator.pushNamed(context, '/customerProfile');
      break;
    case 1:
      Navigator.pushNamed(context, '/dashboardLocation');
      break;
    case 2:
      Navigator.pushNamed(context, '/courierBookmarks');
      break;
    case 3:
      Navigator.pop(context);
      break;
  }
}
Future _getDefaultProfile(BuildContext context, String imageName) async {
  Image image;
  await FireStorageService.loadImage(context, imageName).then((value) {
    image = Image.network(
      value.toString(),
      // fit: BoxFit.scaleDown,
    );
  });
  return image;
}

class _MainDrawerState extends State<MainDrawer> {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(
                  child: StreamBuilder<Customer>(
                    stream: DatabaseService(uid: user.uid).customerData,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        Customer customerData = snapshot.data;
                        return Column(
                          children: [
                            Container(
                              child: FutureBuilder(
                                  future: _getDefaultProfile(context, "profile-user.png"),
                                  builder: (context, snapshot) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width / 5,
                                      height: MediaQuery.of(context).size.width / 5,
                                      child: snapshot.data,
                                    );
                                  }
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text('${customerData.fName} ${customerData.lName}', style: TextStyle(fontSize: 20)),
                          ],
                        );
                      }
                      else{
                        return UserLoading();
                      }
                    }
                  ),
                  decoration: BoxDecoration(

                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle_rounded, color: Color(0xfffb0d0d),),
                  title: Text('Profile', style: TextStyle(color: Color(0xfffb0d0d))),
                  onTap: () {
                    selectedItem(context, 0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.place, color: Color(0xfffb0d0d),),
                  title: Text('Pin Location', style: TextStyle(color: Color(0xfffb0d0d))),
                  onTap: () {
                    selectedItem(context, 1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bookmark, color: Color(0xfffb0d0d),),
                  title: Text('Courier Bookmarks', style: TextStyle(color: Color(0xfffb0d0d))),
                  onTap: () {
                    selectedItem(context, 2);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notification_important_rounded, color: Color(0xfffb0d0d),),
                  title: Text('Delivery Status', style: TextStyle(color: Color(0xfffb0d0d))),
                  onTap: () {
                    selectedItem(context, 3);
                  },
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 20,
            width: MediaQuery.of(context).size.width / 1,
            child: ElevatedButton.icon(
              icon: Icon(Icons.logout_rounded),
              label: Text('Logout'),
              onPressed: () async{
                await _auth.signOut();
                //Navigator.pushNamed(context, '/loginScreen');
                // if(result == null){
                //   return LoadScreen();
                // }
              },
              style: ElevatedButton.styleFrom(primary: Color(0xfffb0d0d), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),),
            ),
          ),
        ],
      ),
    );
  }
}