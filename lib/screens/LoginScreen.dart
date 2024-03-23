import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:gamegrid/utils/getAPI.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
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

  String message = '', newMessageText = '';
  String email = '', password = '';

  void changeText() {
    setState(() {
      message = newMessageText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
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
                          labelText: 'Email',
                      ),
                    onChanged: (text) {
                      email = text;
                    },
                    ),
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
                          //hintText: 'Enter Your Password'
                      ),
                      onChanged: (text) {
                        password = text;
                      },
                    ),
                  ),
                ]
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                    child: Text('Login',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                    onPressed: () async
                    {
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
                          Navigator.pushNamed(context, '/cards');
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
                  child: Text('Go to Register',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                  onPressed: ()
                  {
                    Navigator.pushNamed(context, '/register');
                  },

                )
              ],
            )
          ],
        )
    );
  }

}
