import 'package:flutter/material.dart';
import '../utils/getAPI.dart';
import '../screens/GameScreen.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen(this.userId, {super.key});

  final String userId;

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {

  var profileGameIds;
  List<GameCard> userGames = [];
  void _getUserGames(String userId) async {

    var userGameIds = await ContentData.fetchUserGames(userId);
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
    if(!built) _getUserGames(widget.userId);
    Color background_color = const Color.fromRGBO(25, 28, 33, 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Games',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: (profileGameIds != null) ? Container(
        color: background_color,
        child:
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 0,
                childAspectRatio: 1/1.25,
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
