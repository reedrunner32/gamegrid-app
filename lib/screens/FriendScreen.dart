import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import 'package:gamegrid/screens/ProfileScreen.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen(this.userId, {super.key});

  final String userId;

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {

  void displayNotif(String message) {
    ElegantNotification.info(
      width: 360,
      toastDuration: const Duration(milliseconds: 2500),
      stackedOptions: StackedOptions(
        key: 'top',
        type: StackedType.same,
        itemOffset: const Offset(-5, -5),
      ),
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      description: Text(message),
      shadow: BoxShadow(
        color: Colors.blue.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 4), // changes position of shadow
      ),
    ).show(context);
  }

  var friends;
  void _getFriendList(String userId) async {
    var data = await ContentData.fetchFriendList(userId);

    setState(() {
      friends = data;
      built = true;
    });
  }

  String addFriendTextField = '';
  Future<void> _sendFriendRequest() async {
    var userData = await ContentData.searchUsers(addFriendTextField);

    if(userData.runtimeType == String) {
      displayNotif("User does not exist");
      return; //fetch error
    }

    String friendId = userData["id"];
    String retMessage = await ContentData.sendFriendRequest(friendId); //return message
    displayNotif(retMessage);
  }

  Future<void> _removeFriend(String friendId) async {
    var message = await ContentData.removeFriend(friendId);

    int i;
    for(i = 0; i<friends.length; i++) {
      if(friends[i]["id"] == friendId) break;
    }
    setState(() {
      friends.removeAt(i);
    });
  }

  bool built = false;

  @override
  Widget build(BuildContext context) {
    if(!built) _getFriendList(widget.userId);
    Color background_color = Color.fromRGBO(25, 28, 33, 1);
    Color text_color = Color.fromRGBO(155, 168, 183, 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Friends',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        actions: [
          (widget.userId == GlobalData.userID) ? Container(
          margin: EdgeInsets.only(right: 10),
          child:
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Color.fromRGBO(10, 147, 150, 0.5),
              padding: EdgeInsets.all(3),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            icon: Icon(Icons.add, color: Colors.white, size: 30,), // Set icon color to white
            onPressed: () {
              showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10.0,
      backgroundColor: Color.fromRGBO(54, 75, 94, 1), // Original background color
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(54, 75, 94, 1), // Match the background color
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send Friend Request',
              style: TextStyle(
                color: Colors.white, // White text color
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
  onChanged: (value) {
    addFriendTextField = value;
  },
  decoration: InputDecoration(
    hintText: 'Enter display name',
    hintStyle: TextStyle(color: Colors.grey[400]),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White underline color
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide.none, // Remove the border
    ),
  ),
  cursorColor: Colors.white, // White cursor color
  style: TextStyle(color: Colors.white), // White text color
),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Grey button color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white), // White text color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _sendFriendRequest();
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(10, 147, 150, 1)), // Specified button color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(color: Colors.white), // White text color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
);


            },
          ),
          ) : SizedBox()
        ],
      ),
      body: (friends != null) ? Container(
        color: background_color,
      child:
      ListView.builder(
        itemCount: friends.length, // Placeholder for number of reviews
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.person, color: text_color,),
                title: Text(
                  friends[index]["displayName"],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                trailing: (widget.userId == GlobalData.userID) ? IconButton(
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  icon: Icon(Icons.delete,),
                  onPressed: () {
                    _removeFriend(friends[index]["id"]);
                  }
                ) : SizedBox(),
                onTap: () {
                  (friends[index]["id"] != GlobalData.userID) ? Navigator.push(context, MaterialPageRoute(builder:
                    (context) => ProfileScreen(friends[index]["displayName"]))) : ();
                }
              ),
              Divider(color: Colors.black26, height: 0,),
            ],
          );
        }
      )) : Container(
          color: background_color,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            color: Color.fromRGBO(10, 147, 150, 0.5),
          )
      ),
    );
  }
}