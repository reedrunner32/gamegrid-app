import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'dart:convert';
import 'package:gamegrid/utils/getAPI.dart';

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

  ///The controller of sliding up panel
  SlidingUpPanelController panelController = SlidingUpPanelController();
  SlidingUpPanelController panelController2 = SlidingUpPanelController();

  Color background_color = Color.fromRGBO(25, 28, 33, 1);
  Color text_color = Color.fromRGBO(155, 168, 183, 1);

  // Login fields
  String email = '';
  String password = '';

  // Sign up fields
  String emailR = '';
  String usernameR = '';
  String passwordR = '';

  String message = '';
  String newMessageText = '';

  void changeText() {
    setState(() {
      message = newMessageText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        SingleChildScrollView(
        child:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Slideshow
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/2.1,
                  child:
                  Image.asset(
                    'assets/images/helldivers.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2.1 + 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [background_color, Colors.transparent],
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
                height: 97,
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
                  side: BorderSide(color: text_color, width: 0.15),
                ),
                onPressed: ()
                {
                  panelController.expand();
                  //Navigator.pushNamed(context, '/login');
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Sign in',style: TextStyle(fontSize: 17 ,color: text_color, fontWeight: FontWeight.w400),),
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
                    side: BorderSide(color: text_color, width: 0.15),
                  ),
                  onPressed: ()
                  {
                    panelController2.expand();
                    //Navigator.pushNamed(context, '/register');
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Create Account',style: TextStyle(fontSize: 17 ,color: text_color, fontWeight: FontWeight.w400),),
                  )
              ),
            ),
            // Hint text for slideshow
            Container(
              height: MediaQuery.of(context).size.height/5.1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                text: TextSpan(
                  text: 'Artwork from',
                  style: TextStyle(color: text_color, fontSize: 12),
                  children: [
                    TextSpan(
                      text: ' Helldivers 2',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ]
                  ),
                ),
              ),
            ),
          ],
        )
        ),
        SlidingUpPanelWidget(
          controlHeight: 0,
          minimumBound: 0,
          upperBound: 1,
          panelController: panelController,
          onTap: () {

          },
          enableOnTap: true,
          child:
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: background_color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child:
            Column(
              children: [
                Expanded(
                  child:
                  Stack(
                    children: [
                      ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/apex.jpg',
                        height: MediaQuery.of(context).size.height/1.45,
                        fit: BoxFit.fitHeight,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child:
                        TextButton(
                          onPressed: () {
                            panelController.collapse();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child:
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/2.4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [background_color, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.67, 1]
                            ),
                          ),
                            //color: background_color,
                          child:
                            Stack(
                            children: [
                              Positioned(
                                top: 50,
                                left: MediaQuery.of(context).size.width/2 - 40,
                                child:
                                Container(
                                  child:
                                  Image.asset(
                                    'assets/images/controllericon.png',
                                    height: 52,
                                    width: 80,
                                  ),
                                ),
                              ),
                              Positioned(
                                  width: MediaQuery.of(context).size.width,
                                top: 110,
                                  child:
                                  Text(
                                    'Sign in to GameGrid',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
                                  )
                              ),
                              Positioned(
                                top: 150,
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                child:
                                TextField (
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: background_color,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: text_color, width: 0.15),
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ),
                                    labelText: 'Email',
                                  ),
                                  style: TextStyle(
                                    color: text_color,
                                  ),
                                  onChanged: (text)
                                  {
                                    email = text;
                                  },
                                ),
                              ),
                              Positioned(
                                top: 194,
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                child:
                                TextField (
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: background_color,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: text_color, width: 0.15),
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ),
                                    labelText: 'Password',
                                  ),
                                  style: TextStyle(
                                    color: text_color,
                                  ),
                                  obscureText: true,
                                  onChanged: (text)
                                  {
                                    password = text;
                                  },
                                ),
                              ),
                              Positioned(
                                top: 245,
                                width: MediaQuery.of(context).size.width,
                                child:
                                Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(55, 0, 20, 0),
                                    child:
                                    ElevatedButton(
                                      onPressed: () {
                                        panelController.collapse();
                                        panelController2.expand();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        side: BorderSide(color: text_color, width: 0.15),
                                        minimumSize: Size(50, 30),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Color.fromRGBO(71, 84, 100, 1),
                                      ),
                                      child:
                                      Text(
                                        'JOIN',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromRGBO(164, 177, 193, 1),
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1,
                                        ),
                                      )
                                  ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    child:
                                    ElevatedButton(
                                        onPressed: () {

                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          side: BorderSide(color: text_color, width: 0.15),
                                          minimumSize: Size(130, 30),
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Color.fromRGBO(71, 84, 100, 1),
                                        ),
                                        child:
                                        Text(
                                          'RESET PASSWORD',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color.fromRGBO(164, 177, 193, 1),
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 1,
                                          ),
                                        )
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child:
                                    ElevatedButton(
                                      onPressed: () async {
                                        if(email == '' || password == '') {
                                          newMessageText = "*Some fields are empty";
                                          changeText();
                                        }
                                        else {
                                          newMessageText = "";
                                          changeText();
                                          String payload = '{"email":"' + email.trim() +
                                              '","password":"' +
                                              password.trim() + '"}';
                                          var userID;
                                          var jsonObject;
                                          try {
                                            String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/login';
                                            String ret = await CardsData.getJson(url, payload);
                                            jsonObject = json.decode(ret);
                                            userID = jsonObject["id"];
                                          }
                                          catch (e) {
                                            newMessageText = e.toString();
                                            changeText();
                                            return;
                                          }
                                          if (userID == -1) {
                                            newMessageText = "Incorrect Login/Password";
                                            changeText();
                                          }
                                          else {
                                            GlobalData.userID = userID;
                                            GlobalData.displayName = jsonObject["displayName"];
                                            Navigator.pushNamed(context, '/content');
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        side: BorderSide(color: text_color, width: 0.15),
                                        minimumSize: Size(50, 30),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Color.fromRGBO(86, 189, 72, 1),
                                      ),
                                      child:
                                      Text(
                                        'GO',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      )
                                  )
                                  )
                                ],
                              ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child:
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Artwork from',
                                        style: TextStyle(color: text_color, fontSize: 12),
                                        children: [
                                          TextSpan(
                                            text: ' Apex Legends',
                                            style: TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                              )
                            ]
                          )
                        )
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
        SlidingUpPanelWidget(
          controlHeight: 0,
          minimumBound: 0,
          upperBound: 1,
          panelController: panelController2,
          onTap: () {

          },
          enableOnTap: true,
          child:
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: background_color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child:
            Column(
              children: [
                Expanded(
                  child:
                  Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/mw2.jpg',
                            height: MediaQuery.of(context).size.height/1.45,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child:
                          TextButton(
                            onPressed: () {
                              panelController2.collapse();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child:
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/2.1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [background_color, Colors.transparent],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: [0.7, 1]
                                  ),
                                ),
                                //color: background_color,
                                child:
                                Stack(
                                    children: [
                                      Positioned(
                                        top: 50,
                                        left: MediaQuery.of(context).size.width/2 - 40,
                                        child:
                                        Container(
                                          child:
                                          Image.asset(
                                            'assets/images/controllericon.png',
                                            height: 52,
                                            width: 80,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          width: MediaQuery.of(context).size.width,
                                          top: 110,
                                          child:
                                          Text(
                                            'Join GameGrid',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
                                          )
                                      ),
                                      Positioned(
                                        top: 150,
                                        width: MediaQuery.of(context).size.width,
                                        height: 45,
                                        child:
                                        TextField (
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: background_color,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            labelText: 'Email',
                                          ),
                                          style: TextStyle(
                                            color: text_color,
                                          ),
                                          onChanged: (text)
                                          {
                                            emailR = text;
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 194,
                                        width: MediaQuery.of(context).size.width,
                                        height: 45,
                                        child:
                                        TextField (
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: background_color,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            labelText: 'Username',
                                          ),
                                          style: TextStyle(
                                            color: text_color,
                                          ),
                                          onChanged: (text)
                                          {
                                            usernameR = text;
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 238,
                                        width: MediaQuery.of(context).size.width,
                                        height: 45,
                                        child:
                                        TextField (
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: background_color,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            labelText: 'Password',
                                          ),
                                          obscureText: true,
                                          style: TextStyle(
                                            color: text_color,
                                          ),
                                          onChanged: (text)
                                          {
                                            passwordR = text;
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 290,
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(45, 0, 20, 0),
                                              child:
                                              OutlinedButton(
                                                  onPressed: () {
                                                    panelController2.collapse();
                                                    panelController.expand();
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    side: BorderSide(color: text_color, width: 0.15),
                                                    minimumSize: Size(65, 30),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child:
                                                  Text(
                                                    'SIGN IN',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color.fromRGBO(164, 177, 193, 1),
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 1,
                                                    ),
                                                  )
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                              child:
                                              OutlinedButton(
                                                  onPressed: () {

                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    side: BorderSide(color: text_color, width: 0.15),
                                                    minimumSize: Size(130, 30),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child:
                                                  Text(
                                                    'RESET PASSWORD',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color.fromRGBO(164, 177, 193, 1),
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 1,
                                                    ),
                                                  )
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                child:
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      if(usernameR == '' || emailR == '' || passwordR == '') {
                                                        newMessageText = "*Some fields are empty";
                                                        changeText();
                                                      }
                                                      else {
                                                        newMessageText = "";
                                                        changeText();
                                                        String payload = '{"email":"' + emailR.trim() + '","password":"' +
                                                            passwordR.trim() + '","displayName":"' + usernameR.trim() + '"}';
                                                        String error = '';
                                                        var jsonObject;
                                                        try
                                                        {
                                                          String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/register';
                                                          String ret = await CardsData.getJson(url, payload);
                                                          jsonObject = json.decode(ret);
                                                          error = jsonObject["error"];
                                                        }
                                                        catch(e)
                                                        {
                                                          newMessageText = e.toString();
                                                          changeText();
                                                          return;
                                                        }
                                                        if( error == '' )
                                                        {
                                                          newMessageText = "*Please verify your email before logging in";
                                                          changeText();
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                      side: BorderSide(color: text_color, width: 0.15),
                                                      minimumSize: Size(50, 30),
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor: Color.fromRGBO(86, 189, 72, 1),
                                                    ),
                                                    child:
                                                    Text(
                                                      'JOIN',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800,
                                                        letterSpacing: 1,
                                                      ),
                                                    )
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child:
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: RichText(
                                            text: TextSpan(
                                                text: 'Artwork from',
                                                style: TextStyle(color: text_color, fontSize: 12),
                                                children: [
                                                  TextSpan(
                                                    text: ' Modern Warfare 2',
                                                    style: TextStyle(fontWeight: FontWeight.w700),
                                                  ),
                                                ]
                                            ),
                                          ),
                                        ),
                                      )
                                    ]
                                )
                            )
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

}
