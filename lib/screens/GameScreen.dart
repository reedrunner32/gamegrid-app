import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamegrid/utils/getAPI.dart';
import 'package:gamegrid/screens/ReviewScreen.dart';
import 'package:intl/intl.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  void displayReviewNotif(String message) {
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

  _addGametoList(String videoGameId) async {
    var retMessage = await ContentData.addGametoList(videoGameId);
    displayReviewNotif(retMessage);
    setState(() {
      _isGameAdded = true;
    });
  }

  _removeGameFromList(int gameId) async {
    var retMessage = await ContentData.removeGameFromList(gameId);
    displayReviewNotif("Game removed from list successfully");
    setState(() {
      _isGameAdded = false;
    });
  }

  bool _isTextVisible = true;

  void _toggleTextVisibility() {
    setState(() {
      _isTextVisible = !_isTextVisible;
    });
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
          "involved_companies": [
              {
                  "id": 216800,
                  "company": {
                      "id": 953,
                      "name": "Arrowhead Game Studios"
                  }
              },
              {
                  "id": 219275,
                  "company": {
                      "id": 10100,
                      "name": "Sony Interactive Entertainment"
                  }
              }
          ],
          "name": "Helldivers 2",
          "platforms": [
              {
                  "id": 6,
                  "name": "PC (Microsoft Windows)"
              },
              {
                  "id": 167,
                  "name": "PlayStation 5"
              }
          ],
          "summary": "summary here",
      }
  * ----------------------------- */

  var game;
  var reviews;
  var stats;
  int descLength = 0;
  String companies = '';
  String platforms = '';
  bool _isGameAdded = false;
  void _getGameData(String videoGameId) async {
    var data = await ContentData.fetchGameInfo(videoGameId);
    var gameReviews = await ContentData.fetchGameReviews('${data["id"]}');

    //Check if game is added to library yet
    bool flag = false;
    String addGameMessage = await ContentData.addGametoList(videoGameId);
    if(addGameMessage.length == 24) {
      flag = true;
    }
    else {
      String removeGameMessage = await ContentData.removeGameFromList(data["id"]);
    }

    descLength = data["summary"].length;
    String tempCompanies = '';
    var gameCompanies = data["involved_companies"];
    for(int i = 0; i<gameCompanies.length; i++) {
      if(i != gameCompanies.length - 1) {
        tempCompanies += '${data["involved_companies"][i]["company"]["name"]}, ';
      } else {
        tempCompanies += '${data["involved_companies"][i]["company"]["name"]}';
      }
    }

    var gamePlatforms = data["platforms"];
    String tempPlatforms = '';
    for(int i = 0; i<gamePlatforms.length; i++) {
      if(i != gamePlatforms.length - 1) {
        tempPlatforms += '${data["platforms"][i]["name"]}, ';
      } else {
        tempPlatforms += '${data["platforms"][i]["name"]}';
      }
    }

    var gameStats = await ContentData.fetchGameStats(videoGameId);

    setState(() {
      game = data;
      reviews = gameReviews;
      _isGameAdded = flag;
      stats = gameStats;
      companies = tempCompanies;
      platforms = tempPlatforms;
      built = true;
    });
  }

  int selectedRating = 0; // Initialize selectedRating to 0
  String reviewText = '';
  void _submitReview(String videoGameId, String videoGameName) async {
    if(selectedRating == 0) {
      displayReviewNotif("Please select a rating");
      return;
    }
    if(reviewText == '') {
      displayReviewNotif("Please write a review");
      return;
    }
    var data = await ContentData.addReview(reviewText, '$selectedRating', videoGameId, GlobalData.displayName, videoGameName);
    displayReviewNotif(data);

    setState(() {
      _isGameAdded = true;
    });

  }

  bool built = false;

  @override
  Widget build(BuildContext context) {
    final videoGameId = ModalRoute.of(context)!.settings.arguments as String;
    if(!built) _getGameData(videoGameId);
    Color text_color = const Color.fromRGBO(155, 168, 183, 1);
    Size size = MediaQuery.of(context).size;
   return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.arrow_left, size: 35, color: Colors.white,),
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                color: Color.fromRGBO(54, 75, 94, 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.pop(context); // Close the modal bottom sheet
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return SingleChildScrollView(
                                  child: Container(
                                    color: Color.fromRGBO(54, 75, 94, 1), // Set the background color
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 20),
                                        Text(
                                          "Add a Review",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Set text color to white
                                        ),
                                       SizedBox(height: 20),
                                  TextField(
                                    // Add your logic here to handle review text
                                    cursorColor: Colors.white, // Set cursor color to white
                                    onChanged: (text) {
                                      reviewText = text;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Write your review here",
                                      hintStyle: TextStyle(color:Color.fromRGBO(155, 168, 183, 1)), // Set hint text color to white
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set underline color to white
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // Set underline color to white
                                      ),
                                    ),
                                    style: TextStyle(color: Color.fromRGBO(155, 168, 183, 1)), // Set text color inside the text field
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Rate:",
                                    style: TextStyle(fontSize: 16, color: Colors.white), // Set text color to white
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedRating = index + 1;
                                          });
                                        },
                                        child: Icon(
                                          index < selectedRating ? Icons.star : Icons.star_border,
                                          size: 40,
                                          color: index < selectedRating ? Color.fromRGBO(10, 147, 150, 1) : Colors.white, // Set star color
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      _submitReview('${game["id"]}', game["name"]);
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(10, 147, 150, 1)), // Set background color
                                    ),
                                    child: Text("Submit", style: TextStyle(color: Colors.white)), // Set text color to white
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              title: Text("Add a review", style: TextStyle(color: Colors.white)), // Set text color to white
                              leading: Icon(Icons.rate_review, color: Colors.white), // Set icon color to white
                            ),
                          (!_isGameAdded) ? ListTile(
                              onTap: () {
                                _addGametoList(videoGameId);
                                Navigator.pop(context); // Close the original popup
                              },
                              title: Text("Add to list", style: TextStyle(color: Colors.white)), // Set text color to white
                              leading: Icon(Icons.playlist_add, color: Colors.white), // Set icon color to white
                           ) : ListTile(
                            onTap: () {
                              _removeGameFromList(game["id"]);
                              Navigator.pop(context); // Close the original popup
                            },
                            title: Text("Remove from list", style: TextStyle(color: Colors.white)), // Set text color to white
                            leading: Icon(Icons.playlist_remove, color: Colors.white), // Set icon color to white
                          ),
                          ],
                        ),
                      );
                    },
                );
              },

          



              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.more_horiz_outlined,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(25, 28, 33, 1),
        body: SingleChildScrollView(
          child:
          Stack(
            children: [
              (game != null) ? Container(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.only(bottom: 7),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child:
                                Text(game["name"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30), )
                            )
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: 0.5, color: text_color)
                                ),
                                child:
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child:
                                  Image.network('https:' + game["cover"]["url"].replaceAll('t_thumb','t_cover_big'), scale: 1.7,),
                                )
                            ),
                            const SizedBox(width: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25,),
                                RichText(
                                  text: TextSpan(
                                      text: 'Release date: ',
                                      style: TextStyle(color: text_color),
                                      children: [
                                        TextSpan(
                                          text: DateFormat('MM/dd/yyyy').format(DateTime.fromMillisecondsSinceEpoch(game['first_release_date'] * 1000)),
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ]
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(width: 200, child:
                                RichText(
                                  text: TextSpan(
                                      text: 'Related companies: ',
                                      style: TextStyle(color: text_color),
                                      children: [
                                        TextSpan(
                                          text: companies,
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ]
                                  ),
                                )
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(width: 200, child:
                                RichText(
                                  text: TextSpan(
                                      text: 'Platforms: ',
                                      style: TextStyle(color: text_color),
                                      children: [
                                        TextSpan(
                                          text: platforms,
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ]
                                  ),
                                )
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(width: 200, child:
                                (stats.runtimeType != String) ? RichText(
                                  text: TextSpan(
                                      text: 'Rating: ',
                                      style: TextStyle(color: text_color),
                                      children: [
                                        (stats["rating"] != null) ? TextSpan(
                                          text: '${stats["rating"]} / 5',
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ) :
                                        TextSpan(
                                          text: 'Unrated',
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ]
                                  ),
                                ) : SizedBox()
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5, top: 30),
                          alignment: Alignment.centerLeft,
                          child:
                            Text(
                              'DESCRIPTION',
                              style: TextStyle(
                                fontSize: 12,
                                color: text_color,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                        ),
                        Divider(height: 0, color: Colors.white38,),
                        // Description text body
                        (descLength > 300) ? GestureDetector(
                          onTap: _toggleTextVisibility,
                            child:
                            SizedBox(
                              width: size.width,
                              child: Stack(
                                children:[
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                    child:
                                    Text(
                                      game["summary"],
                                      maxLines: _isTextVisible ? 5 : 100,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  (_isTextVisible) ? Container(
                                    width: size.width,
                                    height: 115,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                      ),
                                    ),
                                  ) : const SizedBox(),
                                  (_isTextVisible) ?
                                  Container(
                                      alignment: Alignment.bottomCenter,
                                      height: 115,
                                      child: Icon(Icons.arrow_drop_down, size: 40, color: text_color, weight: 100,)
                                  ) :
                                  const SizedBox(),
                                ]
                              )
                          ),
                        ) :
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child:
                          Text(
                            game["summary"],
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        (_isTextVisible && descLength > 300) ? Divider(height: 0, color: Colors.white38,) : SizedBox(),
                        Container(
                          padding: EdgeInsets.only(left: 5, top: 40),
                          alignment: Alignment.centerLeft,
                          child:
                          Text(
                            'REVIEWS',
                            style: TextStyle(
                                fontSize: 12,
                                color: text_color,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        Divider(height: 0, color: Colors.white38,),
                        (reviews != null) ? SizedBox(
                          height: 300,
                          child: (reviews.length != 0) ? ListView.builder(
                          itemCount: reviews.length, // Placeholder for number of reviews
                          itemBuilder: (context, index) {
                            var iteratorReview = reviews[index];
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
                                    builder: (context) => ReviewScreen('', iteratorReview["textBody"], iteratorReview["displayName"], iteratorReview["rating"], timeSince)),
                                  );
                                },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white38)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                                color: Color.fromRGBO(10, 147, 150, 1)
                                            );
                                          }),
                                        ),
                                      ),
                                      Align(
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
                          },
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
                          )) : Container(),
                      ]
                  )
              ) : const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    color: Color.fromRGBO(10, 147, 150, 0.5),
                  )
              ) ,
            ],
          ),
        )
    );
  }
}