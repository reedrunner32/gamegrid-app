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
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/helldivers.jpg',
                height: 350,
                fit: BoxFit.fitHeight,
              ),
            ),
            // Main page icon
            Container(
              child:
              Image.asset(
                'assets/images/controllericon.png',
                height: 150,
                width: 150,
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
                  side: BorderSide(color: Color.fromRGBO(155, 168, 183, 1), width: 0.25),
                ),
                onPressed: ()
                {
                  Navigator.pushNamed(context, '/login');
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Sign in',style: TextStyle(fontSize: 17 ,color: Color.fromRGBO(155, 168, 183, 1), fontWeight: FontWeight.w300),),
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
                    side: BorderSide(color: Color.fromRGBO(155, 168, 183, 1), width: 0.25),
                  ),
                  onPressed: ()
                  {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Create Account',style: TextStyle(fontSize: 17 ,color: Color.fromRGBO(155, 168, 183, 1), fontWeight: FontWeight.w300),),
                  )
              ),
            ),
          ],
        )
    );
  }

}
