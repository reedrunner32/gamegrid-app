import 'package:flutter/material.dart';

class GameInfo {
  final String name;
  final String imageURL;
  final String description;

  const GameInfo(this.name, this.imageURL, this.description);

}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = ModalRoute.of(context)!.settings.arguments as GameInfo;
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
                    int selectedRating = 0; // Initialize selectedRating to 0

                    return AlertDialog(
                      title: Text("Choose an action"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
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
                                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: 20),
                                                TextField(
                                                  // Add your logic here to handle review text
                                                  decoration: InputDecoration(
                                                    hintText: "Write your review here",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  "Rate:",
                                                  style: TextStyle(fontSize: 16),
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
                                                        color: index < selectedRating ? Colors.orange : Colors.grey,
                                                      ),
                                                    );
                                                  }),
                                                ),
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Close the review bottom sheet
                                                    Navigator.pop(context);
                                                    // Add your logic here to handle the review submission
                                                  },
                                                  child: Text("Submit"),
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
                              child: Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Add a review",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Close the original popup
                                // Add your logic here to handle adding to list
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Add to list",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
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
              Container(
                  child:
                  Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10),
                            child: Text(game.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24), )
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
                              Image.network(game.imageURL, scale: 1.7,),
                            )
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                          Text(game.description, style: TextStyle(color: text_color, fontSize: 14),),
                        ),

                      ]
                  )
              )
            ],
          ),
        )
    );
  }
}