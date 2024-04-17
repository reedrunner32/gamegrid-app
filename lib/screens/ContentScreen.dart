import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:gamegrid/utils/getAPI.dart';
import 'package:gamegrid/screens/GameScreen.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';


class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  Color background_color = Color.fromRGBO(25, 28, 33, 1);
  Color text_color = Color.fromRGBO(155, 168, 183, 1);
  Color button_color = Color.fromRGBO(10, 147, 150, 0.5);

  SlidingUpPanelController panelController = SlidingUpPanelController();

  int currentPageIndex = 0;

  int limit = 15;
  int offset = 0;

  final _scrollController = ScrollController();
  List<String> _urlList = <String>[];
  String search = '';

  List<GameInfo> games = [];

  /* -----------------------------
  *  Game related API requests
  *
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

  // Add game to user's library (play list)
  Future<void> _addGametoList(int gameId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/addGame';
    String payload = '{"email":"${GlobalData.email}","videoGameId":"$gameId"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    String retErr = decoded['error']; //returning status message
  }

  // Remove game from user's library
  Future<void> _removeGameFromList(int gameId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/user/games/${GlobalData.userID}/$gameId';
    final response = await CardsData.delJson(url);
    var decoded = json.decode(response);
    String retMessage = decoded['message']; //returning status message
  }

  // Fetch info for a specific game
  var gameInfo;
  Future<void> _getGameInfo(String videoGameId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/games/gameName';
    String payload = '{"gameId":"$videoGameId"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    var info = decoded[0];
    setState(() {
      gameInfo = info;
    });
  }

  // Fetch games list from specific user
  var userGameList;
  Future<void> _fetchUserGames(String userId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/user/games/$userId';
    final response = await CardsData.getJsonG(url);
    var decoded = json.decode(response);
    var receivedList = decoded["games"];
    setState(() {
      userGameList = receivedList;
    });
  }


  /* -----------------------------
  *  Friend related API requests
  * ----------------------------- */

  // Fetch user's incoming friend requests
  // id = friendRequests[index]["id"]
  // name = friendRequests[index]["displayName"]
  var friendRequests;
  Future<void> _fetchFriendRequest() async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/received-requests/${GlobalData.userID}';
    final response = await CardsData.getJsonG(url);
    var decoded = json.decode(response);
    var receivedList = decoded["receivedRequests"];
    setState(() {
      friendRequests = receivedList;
    });
  }

  // Send friend request to another user
  Future<void> _sendFriendRequest(String friendId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/send-request';
    String payload = '{"userId":"${GlobalData.userID}","friendId":"$friendId"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    String retErr = decoded['error']; //returning status message
  }

  // Accept friend request from another user
  Future<void> _acceptFriendRequest(String friendId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/accept-request';
    String payload = '{"userId":"${GlobalData.userID}","friendId":"$friendId"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    String retErr = decoded['error']; //returning status message
  }

  // Reject friend request from another user
  Future<void> _rejectFriendRequest(String friendId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/reject-request';
    String payload = '{"userId":"${GlobalData.userID}","friendId":"$friendId"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    String retErr = decoded['error']; //returning status message
  }

  // Fetch all friends info
  // id = friendList[index]["id"]
  // email = friendList[index]["email"]
  // name = friendList[index]["displayName"]
  var friendList;
  Future<void> _fetchFriendList() async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/${GlobalData.userID}';
    final response = await CardsData.getJsonG(url);
    var decoded = json.decode(response);
    var receivedList = decoded["friends"];
    setState(() {
      friendList = receivedList;
    });
  }

  /* -----------------------------
  *  User specific API requests
  * ----------------------------- */

  // Update user display name, or email, or password
  Future<void> _updateUserInfo(String password, String displayName, String email) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/updateuser';
    String payload = '{"email":"${GlobalData.email}","newEmail":"$email","newPassword":"$password","newDisplayName":"$displayName"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    String retErr = decoded['error']; //returning status message
  }

  // Search for a user (returns list of users)
  Future<void> _searchUsers(String displayName) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/searchusers';
    String payload = '{"displayName":"$displayName"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    String retErr = decoded['error']; //returning status message
    String userInfo = decoded['user'];

    // add info handling here
    /*
    "user": {
      "id": "660b375bda67e0e30895a46b",
      "email": "richardzz3233@gmail.com",
      "displayName": "richardzz32",
      "dateCreated": "2024-04-01T22:38:19.338Z",
      "dateLastLoggedIn": null
    },
    * */
  }

  // Delete a user --confirm to prevent accidental calls
  Future<void> _deleteUser(bool confirm) async {
    if(!confirm) return;

    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/deleteuser';
    String payload = '{"id":"${GlobalData.userID}"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);

    String retErr = decoded['error']; //empty if successful
    String userInfo = decoded['successMessage']; //empty if error
  }

  /* -----------------------------
  *         REVIEWS APIs
  *
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

  // Update user display name, or email, or password
  Future<void> _addReview(String textBody, String rating, String videoGameId, String displayName) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/updateuser';
    String payload = '{"textBody":"$textBody","rating":"$rating","videoGameId":"$videoGameId","displayName":"$displayName"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    String retErr = decoded['error']; //returning status message
  }

  // Fetch reviews for an individual user
  var reviewsList;
  Future<void> _fetchUserReviews(String displayName) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/reviews/search/$displayName';
    final response = await CardsData.getJsonG(url);
    var decoded = json.decode(response);
    var receivedList = decoded["reviews"];
    setState(() {
      reviewsList = receivedList;
    });
  }

  // Fetches most recent reviews (default = 10; set pageSize for different amount)
  var recentReviewsList;
  Future<void> _fetchRecentReviews(int pageSize) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/getRecentReviews';
    String payload = '{"pageSize":"$pageSize"}';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    var receivedList = decoded['recentReviews'];
    setState(() {
      recentReviewsList = receivedList;
    });
  }


  // FOR TESTING PURPOSES
  void printDebug(String str) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: 200,
                  child: Text(str, style: TextStyle(fontSize: 24))),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("POP")
              )
            ]
        );
      });
  }

  Widget SettingsPage() {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height*0.95,
        decoration: BoxDecoration(
          color: Color.fromRGBO(54, 75, 94, 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text("Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),),
                automaticallyImplyLeading: false,
                leadingWidth: 100,
                leading: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text("Cancel", style: TextStyle(color: text_color, fontSize: 18, fontWeight: FontWeight.w400),),
                ),
                actions: [
                  TextButton(
                      onPressed: () {

                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      child: SizedBox(width: 50, child: Text("Save", style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.w800),),)
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                ),
                padding: EdgeInsets.only(left: 10, top: 16),
                width: size.width,
                height: 50,
                child: RichText(
                  text: TextSpan(
                      text: 'Signed in as ',
                      style: TextStyle(color: text_color, fontSize: 18),
                      children: [
                        TextSpan(
                          text: GlobalData.displayName,
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ]
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.black, width: 0.5))
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10, top: 45),
                height: 70,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))
                ),
                child: Text(
                  'PROFILE',
                  style: TextStyle(
                    color: text_color,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(

                ),
                padding: EdgeInsets.only(left: 10, top: 16),
                width: size.width,
                height: 50,
                child: TextField(
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: text_color, decoration: TextDecoration.none),
                  cursorColor: text_color,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: text_color),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _fetchData() async {
    String payload = '{"limit":"$limit","offset":"$offset","genre":"","search":"$search"}';
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/games';
    final response = await CardsData.getJson(url, payload);
    var decoded = json.decode(response);
    List<String> tempUrl = <String>[];
    List<GameInfo> tempGames = [];
    for(int i = 0; i<limit; i++){
      String formattedUrl = 'https:' + decoded[i]['cover']['url'].replaceAll('t_thumb','t_cover_big');
      tempUrl.add(formattedUrl);
      tempGames.add(GameInfo(decoded[i]['name'], formattedUrl, decoded[i]['summary']));
    }
    setState(() {
      games.addAll(tempGames);
      _urlList.addAll(tempUrl);
      offset += limit;
    });
  }

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background_color,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentPageIndex,
        indicatorColor: button_color,
        backgroundColor: Color.fromRGBO(54, 75, 94, 1),
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.videogame_asset, color: text_color, size: 30,),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search, color: text_color, size: 30,),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: text_color, size: 30,),
            label: 'Search',
          ),
        ],
      ),
      body: <Widget>[
        ///  page
       DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          //const Text('GameGrid',style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white),),
          SizedBox(width: 8),
          Container(
            child: Center(
            child: Image.asset('assets/images/controllericon.png',scale: 10,),
            ),
          ),
            ],
          ),
          //centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            splashFactory: NoSplash.splashFactory,
            tabs: <Widget>[
               Tab(
                child: Text(
                  'New Releases',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
              ),
              Tab(
                child: Text(
                  'Recent Reviews',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
              ),
            ],
            dividerColor: Color.fromRGBO(25, 28, 33, 1),
          ),
        ),
     body: TabBarView(
  children: <Widget>[
    // New content for new releases page
    Container(
      color: Color.fromRGBO(25, 28, 33, 1),
      child: GridView.builder(
        itemCount: 15, // Placeholder for number of new release games
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 2 / 3, // Aspect ratio for each game placeholder
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120, // Placeholder height for game cover image
                  color: Colors.grey[700],
                ),
                SizedBox(height: 8),
                Text(
                  'Game Title $index', // Placeholder game title
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Release Date', // Placeholder release date
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    // Previous content for recent reviews page
    Container(
      color: Color.fromRGBO(25, 28, 33, 1),
      child: ListView.builder(
        itemCount: 5, // Placeholder for number of reviews
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User $index', // Placeholder username
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '2 hours ago', // Placeholder timestamp
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This is a placeholder review text.', // Placeholder review text
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                // Add more elements for additional info like ratings, likes, etc.
              ],
            ),
          );
        },
      ),
    ),
  ],
),
      ),
       ),

        /// Search page
        Container(
          child: Column(
            children: [
              AppBar(
                toolbarHeight: 100,
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.black,
                title:
                Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Search', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                      SizedBox(
                        height: 35,
                        child:
                        TextField(
                          style: TextStyle(fontSize: 16, color: text_color, decoration: TextDecoration.none),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                            ),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.transparent, )
                            ),
                            fillColor: Color.fromRGBO(131, 146, 158, 1),
                            labelText: 'Search',
                            prefixIcon: Icon(Icons.search, size: 20,),
                          ),
                          onChanged: (text) {
                            search = text;
                            offset = 0;
                            _urlList.clear();
                            games.clear();
                            _fetchData();
                          },
                        ),
                      )
                    ]
                ),
              ),
              Expanded(
                child:
                GridView.builder(
                  controller: _scrollController,
                  itemCount: _urlList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 5, childAspectRatio: 0.8),
                  itemBuilder: (BuildContext context, int index) {
                    return
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameScreen(),
                            settings: RouteSettings(
                              arguments: games[index],
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
                        child: Image.network(_urlList[index])
                      )
                    );

                  },
                ),
              ),
            ],
          ),
        ),

        /// Profile page
  Container(
  child: Column(
    children: [
      AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                      return SettingsPage();
                  });
                }
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: Icon(Icons.settings, color: text_color, size: 30,)
          )
        ],
        leading: GestureDetector(
          onTap: () {
            // Add your notifications icon onPressed functionality here
            // Navigate to the notification page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the previous page
                    },
                  ),
                  title: Text('Notifications'),
                  backgroundColor: Colors.black,
                ),
                body: Center(
                  child: Text(
                    'Notification Page Content',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )),
            );
          },
          child: Icon(Icons.notifications, color: text_color, size: 30,),
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              // Add your settings button onPressed functionality here
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: Icon(Icons.settings, color: text_color, size: 30,)
          ),
        ],
        title: Column(
          children: [
            Text(GlobalData.displayName, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
          ]
        ),
      ),
      ListTile(
        leading: Icon(Icons.rate_review),
        title: Text('Your Activity'),
        onTap: () {
          // Navigate to your activity page
          // Updated to display review activity placeholders
          Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Your Review Activity'),
              backgroundColor: Colors.black,
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text('Review 1'),
                  subtitle: Text('Details of review 1'),
                ),
                Divider(height: 0), // Adding a border
                ListTile(
                  title: Text('Review 2'),
                  subtitle: Text('Details of review 2'),
                ),
                Divider(height: 0), // Adding a border
                // Add more review placeholders as needed
              ],
            ),
          )));
        },
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text('Friends'),
        onTap: () {
          // Navigate to friends page
          // Updated to display a vertical list of friends
          Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Friends'),
              backgroundColor: Colors.black,
            ),
            body: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Friend 1'),
                ),
                Divider(height: 0), // Adding a border
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Friend 2'),
                ),
                Divider(height: 0), // Adding a border
                // Add more friend placeholders as needed
              ],
            ),
          )));
        },
      ),
      ListTile(
        leading: Icon(Icons.games),
        title: Text('Game List'),
        onTap: () {
          // Navigate to game list page
          // Updated to display a grid view of games
          Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Game List'),
              backgroundColor: Colors.black,
            ),
            body: GridView.count(
              crossAxisCount: 2, // Number of columns in the grid
              children: [
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.gamepad, size: 50),
                      SizedBox(height: 10),
                      Text('Game 1'),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.gamepad, size: 50),
                      SizedBox(height: 10),
                      Text('Game 2'),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.gamepad, size: 50),
                      SizedBox(height: 10),
                      Text('Game 3'),
                    ],
                  ),
                ),
                // Add more placeholders for additional games
              ],
            ),
          )));
        },
      ),
      // Add more buttons as needed
    ],
  ),
),
      ][currentPageIndex],
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }


}