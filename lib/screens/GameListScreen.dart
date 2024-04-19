import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import '../screens/GameScreen.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {

  var profileGameIds;
  List<GameCard> userGames = [];
  void _getUserGames() async {

    var userGameIds = await ContentData.fetchUserGames(GlobalData.userID);
    if(userGameIds.runtimeType == String) return; //fetch error

    List<GameCard> temp = [];
    for(int i = 0; i<userGameIds.length; i++) {
      var gameData = await ContentData.fetchGameInfo(userGameIds[i]);
      temp.add(GameCard('https:${gameData["cover"]["url"].replaceAll('t_thumb','t_cover_big')}', '${gameData["id"]}'));
    }

    setState(() {
      profileGameIds = userGameIds;
      userGames.addAll(temp);
      built = true;
    });
  }

  bool built = false;

  @override
  Widget build(BuildContext context) {
    if(!built) _getUserGames();

    return Scaffold(
      appBar: AppBar(
        title: Text("Games"),
        backgroundColor: Colors.black,
      ),
      body: (profileGameIds != null) ? Container(
        child:
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: userGames.length, // Placeholder for number of reviews
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                          settings: RouteSettings(
                              arguments: userGames[index].gameId
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
                        child: Image.network(userGames[index].imageURL)
                    )
                );
              }
          )
      ) : const Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            color: Color.fromRGBO(10, 147, 150, 0.5),
          )
      ),
    );
  }
}

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
