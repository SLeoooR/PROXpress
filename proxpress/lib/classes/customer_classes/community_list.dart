import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxpress/Load/user_load.dart';
import 'package:proxpress/classes/customer_classes/community_tile.dart';
import 'package:proxpress/models/community.dart';
class CommunityList extends StatefulWidget {

  @override
  _CommunityListState createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  @override
  Widget build(BuildContext context) {

    final community = Provider.of<List<Community>>(context);

    if(community.length != 0){
      return community == null ? UserLoading() : ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: community.length,
        itemBuilder: (context, index) {
          return CommunityTile(community: community[index],);
        },
      );
    }
    else{
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'You currently have no pending requests.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
