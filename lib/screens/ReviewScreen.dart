import 'package:flutter/material.dart';
import 'package:gamegrid/utils/getAPI.dart';
import 'ProfileScreen.dart';

class ReviewScreen extends StatefulWidget {
  final String gameName;
  final String textBody;
  final String displayName;
  final int rating;
  final Duration timeSince;

  const ReviewScreen(this.gameName, this.textBody, this.displayName,
      this.rating, this.timeSince, {super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  @override
  Widget build(BuildContext context) {
    Color text_color = Color.fromRGBO(155, 168, 183, 1);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(25, 28, 33, 1),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          (widget.displayName == GlobalData.displayName) ? IconButton(
            onPressed: () {

            },
            style: IconButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.all(2)
            ),
            icon: Icon(
              Icons.more_horiz_outlined,
              size: 35,
              color: Colors.white,
            ),
          ) : SizedBox()
        ],
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
            (widget.gameName != '') ? Text(
              widget.gameName,
              style: TextStyle(
                color: text_color,
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
                    children: List.generate(widget.rating, (index) {
                      return Icon(
                          Icons.star,
                          size: 40,
                          color: Color.fromRGBO(10, 147, 150, 1)
                      );
                    }),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(widget.displayName)),
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
                        widget.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: text_color,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              widget.textBody,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 10,),
            (widget.timeSince.inHours < 1) ? Align(alignment: Alignment.centerRight, child: Text(
              'less than an hour ago',
              style: TextStyle(
                color: Colors.grey,
              )),
            ) : (widget.timeSince.inDays < 1) ?
            Align(alignment: Alignment.centerRight, child: Text(
              '${widget.timeSince.inHours} hours ago',
              style: TextStyle(
                color: Colors.grey,
              )),
            ) : Align(alignment: Alignment.centerRight, child: Text(
              '${widget.timeSince.inDays} days ago',
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