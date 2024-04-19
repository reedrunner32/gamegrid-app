import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import 'package:gamegrid/screens/ProfileScreen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  var requests;
  void _getReceivedRequest() async {
    var data = await ContentData.fetchFriendRequest();
    setState(() {
      requests = data;
      built = true;
    });
  }

  _acceptFriendRequest(String friendId) async {
    String message = await ContentData.acceptFriendRequest(friendId);
  }

  _rejectFriendRequest(String friendId) async {
    String message = await ContentData.rejectFriendRequest(friendId);
  }

  bool built = false;

  Widget notifBody() {
    if (requests != null && requests.runtimeType != String) {
      return ListView.builder(
          itemCount: requests.length, // Placeholder for number of reviews
          itemBuilder: (context, index) {
            return ListTile(
                leading: Icon(Icons.person),
                title: Text(requests[index]["displayName"]),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) =>
                      ProfileScreen(requests[index]["displayName"])));
                },
              trailing: SizedBox(
                width: 150,
                child:
                  Row(
                children: [
                  TextButton(
                      onPressed: () {
                        _acceptFriendRequest(requests[index]["id"]);
                        setState(() {
                          requests.removeAt(index);
                        });
                      },
                      child: Text("Accept")
                  ),
                  TextButton(
                      onPressed: () {
                        _rejectFriendRequest(requests[index]["id"]);
                        setState(() {
                          requests.removeAt(index);
                        });
                      },
                      child: Text("Reject")
                  ),
                ],
              ),
              )
            );
          });
    }
    else if(requests.runtimeType == String) {
      return Text(requests);
    }
    return const Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          strokeWidth: 6,
          color: Color.fromRGBO(10, 147, 150, 0.5),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!built) _getReceivedRequest();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.black,
      ),
      body: notifBody()
    );
  }
}