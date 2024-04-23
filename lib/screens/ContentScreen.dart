import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gamegrid/screens/FriendScreen.dart';
import 'package:gamegrid/screens/GameListScreen.dart';
import 'package:gamegrid/screens/UserReviewsScreen.dart';
import 'package:gamegrid/utils/getAPI.dart';
import 'package:gamegrid/screens/GameScreen.dart';
import 'package:gamegrid/screens/ReviewScreen.dart';
import 'package:gamegrid/screens/ProfileScreen.dart';
import 'package:gamegrid/screens/NotificationScreen.dart';
import 'package:gamegrid/components/Debouncer.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';


class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  Color background_color = Color.fromRGBO(25, 28, 33, 1);
  Color text_color = Color.fromRGBO(155, 168, 183, 1);
  Color button_color = Color.fromRGBO(10, 147, 150, 1);

  final _debouncer = Debouncer(milliseconds: 300);

  int currentPageIndex = 0;

  final _scrollController = ScrollController();
  String search = '';
  
  String addFriendTextField = '';
  List<GameCard> games = [];

  void displayNotif(String message) {
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

    void displayError(String message) {
      ElegantNotification.error(
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

  void _changePassword(String newPassword) async {
    String message = await ContentData.changeUserPassword(newPassword);
    displayNotif("Password changed");
  }

  Widget SettingsPage() {
    Size size = MediaQuery.of(context).size;
    String currentPassword = '';
    String newPassword = '';
    String confirmPassword = '';
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
                actions: [
                  IconButton(
                    icon: Icon(Icons.close_outlined, color: Colors.white70, size: 30,),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
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
                    Navigator.pushReplacementNamed(context, '/home');
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
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))
                  ),
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
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.zero,
                              color: Color.fromRGBO(54, 75, 94, 1),
                              child: Text(
                                GlobalData.displayName,
                                style: TextStyle(
                                  color: text_color,
                                  fontSize: 18,
                                ),
                              ),
                            )
                        ),
                      ]
                  )
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))
                  ),
                  height: 50,
                  child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.zero,
                              color: Color.fromRGBO(54, 75, 94, 1),
                              child: Text(
                                "Email",
                                style: TextStyle(
                                  color: text_color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            )
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.zero,
                              color: Color.fromRGBO(54, 75, 94, 1),
                              child: Text(
                                GlobalData.email,
                                style: TextStyle(
                                  color: text_color,
                                  fontSize: 18,
                                ),
                              ),
                            )
                        ),
                      ]
                  )
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))
                  ),
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: background_color,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height*0.85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromRGBO(54, 75, 94, 1),
                            ),
                            child: Column(
                              children: [
                                AppBar(
                                  backgroundColor: Colors.transparent,
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
                                          if(currentPassword != GlobalData.password) {
                                            displayError("Current password is wrong!");
                                            return;
                                          }
                                          if(newPassword.length < 8 && !newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                            displayError('Password must be at least 8 characters long and contain a special character');
                                            return;
                                          }
                                          if (newPassword.length < 8) {
                                            displayError('Password must be at least 8 characters long');
                                            return;
                                          }
                                          if (!newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                            displayError('Password must contain at least one special character');
                                            return;
                                          }
                                          if(newPassword != confirmPassword) {
                                            displayError("Passwords do not match!");
                                            return;
                                          }
                                          if(newPassword == GlobalData.password) {
                                            displayError("New password cannot be the current password!");
                                            return;
                                          }
                                          _changePassword(newPassword);
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: SizedBox(width: 50, child: Text("Save", style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.w800),),)
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 2),
                                  child: Text(
                                    'CHANGE PASSWORD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  height: 45,
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.black, width: 0.5), top: BorderSide(color: Colors.black, width: 0.5))
                                  ),
                                  child:
                                    TextField(
                                  onChanged: (text) {
                                    currentPassword = text;
                                  },
                                      obscureText: true,
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    border: InputBorder.none,
                                    labelText: 'Current Password',
                                    labelStyle: TextStyle(
                                      color: text_color,
                                      fontSize: 18,
                                    ),
                                  ),
                                  cursorColor: Colors.white,
                                ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  height: 45,
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))
                                  ),
                                  child:
                                  TextField(
                                    onChanged: (text) {
                                      newPassword = text;
                                    },
                                    obscureText: true,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      border: InputBorder.none,
                                      labelText: 'New Password',
                                      labelStyle: TextStyle(
                                        color: text_color,
                                        fontSize: 18,
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  height: 45,
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))
                                  ),
                                  child:
                                  TextField(
                                    onChanged: (text) {
                                      confirmPassword = text;
                                    },
                                    obscureText: true,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      border: InputBorder.none,
                                      labelText: 'Confirm Password',
                                      labelStyle: TextStyle(
                                        color: text_color,
                                        fontSize: 18,
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, top: 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Password must meet these requirements: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                ListTile(
                                  leading: Icon(Icons.circle, size: 10, color: text_color,), // You can use any icon here
                                  title: Text('At least 8 characters in length', style: TextStyle(
                                    color: text_color,
                                    fontSize: 16,
                                  ),),
                                ),
                                ListTile(
                                  leading: Icon(Icons.circle, size: 10, color: text_color,), // You can use any icon here
                                  title: Text('At least 1 special character', style: TextStyle(
                                    color: text_color,
                                    fontSize: 16,
                                  ),),
                                ),
                              ],
                            ),
                          );
                        });
                    },
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        color: text_color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10, top: 45),
                height: 70,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))
                ),
                child: Text(
                  'OTHER',
                  style: TextStyle(
                    color: text_color,
                    fontSize: 14,
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: background_color,
                        title: Text("Delete Account"),
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        shape: RoundedRectangleBorder(),
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5),
                              child: Text(
                                "Are you sure you want to delete your account?",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteAccount(true);
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                    ElegantNotification.success(
                                      width: 360,
                                      toastDuration: const Duration(
                                          milliseconds: 2500),
                                      position: Alignment.topCenter,
                                      animation: AnimationType.fromTop,
                                      description: Text("Account Deleted"),
                                      shadow: BoxShadow(
                                        color: Colors.blue.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ).show(context);
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }
                    );
                  },
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 0, 0, 1),
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  void _deleteAccount(bool confirm) async {
    var message = await ContentData.deleteUser(confirm);
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
  bool searchLoaded = false;

  Future<void> _fetchData() async {
    List<GameCard> gameList = await ContentData.fetchGameCards(curLimit, curOffset, curSearch);
    setState(() {
      curGameList.addAll(gameList);
      curOffset += curLimit;
      searchLoaded = true;
    });
  }

  List<GameCardRelease> newReleases = [];
  Future<void> _getNewReleases() async {
    List<GameCardRelease> temp = await ContentData.fetchNewReleaseGameCards(15, 0);
    setState(() {
      newReleases.addAll(temp);
    });
  }

  var recentReview;
  Future<void> _getRecentReviews() async {
    Future.delayed(const Duration(seconds: 2));
    var data = await ContentData.fetchRecentReviews(10);
    if(data == null) return;
    setState(() {
      recentReview = data;
    });
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
    _getRecentReviews();
    _getNewReleases();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
        canPop: false,
        child:
      Scaffold(
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
        indicatorColor: Color.fromRGBO(10, 147, 150, 0.5),
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Color.fromRGBO(54, 75, 94, 1),
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.videogame_asset, color: text_color, size: 30,),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search, color: text_color, size: 30,),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: text_color, size: 30,),
            label: 'Profile',
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
          title: Image.asset('assets/images/controllericon.png',scale: 10,),
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            splashFactory: NoSplash.splashFactory,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color.fromRGBO(10, 147, 150, 1), width: 2.0),
              ),
            ),
            tabs: <Widget>[
               Tab(
                child: Text(
                  'New Releases',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1), // Set text color
                ),
              ),
              Tab(
                child: Text(
                  'Recent Reviews',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1), // Set text color
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
        itemCount: newReleases.length, // Placeholder for number of new release games
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 1.6 / 3, // Aspect ratio for each game placeholder
        ),
        itemBuilder: (BuildContext context, int index) {
          GameCardRelease iteratorGame = newReleases[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(),
                    settings: RouteSettings(
                        arguments: iteratorGame.gameId
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
              child: Column(
              children: [
                Container(
                  height: 150, // Placeholder height for game cover image
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(iteratorGame.imageURL,),
                  )
                ),
                SizedBox(height: 3),
                Text(
                  iteratorGame.gameName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Release Date: ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  iteratorGame.releaseDate,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
          );
        },
      ),
    ),
    // Previous content for recent reviews page
    RefreshIndicator(
      onRefresh: _getRecentReviews,
      child:
      Container(
        color: Color.fromRGBO(25, 28, 33, 1),
        child: (recentReview != null) ? ListView.builder(
          itemCount: recentReview.length, // Placeholder for number of reviews
          itemBuilder: (context, index) {
            var iteratorReview = recentReview[index];
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
                      builder: (context) => ReviewScreen(iteratorReview["_id"], iteratorReview["videoGameName"], iteratorReview["textBody"], iteratorReview["displayName"], iteratorReview["rating"], timeSince, iteratorReview["videoGameId"])),
                  ).then((refresh) {
                    if(refresh) {
                      setState(() {
                        recentReview = null;
                        _getRecentReviews();
                      });
                    }
                  });
                },
                child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: text_color)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                          settings: RouteSettings(
                              arguments: iteratorReview["videoGameId"]
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Text(
                      iteratorReview["videoGameName"],
                      style: TextStyle(
                        color: text_color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                                color: button_color
                              );
                          }),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(iteratorReview["displayName"])),
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
                            iteratorReview["displayName"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: text_color,
                              fontSize: 16,
                            ),
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
                  SizedBox(height: 6),
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
        ) : const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              color: Color.fromRGBO(10, 147, 150, 0.5),
            )
        ),
      ),
    )
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
                    children: [
                      Text('Search', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                      Container(
                        height: 35,
                        child:
                        TextField(
                          style: TextStyle(fontSize: 16, color: Colors.black87, decoration: TextDecoration.none),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                            ),
                            focusColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.transparent, )
                            ),
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
                              setState(() {
                                searchLoaded = false;
                              });
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
              (searchLoaded) ? Expanded(
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
              ) : Container(
                height: 100,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    strokeWidth: 6,
                    color: Color.fromRGBO(10, 147, 150, 0.5),
                  )
              ),
            ],
          ),
        ),

        /// Profile page
