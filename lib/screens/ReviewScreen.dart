import 'package:flutter/material.dart';
import 'package:gamegrid/utils/getAPI.dart';
import 'GameScreen.dart';
import 'ProfileScreen.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';

class ReviewScreen extends StatefulWidget {
  final String reviewId;
  final String gameName;
  final String textBody;
  final String displayName;
  final int rating;
  final Duration timeSince;
  final String videoGameId;

  const ReviewScreen(this.reviewId, this.gameName, this.textBody, this.displayName,
      this.rating, this.timeSince, this.videoGameId, {super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

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

  void _submitEditedReview(String reviewText, int rating, String reviewId) async {
    if(reviewText == '') {
      displayReviewNotif("Please write a review");
      return;
    }
    var data = await ContentData.editReview(reviewText, rating, reviewId);

    setState(() {
      newReview = reviewText;
      newRating = rating;
      _reviewChanged = true;
    });
  }

  void _deleteReview(String reviewId) async {
    var message = await ContentData.deleteReview(reviewId);
  }

  bool _reviewChanged = false;
  String newReview = '';
  int newRating = 0;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController(text: (_reviewChanged) ? newReview : widget.textBody);
    int selectedRating = (_reviewChanged) ? newRating : widget.rating;
    Color text_color = const Color.fromRGBO(155, 168, 183, 1);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(25, 28, 33, 1),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, _reviewChanged);
            },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          (widget.displayName == GlobalData.displayName) ? IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  String reviewText = (_reviewChanged) ? newReview : widget.textBody;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    color: const Color.fromRGBO(54, 75, 94, 1),
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
                                        color: const Color.fromRGBO(54, 75, 94, 1), // Set the background color
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom,
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(height: 20),
                                            const Text(
                                              "Edit review",
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Set text color to white
                                            ),
                                            const SizedBox(height: 20),
                                            TextField(
                                              controller: textEditingController,
                                              cursorColor: Colors.white,
                                              onChanged: (text) {
                                                reviewText = text;
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "Write your review here",
                                                hintStyle: TextStyle(color:Color.fromRGBO(155, 168, 183, 1)), // Set hint text color to white
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // Set underline color to white
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // Set underline color to white
                                                ),
                                              ),
                                              style: const TextStyle(color: Colors.white), // Set text color inside the text field
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
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
                                                    color: index < selectedRating ? const Color.fromRGBO(10, 147, 150, 1) : Colors.white, // Set star color
                                                  ),
                                                );
                                              }),
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                _submitEditedReview(reviewText, selectedRating, widget.reviewId);
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(10, 147, 150, 1)), // Set background color
                                              ),
                                              child: const Text("Submit", style: TextStyle(color: Colors.white)), // Set text color to white
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
                          title: const Text("Edit review", style: TextStyle(color: Colors.white)), // Set text color to white
                          leading: const Icon(Icons.edit_note, color: Colors.white), // Set icon color to white
                        ),
                        ListTile(
                          onTap: () {
                            _deleteReview(widget.reviewId);
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          },
                          title: const Text("Delete review", style: TextStyle(color: Colors.white)), // Set text color to white
                          leading: const Icon(Icons.delete, color: Colors.white), // Set icon color to white
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            style: IconButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(2)
            ),
            icon: const Icon(
              Icons.more_horiz_outlined,
              size: 35,
              color: Colors.white,
            ),
          ) : const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: text_color)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (widget.gameName != '') ? TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(),
                    settings: RouteSettings(
                        arguments: widget.videoGameId
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const RoundedRectangleBorder(),
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                widget.gameName,
                style: TextStyle(
                  color: text_color,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              )
            ) : const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate((_reviewChanged) ? newRating : widget.rating, (index) {
                      return const Icon(
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
                      shape: const RoundedRectangleBorder(),
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
            const SizedBox(height: 8),
            Text(
              (_reviewChanged) ? newReview : widget.textBody,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10,),
            (widget.timeSince.inHours < 1) ? const Align(alignment: Alignment.centerRight, child: Text(
              'less than an hour ago',
              style: TextStyle(
                color: Colors.grey,
              )),
            ) : (widget.timeSince.inDays < 1) ?
            Align(alignment: Alignment.centerRight, child: Text(
              '${widget.timeSince.inHours} hours ago',
              style: const TextStyle(
                color: Colors.grey,
              )),
            ) : Align(alignment: Alignment.centerRight, child: Text(
              '${widget.timeSince.inDays} days ago',
              style: const TextStyle(
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