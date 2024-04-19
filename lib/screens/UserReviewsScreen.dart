import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import '../screens/GameScreen.dart';

class UserReviewsScreen extends StatefulWidget {
  const UserReviewsScreen({super.key});

  @override
  State<UserReviewsScreen> createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends State<UserReviewsScreen> {

  var profileReviews;
  void _getReviews() async {

    var userReviews = await ContentData.fetchUserReviews(GlobalData.displayName);
    if(userReviews.runtimeType == String) return; //fetch error

    setState(() {
      profileReviews = userReviews;
      built = true;
    });
  }

  bool built = false;

  @override
  Widget build(BuildContext context) {
    if(!built) _getReviews();

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Reviews"),
        backgroundColor: Colors.black,
      ),
      body: (profileReviews != null) ? Column(
        children: [
          Text("Reviews"),
          Expanded(
            child:
            ListView.builder(
                itemCount: profileReviews.length, // Placeholder for number of reviews
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(profileReviews[index]["videoGameId"]),
                    title: Text(profileReviews[index]["textBody"]),
                  );
                }
            ),
          ),
        ],
      ) : Container(child: Text("Loading")),
    );
  }

}