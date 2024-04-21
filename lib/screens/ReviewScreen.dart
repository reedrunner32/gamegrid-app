import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final String gameName;
  final String textBody;
  final String displayName;
  final int rating;
  final Duration timeSince;

  const ReviewScreen(this.gameName, this.textBody, this.displayName, this.rating, this.timeSince, {super.key});

  @override
  Widget build(BuildContext context) {
    Color text_color = Color.fromRGBO(155, 168, 183, 1);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(25, 28, 33, 1),
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: text_color)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (gameName != '') ? Text(
              gameName,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ) : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(rating, (index) {
                      return Icon(
                          Icons.star,
                          size: 40,
                          color: Color.fromRGBO(10, 147, 150, 0.5)
                      );
                    }),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: text_color,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              textBody,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 10,),
            (timeSince.inHours < 1) ? Align(alignment: Alignment.centerRight, child: Text(
              'less than an hour ago',
              style: TextStyle(
                color: Colors.grey,
              )),
            ) : (timeSince.inDays < 1) ?
            Align(alignment: Alignment.centerRight, child: Text(
              '${timeSince.inHours} hours ago',
              style: TextStyle(
                color: Colors.grey,
              )),
            ) : Align(alignment: Alignment.centerRight, child: Text(
              '${timeSince.inDays} days ago',
              style: TextStyle(
                color: Colors.grey,
              ),
            ))
          ],
        ),
      ),
    )
    );
  }
}