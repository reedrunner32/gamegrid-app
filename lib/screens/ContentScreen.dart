import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:gamegrid/utils/getAPI.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  Color background_color = Color.fromRGBO(25, 28, 33, 1);
  Color text_color = Color.fromRGBO(155, 168, 183, 1);

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                    children: [
                      Text('Search', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                      SizedBox(
                        height: 45,
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
                        ),
                      )
                    ]
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
