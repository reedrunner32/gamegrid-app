import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:gamegrid/utils/getAPI.dart';
import 'package:gamegrid/screens/GameScreen.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';


class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  Color background_color = Color.fromRGBO(25, 28, 33, 1);
  Color text_color = Color.fromRGBO(155, 168, 183, 1);

  int currentPageIndex = 0;

  int limit = 15;
  int offset = 0;

  final _scrollController = ScrollController();
  final _urlList = <String>[];
  String search = '';

  bool showPopGames = true;

  List<GameInfo> games = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _fetchData();
  }

  Future<void> _fetchData() async {
    String payload = '{"limit":"' + limit.toString() +
        '","offset":"' + offset.toString() + '","genre":"' + '' + '","search":"' + search + '"}';
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
        indicatorColor: Colors.white24,
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
        Container(

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
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            fillColor: Color.fromRGBO(131, 146, 158, 1),
                            labelText: 'Search',
                          ),
                          onChanged: (text) async {
                            search = text;
                            offset = 0;
                            _urlList.clear();
                            games.clear();
                            await _fetchData();
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
                toolbarHeight: 80,
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.black,
                actions: [
                  TextButton(
                    onPressed: () {

                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Icon(Icons.settings, color: text_color, size: 30,)
                  )
                ],
                title:
                Column(
                  children: [
                    Text(GlobalData.displayName, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                  ]
                ),
              ),
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
