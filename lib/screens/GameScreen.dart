import 'package:flutter/material.dart';
import 'package:gamegrid/utils/getAPI.dart';
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

  var game;
  void _getGameData(String videoGameId) async {
    var data = await ContentData.fetchGameInfo(videoGameId);
    setState(() {
      game = data;
      built = true;
    });
  }

  int selectedRating = 0; // Initialize selectedRating to 0
  String reviewText = '';
  String response = '';
  bool submitted = false;
  void _submitReview(String videoGameId) async {
    if(submitted) {
      displayReviewNotif("You already submitted a review!");
      return;
    }
    if(selectedRating == 0) {
      displayReviewNotif("Please select a rating");
      return;
    }
    if(reviewText == '') {
      displayReviewNotif("Please write a review");
      return;
    }
    var data = await ContentData.addReview(reviewText, '$selectedRating', videoGameId, GlobalData.displayName);
    setState(() {
      response = data;
      submitted = true;
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
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(Icons.arrow_left, size: 35, color: Colors.white,),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
  context: context,
  builder: (BuildContext context) {

    return AlertDialog(
      backgroundColor: Color.fromRGBO(54, 75, 94, 1), // Set the background color
      title: Text("Choose an action", style: TextStyle(color: Colors.white)), // Set text color to white
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.pop(context); // Close the original popup
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
                        color: index < selectedRating ? Color.fromRGBO(10, 147, 150, 0.5) : Colors.white, // Set star color
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Close the review bottom sheet
                    _submitReview(videoGameId);
                    setState(() {
                      if(submitted) {
                        Navigator.pop(context);
                        displayReviewNotif(response);
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(54, 75, 94, 1)), // Set background color
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
          ListTile(
            onTap: () {
              Navigator.pop(context); // Close the original popup
              // Add your logic here to handle adding to list
            },
            title: Text("Add to list", style: TextStyle(color: Colors.white)), // Set text color to white
            leading: Icon(Icons.playlist_add, color: Colors.white), // Set icon color to white
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
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10),
                            child: Text(game["name"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24), )
                        ),

                        Container(
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

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                          Text(game["summary"], style: TextStyle(color: text_color, fontSize: 14),),
                        ),

                      ]
                  )
              ) : Container(child: Text("Loading", style: TextStyle(color: text_color),)),
            ],
          ),
        )
    );
  }
}