Scaffold(
  backgroundColor: Color.fromRGBO(25, 28, 33, 1),
  appBar: AppBar(
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
        child: Icon(Icons.settings, color: Colors.white, size: 30,)
      )
    ],
    leading: GestureDetector(
      onTap: () {
        // Add your notifications icon onPressed functionality here
        // Navigate to the notification page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
      },
      child: Icon(Icons.notifications, color: Colors.white, size: 30,),
    ),
    title: Column(
      children: [
        Text(GlobalData.displayName, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
      ]
    ),
  ),
  body: ListView(
    children: [
      SizedBox(height: 15),
      Center(
        child: Icon(
          Icons.person_outline,
          size: 100,
          color: Colors.grey[300],
        ),
      ),
      SizedBox(height: 5),
      Divider(color: Colors.black26, height: 0,),
      ListTile(
        leading: Icon(Icons.people, color: Colors.white),
        title: Padding(padding: EdgeInsets.only(left: 5), child:
        Text('Friends', style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),),),
        onTap: () {
          // Display friends list on a new page
          Navigator.push(context, MaterialPageRoute(builder: (context) => FriendScreen(GlobalData.userID)));
        },
      ),
      Divider(color: Colors.black26, height: 0,),
      ListTile(
        leading: Icon(Icons.rate_review, color: Colors.white), // Set icon color to white
        title: Padding(padding: EdgeInsets.only(left: 5), child:
        Text('Your Activity', style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),),), // Set text color to white
        onTap: () {
          // Navigate to your activity page
          // Updated to display review activity placeholders
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserReviewsScreen(GlobalData.displayName)));
        },
      ),
      Divider(color: Colors.black26, height: 0,),
      ListTile(
        leading: Icon(Icons.games, color: Colors.white), // Set icon color to white
        title: Padding(padding: EdgeInsets.only(left: 5), child:
        Text('Game List', style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),),), // Set text color to
        onTap: () {
          // Navigate to game list page
          // Updated to display a grid view of games
          Navigator.push(context, MaterialPageRoute(builder: (context) => GameListScreen(GlobalData.userID)));
        },
      ),
      Divider(color: Colors.black26, height: 0,),
      SizedBox(height: 35), // Add space between app bar and icon
      TextButton(
        onPressed: () async {

        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          splashFactory: NoSplash.splashFactory,
        ),
        child: Image.asset('assets/images/Capture21ad.PNG', height: 190),
      ),
      Container(
        padding: EdgeInsets.only(top: 3),
        alignment: Alignment.center,
        child: Text(
          'Advertisment',
          style: TextStyle(
            color: text_color,
            fontSize: 12,
          ),
        ),
      )
    ],
    // Add more buttons as needed
  ),
),

      ][currentPageIndex],
    ));
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