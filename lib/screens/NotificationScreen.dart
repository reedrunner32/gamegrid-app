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
    Color text_color = const Color.fromRGBO(155, 168, 183, 1);
    if (requests != null && requests.runtimeType != String) {
      return ListView.builder(
          itemCount: requests.length, // Placeholder for number of reviews
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  const Text(
                    "A user has sent you a friend request!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context) =>
                          ProfileScreen(requests[index]["displayName"])));
                    },
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, color: text_color,),
                        const SizedBox(width: 6,),
                        Text(
                          requests[index]["displayName"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            _acceptFriendRequest(requests[index]["id"]);
                            setState(() {
                              requests.removeAt(index);
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                      ),
                      const SizedBox(width: 2,),
                      OutlinedButton(
                          onPressed: () {
                            _rejectFriendRequest(requests[index]["id"]);
                            setState(() {
                              requests.removeAt(index);
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          child: const Text(
                            "Reject",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(color: Colors.white38, height: 0,)
                ],
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
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, (requests.length == 0));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: const Color.fromRGBO(25, 28, 33, 1),
      body: notifBody()
    );
  }
}