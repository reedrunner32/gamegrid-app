import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:gamegrid/utils/getAPI.dart';
import 'package:gamegrid/screens/GameScreen.dart';
import 'package:gamegrid/components/Debouncer.dart';
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
  final _debouncer = Debouncer(milliseconds: 200);

  int currentPageIndex = 0;

  final _scrollController = ScrollController();
  String search = '';
  
  String displayName = '';
  List<GameCard> games = [];

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

  // Settings page variables
  String changeDisplayName = '';
  String changeEmail = '';
  String changePassword = '';

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
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width,
                height: 50,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.zero,
                        color: Color.fromRGBO(54, 75, 94, 1),
                        child: Text(
                          "Username",
                          style: TextStyle(
                            color: text_color,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ),
                    TextField(
                      onChanged: (text) {
                        changeDisplayName = text;
                      },
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: text_color, decoration: TextDecoration.none, fontSize: 18),
                      cursorColor: text_color,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: text_color),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                        ),
                      ),
                    ),
                  ]
                )
              ),
            ],
          ),
        )
    );
  }

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  int curLimit = 15;
  int curOffset = 0;
  String curSearch = '';
  List<GameCard> curGameList = [];

  void _fetchData() async {
    List<GameCard> gameList = await ContentData.fetchGameCards(curLimit, curOffset, curSearch);
    setState(() {
      curGameList.addAll(gameList);
      curOffset += curLimit;
    });
  }

  void _friendRequest() async{
    var userData = await ContentData.searchUsers(displayName);
    String friendId = userData["id"];
    String retMessage = await ContentData.sendFriendRequest(friendId); //return message
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
                            _debouncer.run(() {
                              curSearch = text;
                              curOffset = 0;
                              curGameList.clear();
                              _fetchData();
                            });
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
                  itemCount: curGameList.length,
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
                              arguments: curGameList[index].gameId
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
                        child: Image.network(curGameList[index].imageURL)
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
                      // API integration for settings page
                      return SettingsPage();
                    },
                  );
                },
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
        title: Column(
          children: [
            Text(GlobalData.displayName, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
          ]
        ),
      ),
      ListTile(
        leading: Icon(Icons.people, color: Colors.white), // Set icon color to white
        title: Text('Friends', style: TextStyle(color: Colors.white)), // Set text color to white
        trailing: IconButton(
           icon: Icon(Icons.add, color: Colors.white), // Set icon color to white
          onPressed: () {
            showDialog(
  context: context,
  builder: (BuildContext context) {
    // Variable to hold the entered display name
    return AlertDialog(
      backgroundColor: Color.fromRGBO(54, 75, 94, 1), // Set background color
      title: Text('Send Friend Request', style: TextStyle(color: Colors.white)), // Set text color to white
      content: TextField(
        onChanged: (value) {
          displayName = value; // Update the display name as it's typed
        },
        decoration: InputDecoration(
          hintText: 'Enter display name',
          hintStyle: TextStyle(color: Color.fromRGBO(155, 168, 183, 1)), // Set hint text color to white
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Set underline color to white
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Set focused underline color to white
          ),
        ),
        cursorColor: Colors.white, // Set cursor color to white
        style: TextStyle(color: Color.fromRGBO(155, 168, 183, 1)), // Set text color to white
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)), // Set text color to white
        ),
        TextButton(
          onPressed: () {
            _friendRequest();
            Navigator.of(context).pop();
          },
          child: Text('Send', style: TextStyle(color: Colors.white)), // Set text color to white
                    ),
                  ],
                );
              },
            );
          },
        ),
        onTap: () {
          // Display friends list on a new page
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
        leading: Icon(Icons.rate_review, color: Colors.white), // Set icon color to white
        title: Text('Your Activity', style: TextStyle(color: Colors.white)), // Set text color to white
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
         leading: Icon(Icons.games, color: Colors.white), // Set icon color to white
        title: Text('Game List', style: TextStyle(color: Colors.white)), // Set text color to
        onTap: () {
          // Navigate to game list page
          // Updated to display a grid view of games
          Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Game List'),
              backgroundColor: Colors.black,
            ),
            body: GridView.count(
              crossAxisCount: 3, // Number of columns in the grid
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              children: [
                Image.network(
                  'https://images.igdb.com/igdb/image/upload/t_cover_big/co741o.jpg', // URL of the image
                  fit: BoxFit.cover, // Adjust the image to cover the whole space
                ),
                // Add more images for additional games
              ],
            ),
          ))); 
        },
      ),
    ],
      // Add more buttons as needed
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