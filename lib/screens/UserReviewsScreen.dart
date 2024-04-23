import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import '../screens/GameScreen.dart';
import 'ProfileScreen.dart';
import 'ReviewScreen.dart';

class UserReviewsScreen extends StatefulWidget {
  const UserReviewsScreen(this.displayName, {super.key});

  final String displayName;

  @override
  State<UserReviewsScreen> createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends State<UserReviewsScreen> {

  var profileReviews;
  void _getReviews(String displayName) async {

    var userReviews = await ContentData.fetchUserReviews(displayName);
    if(userReviews.runtimeType == String) return; //fetch error

    setState(() {
      profileReviews = userReviews;
      built = true;
    });
  }

  bool built = false;

  @override
  Widget build(BuildContext context) {
    if(!built) _getReviews(widget.displayName);
    Color background_color = Color.fromRGBO(25, 28, 33, 1);
    Color text_color = Color.fromRGBO(155, 168, 183, 1);
    Color button_color = Color.fromRGBO(10, 147, 150, 1);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          "Activity",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
      body: (profileReviews != null) ? Container(
        color: background_color,
        child: (profileReviews.length != 0) ?
        ListView.builder(
              itemCount: profileReviews.length, // Placeholder for number of reviews
              itemBuilder: (context, index) {
                int reverseIndex = profileReviews.length - index - 1;
                var iteratorReview = profileReviews[reverseIndex];
                DateTime currentTime = DateTime.now();
                Duration timeSince = currentTime.difference(DateTime.parse(iteratorReview["dateWritten"]));
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewScreen(iteratorReview["_id"], iteratorReview["videoGameName"], iteratorReview["textBody"], iteratorReview["displayName"], iteratorReview["rating"], timeSince, iteratorReview["videoGameId"])),
                      ).then((refresh) {
                        if(refresh) {
                          setState(() {
                            profileReviews = null;
                            built = false;
                          });
                        }
                      });;
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: text_color)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(),
                                  settings: RouteSettings(
                                      arguments: iteratorReview["videoGameId"]
                                  ),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(),
                              splashFactory: NoSplash.splashFactory,
                            ),
                            child: Text(
                              iteratorReview["videoGameName"],
                              style: TextStyle(
                                color: text_color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(iteratorReview["rating"], (index) {
                                    return Icon(
                                        Icons.star,
                                        size: 20,
                                        color: button_color
                                    );
                                  }),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen(iteratorReview["displayName"])),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(),
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    iteratorReview["displayName"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: text_color,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            iteratorReview["textBody"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),
                          (timeSince.inHours < 1) ? Text(
                            'less than an hour ago',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ) : (timeSince.inDays < 1) ?
                          Text(
                            '${timeSince.inHours} hours ago',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ) : Text(
                            '${timeSince.inDays} days ago',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                );
              }
          ) : Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 25),
          child: Text(
            "No Reviews yet...",
            style: TextStyle(
              color: text_color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
          ) : Container(
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