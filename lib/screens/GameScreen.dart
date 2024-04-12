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
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(Icons.more_horiz_outlined, size: 35, color: Colors.white,),
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