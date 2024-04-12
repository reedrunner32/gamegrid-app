import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:gamegrid/utils/getAPI.dart';
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
  final _list = <String>[];
  String search = '';

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
    List<String> temp = <String>[];
    for(int i = 0; i<limit; i++){
      temp.add('https:' + decoded[i]['cover']['url'].replaceAll('t_thumb','t_cover_big'));
    }
    setState(() {
      _list.addAll(temp);
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
                  'Home',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
              ),
              Tab(
                child: Text(
                  'Activity',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
              ),
            ],
            dividerColor: Color.fromRGBO(25, 28, 33, 1),
          ),
        ),
       
        body: TabBarView(
          children: <Widget>[


            
            Container(
              color: Color.fromRGBO(25, 28, 33, 1),
              child: Text('Home Page',style: TextStyle(fontWeight: FontWeight.w800, color:  Colors.white),),
            ),
            Container(
              color: Color.fromRGBO(25, 28, 33, 1),
              child: Text('Activity Page',style: TextStyle(fontWeight: FontWeight.w800, color:  Colors.white),),
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
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            fillColor: Color.fromRGBO(131, 146, 158, 1),
                            labelText: 'Search',
                          ),
                          onChanged: (text) {
                            search = text;
                            offset = 0;
                            _list.clear();
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
                  itemCount: _list.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 5, childAspectRatio: 0.8),

                  itemBuilder: (BuildContext context, int index) {
                    return
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(_list[index])
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
