import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:proxpress/UI/CourierUI/courier_profile.dart';
import 'package:proxpress/UI/CourierUI/proxpress_template_courier.dart';
import 'package:proxpress/UI/CustomerUI/customer_remarks.dart';
import 'package:proxpress/UI/login_screen.dart';
import 'package:proxpress/classes/courier_classes/feedback_list.dart';
import 'package:proxpress/classes/customer_classes/view_courier_profile.dart';
import 'package:proxpress/models/couriers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proxpress/models/deliveries.dart';
import 'package:proxpress/models/delivery_prices.dart';
import 'package:proxpress/services/database.dart';

class CourierTile extends StatefulWidget {
  final Courier courier;
  final String pickupAddress;
  final LatLng pickupCoordinates;
  final String dropOffAddress;
  final LatLng dropOffCoordinates;
  final double distance;

  CourierTile({
    Key key,
    @required this.courier,
    @required this.pickupAddress,
    @required this.pickupCoordinates,
    @required this.dropOffAddress,
    @required this.dropOffCoordinates,
    @required this.distance,
  }) : super(key: key);

  @override
  State<CourierTile> createState() => _CourierTileState();
}

class _CourierTileState extends State<CourierTile> {
  int flag = 0;
  String deliveryPriceUid;
  double deliveryFee = 0.0;

  Widget _buildStars(int rate){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rate ? Icons.star : Icons.star_border, color: Colors.amber,
        );
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    deliveryPriceUid = widget.courier.deliveryPriceRef.id;

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;

    var color;
    if (widget.courier.status == "Offline") {
      color = Colors.redAccent;
    } else {
      color = Colors.green;
    }

    Stream<List<Delivery>> deliveryList = FirebaseFirestore.instance
        .collection('Deliveries')
        .where('Delivery Status', isEqualTo: 'Delivered')
        .where('Courier Reference', isEqualTo: FirebaseFirestore.instance.collection('Couriers').doc(widget.courier.uid))
        .snapshots()
        .map(DatabaseService().deliveryDataListFromSnapshot);

    if (user != null) {
      return StreamBuilder<DeliveryPrice>(
          stream: DatabaseService(uid: deliveryPriceUid).deliveryPriceData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DeliveryPrice deliveryPriceData = snapshot.data;

              deliveryFee = (deliveryPriceData.baseFare.toDouble() + (deliveryPriceData.farePerKM.toDouble() * widget.distance));
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        isThreeLine: true,
                        leading: ClipOval(
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Container(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(widget.courier.avatarUrl),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${widget.courier.fName} ${widget.courier.lName}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            StreamBuilder <List<Delivery>>(
                                stream: DatabaseService().deliveryList,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    List<Delivery> deliveryData = snapshot.data;
                                    double rating = 0.0;
                                    double total = 0.0;
                                    double stars = 0;


                                    for(int i = 0; i < deliveryData.length; i++){
                                      if(deliveryData[i].courierRef.id == widget.courier.uid && deliveryData[i].deliveryStatus == 'Delivered'){
                                        if(deliveryData[i].rating != 0 && deliveryData[i].feedback != ''){
                                          rating += deliveryData[i].rating;
                                          total++;
                                        }
                                      }
                                    };
                                    stars = (rating/total);
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(5, (index) {
                                            return Icon(
                                              index < stars ? Icons.star : Icons.star_border, color: Colors.amber,
                                            );
                                          }),
                                        ),
                                      ],
                                    );
                                  }
                                  else return Container();
                                }
                            ),
                          ],
                        ),
                        onTap : (){
                          Navigator.push(context, PageTransition(
                              child: ViewCourierProfile(
                                  courierUID: widget.courier.uid,
                              ),
                              type: PageTransitionType.fade
                          ));
                        },
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Vehicle Type: ', style: TextStyle(color: Colors.black),),
                                Text('${widget.courier.vehicleType}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Delivery Fee: ', style: TextStyle(color: Colors.black),),
                                Text('₱${deliveryFee.toInt()}.00', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.info_outline_rounded, color: Colors.red),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: .5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('REQUEST'),
                            onPressed: /*widget.courier.status == "Offline" ? null :*/ () {
                              Navigator.push(context, PageTransition(
                                  child: CustomerRemarks(
                                    courierUID: widget.courier.uid,
                                    pickupAddress: widget.pickupAddress,
                                    pickupCoordinates: widget.pickupCoordinates,
                                    dropOffAddress: widget.dropOffAddress,
                                    dropOffCoordinates: widget.dropOffCoordinates,
                                    deliveryFee: deliveryFee.toInt(),),
                                  type: PageTransitionType.bottomToTop
                              ));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(8),
                child: ExpansionTileCard(
                  title: Text("Loading...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  leading: ClipOval(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Container(
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  subtitle: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: SizedBox(height: 20),
                  ),
                ),
              );
            }
          }
      );
    } else {
      return LoginScreen();
    }
  }
}