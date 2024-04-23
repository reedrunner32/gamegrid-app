import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import '../screens/GameScreen.dart';
import 'FriendScreen.dart';
import 'GameListScreen.dart';
import 'ReviewScreen.dart';
import 'UserReviewsScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.friendName, {super.key});

  final String friendName;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var user;
  void _getUser(String displayName) async {
    var data = await ContentData.searchUsers(displayName);

    if(data.runtimeType == String) return; // fetch error

    setState(() {
      user = data;
      built = true;
    });
  }

  bool built = false;

  @override
  Widget build(BuildContext context) {
    if(!built) _getUser(widget.friendName);
    Color background_color = const Color.fromRGBO(25, 28, 33, 1);
    Color text_color = const Color.fromRGBO(155, 168, 183, 1);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.friendName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: (user != null) ? Container(
        color: background_color,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Center(
                child: Icon(
                  Icons.person_outline,
                  size: 100,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 5),
              const Divider(color: Colors.black26, height: 0,),
              ListTile(
                leading: Icon(Icons.people, color: text_color), // Set icon color to white
                title: const Padding(padding: EdgeInsets.only(left: 5), child:
                Text('Friends', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),),),
                onTap: () {
                  // Display friends list on a new page
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FriendScreen(user["id"])));
                },
              ),
              const Divider(color: Colors.black26, height: 0,),
              ListTile(
                leading: Icon(Icons.rate_review, color: text_color), // Set icon color to white
                title: const Padding(padding: EdgeInsets.only(left: 5), child:
                Text('Activity', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),),), // Set text color to white
                onTap: () {
                  // Navigate to your activity page
                  // Updated to display review activity placeholders
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserReviewsScreen(widget.friendName)));
                },
              ),
              const Divider(color: Colors.black26, height: 0,),
              ListTile(
                leading: Icon(Icons.games, color: text_color), // Set icon color to white
                title: const Padding(padding: EdgeInsets.only(left: 5), child:
                Text('Game List', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),),), // Set text color to
                onTap: () {
                  // Navigate to game list page
                  // Updated to display a grid view of games
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GameListScreen(user["id"])));
                },
              ),
              const Divider(color: Colors.black26, height: 0,),
            ],
          ),
      ) : Container(
          color: background_color,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            strokeWidth: 6,
            color: Color.fromRGBO(10, 147, 150, 0.5),
          )
      ),
    );
  }
}

/* -----------------------------
  *  -- Review container data
        {
            "_id": "6619bc03ad668a962cd885b8",
            "dateWritten": "2024-04-12T22:56:03.974Z",
            "textBody": "Its peak",
            "rating": 5,
            "videoGameId": "133236",
            "displayName": null
        },
  *
  * ----------------------------- */

/* -----------------------------
  *  -- Game info container
    {
          "id": 250616,
          "cover": {
              "id": 331836,
              "url": "//images.igdb.com/igdb/image/upload/t_thumb/co741o.jpg"
          },
          "first_release_date": 1707350400,
          "name": "Helldivers 2",
          "summary": "summary here",
      }
  * ----------------------------- */