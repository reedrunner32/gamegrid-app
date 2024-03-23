import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(25, 28, 33, 1),
      body: MainPage(),
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
        child:
        Column(
          children: [
            // Slideshow
            Stack(
              children: [
                Image.asset(
                  'assets/images/helldivers.jpg',
                  height: MediaQuery.of(context).size.height/2.2,
                  fit: BoxFit.fitHeight,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2.2 + 1,
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                  colors: [Color.fromRGBO(25, 28, 33, 1), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  ),
                  ),
                ),
              ],
            ),
            // Main page icon
            Container(
              child:
              Image.asset(
                'assets/images/controllericon.png',
                height: 130,
                width: 180,
              ),
            ),
            // TITLE
            Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child:
              Text(
                  'GameGrid',
                  style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.w900),
              )
            ),
            // Sign in button
            Container(
              width: MediaQuery.of(context).size.width,
              child:
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  side: BorderSide(color: Color.fromRGBO(155, 168, 183, 1), width: 0.15),
                ),
                onPressed: ()
                {
                  Navigator.pushNamed(context, '/login');
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Sign in',style: TextStyle(fontSize: 17 ,color: Color.fromRGBO(155, 168, 183, 1), fontWeight: FontWeight.w400),),
                )
              ),
            ),
            // Register account button
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(0),
              child:
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    side: BorderSide(color: Color.fromRGBO(155, 168, 183, 1), width: 0.15),
                  ),
                  onPressed: ()
                  {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Create Account',style: TextStyle(fontSize: 17 ,color: Color.fromRGBO(155, 168, 183, 1), fontWeight: FontWeight.w400),),
                  )
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset(0.5, 0.9),
                child: RichText(
                text: TextSpan(
                  text: 'Artwork from',
                  style: TextStyle(color: Color.fromRGBO(155, 168, 183, 1), fontSize: 12),
                  children: [
                    TextSpan(
                      text: ' Helldivers 2',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ]
                ),
              ),
            ),)
          ],
        )
    );
  }

}
