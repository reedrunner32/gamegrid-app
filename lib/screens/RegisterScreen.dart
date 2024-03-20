import 'package:flutter/material.dart';
import 'package:gamegrid/utils/getAPI.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
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
  String message = '';
  String newMessageText = '';
  String displayName = '';
  String email = '';
  String password = '';

  void changeText() {
    setState(() {
      message = newMessageText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
          crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontal
          children: <Widget>[
            Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    child:
                    TextField (
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Display Name',
                      ),
                      onChanged: (text)
                      {
                          displayName = text;
                      },
                    ),
                  ),

                ]
            ),
            Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: 200,
                        child:
                        TextField (
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                            ),
                            onChanged: (text)
                            {
                              email = text;
                            }
                        ),
                      ),
                    ],
                  ),
                ]
            ),
            Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    child:
                    TextField (
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      onChanged: (text)
                      {
                        password = text;
                      },
                    ),
                  ),

                ]
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                  child: Text('Sign up',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                  onPressed: () async
                  {
                    if(displayName == '' || email == '' || password == '') {
                      newMessageText = "*Some fields are empty";
                      changeText();
                    }
                    else {
                      newMessageText = "";
                      changeText();
                      String payload = '{"email":"' + email.trim() + '","password":"' +
                          password.trim() + '","displayName":"' + displayName.trim() + '"}';
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
                        newMessageText = "User added";
                        changeText();
                      }
                    }
                  },

                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('$message',style: TextStyle(fontSize: 14 ,color:Colors.black)),
              ],
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                  child: Text('Go to Login',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                  onPressed: ()
                  {
                    Navigator.pushNamed(context, '/login');
                  },

                )
              ],
            )
          ],
        )
    );
  }
}