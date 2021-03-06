import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:proxpress/UI/CustomerUI/dashboard_customer.dart';

class VehicleType extends StatefulWidget {
  final String pickupAddress;
  final GeoPoint pickupCoordinates;
  final String dropOffAddress;
  final GeoPoint dropOffCoordinates;
  final double distance;

  VehicleType({
    Key key,
    @required this.pickupAddress,
    @required this.pickupCoordinates,
    @required this.dropOffAddress,
    @required this.dropOffCoordinates,
    @required this.distance,
  }) : super(key: key);

  @override
  _VehicleTypeState createState() => _VehicleTypeState();
}

Widget _buildCard(String image, String title, String dimension, int weight){
  return ListTile(
    leading: Container(
        width: 80,
        child: Image.asset('assets/vehicles/${image}', color: Colors.grey[700])
    ),
    title: Text(title ,style: TextStyle(fontWeight: FontWeight.bold),),
    subtitle: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dimension} Meter'),
            Text('Up to ${weight} kg'),
          ]),
    ),
  );
}

class _VehicleTypeState extends State<VehicleType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xfffb0d0d)),
        flexibleSpace: Container(
          margin: EdgeInsets.only(top: 10),
          child: Image.asset(
            "assets/PROExpress-logo.png",
            height: 120,
            width: 120,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select Vehicle',style: TextStyle(fontSize: 25,),),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageTransition(
                          child: DashboardCustomer(
                            pickupAddress: widget.pickupAddress,
                            pickupCoordinates: widget.pickupCoordinates,
                            dropOffAddress: widget.dropOffAddress,
                            dropOffCoordinates: widget.dropOffCoordinates,
                            distance: widget.distance,
                            vehicleType: 'Motorcycle',),type: PageTransitionType.bottomToTop),
                    );
                  },
                  child: _buildCard(
                      'motorcycle.png',
                      'Motorcycle',
                      '0.5 x 0.4 x 0.5',
                      20,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageTransition(
                          child: DashboardCustomer(
                            pickupAddress: widget.pickupAddress,
                            pickupCoordinates: widget.pickupCoordinates,
                            dropOffAddress: widget.dropOffAddress,
                            dropOffCoordinates: widget.dropOffCoordinates,
                            distance: widget.distance,
                            vehicleType: 'Sedan',),type: PageTransitionType.bottomToTop),
                    );
                  },
                  child: _buildCard(
                    'sedan.png',
                    'Sedan',
                    '1 x 0.6 x 0.7',
                    200,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageTransition(
                          child: DashboardCustomer(
                            pickupAddress: widget.pickupAddress,
                            pickupCoordinates: widget.pickupCoordinates,
                            dropOffAddress: widget.dropOffAddress,
                            dropOffCoordinates: widget.dropOffCoordinates,
                            distance: widget.distance,
                            vehicleType: 'MPV',),type: PageTransitionType.bottomToTop),
                    );
                  },
                  child: _buildCard(
                    'mpv.png',
                    'Multi-Purpose  Vehicle (MPV)',
                    '1.2 x 1 x 0.9',
                    300,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageTransition(
                          child: DashboardCustomer(
                            pickupAddress: widget.pickupAddress,
                            pickupCoordinates: widget.pickupCoordinates,
                            dropOffAddress: widget.dropOffAddress,
                            dropOffCoordinates: widget.dropOffCoordinates,
                            distance: widget.distance,
                            vehicleType: 'Pickup Truck',),type: PageTransitionType.bottomToTop),
                    );
                  },
                  child: _buildCard(
                    'pickup-truck.png',
                    'Pickup Truck',
                    '1.4 x 1.4 x 1.5',
                    500,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageTransition(
                          child: DashboardCustomer(
                            pickupAddress: widget.pickupAddress,
                            pickupCoordinates: widget.pickupCoordinates,
                            dropOffAddress: widget.dropOffAddress,
                            dropOffCoordinates: widget.dropOffCoordinates,
                            distance: widget.distance,
                            vehicleType: 'Van',),type: PageTransitionType.bottomToTop),
                    );
                  },
                  child: _buildCard(
                    'van.png',
                    'Van',
                    '2.1 x 1.2 x 1.2',
                    600,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageTransition(
                          child: DashboardCustomer(
                              pickupAddress: widget.pickupAddress,
                              pickupCoordinates: widget.pickupCoordinates,
                              dropOffAddress: widget.dropOffAddress,
                              dropOffCoordinates: widget.dropOffCoordinates,
                              distance: widget.distance,
                              vehicleType: 'FB-Type Van',),type: PageTransitionType.bottomToTop),
                    );
                  },
                  child: _buildCard(
                    'fb-type.png',
                    'Family Business Type Van',
                    '2.2 x 1.5 x 1.3',
                    700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
