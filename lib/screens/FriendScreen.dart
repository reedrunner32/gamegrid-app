import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import 'package:gamegrid/screens/ProfileScreen.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {

  var friends;
  void _getFriendList() async {
    var data = await ContentData.fetchFriendList();
    setState(() {
      friends = data;
      built = true;
    });
  }

  bool built = false;

  @override
  Widget build(BuildContext context) {
    if(!built) _getFriendList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        backgroundColor: Colors.black,
      ),
      body: (friends != null) ? ListView.builder(
        itemCount: friends.length, // Placeholder for number of reviews
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(friends[index]["displayName"]),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => ProfileScreen(friends[index]["displayName"])));
            }
          );
        }
      ) : Container(),
    );
  }
}