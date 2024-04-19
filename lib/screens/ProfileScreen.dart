import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import '../screens/GameScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.friendName, {super.key});

  final String friendName;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var profileData;
  var profileReviews;
  var profileGameIds;
  List<GameCard> profileGames = [];
  void _getProfile(String displayName) async {
    var userData = await ContentData.searchUsers(displayName);
    if(userData.runtimeType == String) return; //fetch error

    var userReviews = await ContentData.fetchUserReviews(displayName);
    if(userReviews.runtimeType == String) return; //fetch error

    var userGameIds = await ContentData.fetchUserGames(userData["id"]);
    if(userGameIds.runtimeType == String) return; //fetch error

    List<GameCard> temp = [];
    for(int i = 0; i<userGameIds.length; i++) {
      var gameData = await ContentData.fetchGameInfo(userGameIds[i]);
      temp.add(GameCard('https:${gameData["cover"]["url"].replaceAll('t_thumb','t_cover_big')}', '${gameData["id"]}'));
    }

    setState(() {
      profileData = userData;
      profileReviews = userReviews;
      profileGameIds = userGameIds;
      profileGames.addAll(temp);
      built = true;
    });
  }

  bool built = false;

  @override
  Widget build(BuildContext context) {
    if(!built) _getProfile(widget.friendName);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friendName),
        backgroundColor: Colors.black,
      ),
      body: (profileGameIds != null) ? Container(
          child: Column(
            children: [
              Text("Reviews"),
              Expanded(
                child:
              ListView.builder(
                itemCount: profileReviews.length, // Placeholder for number of reviews
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(profileReviews[index]["videoGameId"] + " - " + profileReviews[index]["textBody"]),
                  );
                }
              ),
              ),
              Text("Games"),
              Expanded(
                child:
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: profileGames.length, // Placeholder for number of reviews
                  itemBuilder: (context, index) {
                    return TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GameScreen(),
                              settings: RouteSettings(
                                  arguments: profileGames[index].gameId
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          splashFactory: NoSplash.splashFactory,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ),
                        child:
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(profileGames[index].imageURL)
                        )
                    );
                  }
              )
              )
            ],
          ),
      ) : Container(child: Text("Loading")),
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