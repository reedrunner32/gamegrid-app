import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'dart:convert';
import 'package:gamegrid/utils/getAPI.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      backgroundColor: const Color.fromRGBO(25, 28, 33, 1),
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{

  ///The controller of sliding up panel
  SlidingUpPanelController panelController = SlidingUpPanelController();
  SlidingUpPanelController panelController2 = SlidingUpPanelController();

  Color background_color = const Color.fromRGBO(25, 28, 33, 1);
  Color text_color = const Color.fromRGBO(155, 168, 183, 1);

  // Login fields
  String email = '';
  String password = '';

  // Sign up fields
  String emailR = '';
  String usernameR = '';
  String passwordR = '';

  void displayResetPassword() {
    ElegantNotification.info(
      width: 360,
      stackedOptions: StackedOptions(
        key: 'top',
        type: StackedType.same,
        itemOffset: const Offset(-5, -5),
      ),
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      title: const Text('Reset Password'),
      description: const Text('Check your email for instructions'),
      shadow: BoxShadow(
        color: Colors.blue.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 4), // changes position of shadow
      ),
    ).show(context);
  }

  void displayLoginError(String err) {
    ElegantNotification.error(
      width: 360,
      stackedOptions: StackedOptions(
        key: 'top',
        type: StackedType.same,
        itemOffset: const Offset(-5, -5),
      ),
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      title: const Text('Error'),
      description: Text(err),
      shadow: BoxShadow(
        color: Colors.red.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 4), // changes position of shadow
      ),
    ).show(context);
  }

  void _doLogin() async {
    if(email == '') {
      displayLoginError("Please enter an Email.");
      return;
    }
    if (!email.contains('@')) {
      displayLoginError("Please enter a valid Email.");
      return;
    }
    else {
      String payload = '{"email":"$email"}';
      var jsonObject;
      try {
        String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/forgot-password';
        var ret = await CardsData.postJson(url, payload);
        jsonObject = ret;
      }
      catch (e) {
        displayLoginError("Could not reset password");
        return;
      }
      if(jsonObject.statusCode == 200) {
        displayResetPassword();
      }
      else if(jsonObject.statusCode == 404) {
        displayLoginError("User not found");
      }
      else {
        displayLoginError("Could not reset password");
      }
    }
  }

  void _doRegister() async {
    if(emailR == '') {
      displayLoginError("Please enter an Email.");
      return;
    }
    if(usernameR == '') {
      displayLoginError("Please enter a Username.");
      return;
    }
    if(passwordR == '') {
      displayLoginError("Please enter a Password.");
      return;
    }
    if (!emailR.contains('@')) {
      displayLoginError("Please enter a valid Email.");
      return;
    }
    if(passwordR.length < 8 && !passwordR.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      displayLoginError('Password must be at least 8 characters long and contain a special character');
      return;
    }
    if (passwordR.length < 8) {
      displayLoginError('Password must be at least 8 characters long');
      return;
    }
    if (!passwordR.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      displayLoginError('Password must contain at least one special character');
      return;
    }

    String payload = '{"email":"$emailR","password":"$passwordR","displayName":"$usernameR"}';
    String error = '';
    try
    {
      String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/register';
      var ret = await CardsData.postJson(url, payload);
      var jsonObject = json.decode(ret.body);
      error = jsonObject["error"];
    }
    catch(e)
    {
      displayLoginError(e.toString());
      return;
    }
    if( error == '' )
    {
      ElegantNotification.success(
        width: 360,
        stackedOptions: StackedOptions(
          key: 'top',
          type: StackedType.same,
          itemOffset: const Offset(-5, -5),
        ),
        position: Alignment.topCenter,
        animation: AnimationType.fromTop,
        title: const Text("Account Successfully Created!"),
        description: const Text("Please verify account before logging in."),
        shadow: BoxShadow(
          color: Colors.green.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4), // changes position of shadow
        ),
      ).show(context);
    }
    else {
      displayLoginError(error);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
                SizedBox(
                  height: size.height/2.1,
                  child:
                  Image.asset(
                    'assets/images/helldivers.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height/2.1 + 1,
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
            Image.asset(
              'assets/images/controllericon.png',
              height: 97,
              width: 150,
            ),
            // TITLE
            Container(
                width: size.width,
                alignment: Alignment.center,
                child:
                const Text(
                  'GameGrid',
                  style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.w900),
              )
            ),
            // Sign in button
            SizedBox(
              width: size.width,
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
              width: size.width,
              margin: const EdgeInsets.all(0),
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
            SizedBox(
              height: size.height/5.1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                text: TextSpan(
                  text: 'Artwork from',
                  style: TextStyle(color: text_color, fontSize: 12),
                  children: const [
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
          enableOnTap: false,
          child:
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: background_color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
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
                        height: size.height/1.45,
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
                          child: const Icon(
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
                          width: size.width,
                          height: size.height/2.4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [background_color, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [0.67, 1]
                            ),
                          ),
                            //color: background_color,
                          child:
                            Stack(
                            children: [
                              Positioned(
                                top: 50,
                                left: size.width/2 - 40,
                                child:
                                Image.asset(
                                  'assets/images/controllericon.png',
                                  height: 52,
                                  width: 80,
                                ),
                              ),
                              Positioned(
                                  width: size.width,
                                top: 110,
                                  child:
                                  const Text(
                                    'Sign in to GameGrid',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
                                  )
                              ),
                              Positioned(
                                top: 150,
                                width: size.width,
                                height: 45,
                                child:
                                TextField (
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: background_color,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: text_color, width: 0.15),
                                      borderRadius: const BorderRadius.all(Radius.circular(0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white, width: 0.15),
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ),
                                    floatingLabelStyle: TextStyle(color: text_color),
                                    labelText: 'Email',
                                  ),
                                  cursorColor: text_color,
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
                                width: size.width,
                                height: 45,
                                child:
                                TextField (
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: background_color,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: text_color, width: 0.15),
                                      borderRadius: const BorderRadius.all(Radius.circular(0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white, width: 0.15),
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ),
                                    floatingLabelStyle: TextStyle(color: text_color),
                                    labelText: 'Password',
                                  ),
                                  cursorColor: text_color,
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
                                width: size.width,
                                child:
                                Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(55, 0, 20, 0),
                                    child:
                                    ElevatedButton(
                                      onPressed: () {
                                        panelController.collapse();
                                        panelController2.expand();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        side: BorderSide(color: text_color, width: 0.15),
                                        minimumSize: const Size(50, 30),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: const Color.fromRGBO(71, 84, 100, 1),
                                      ),
                                      child:
                                      const Text(
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
                                    margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    child:
                                    ElevatedButton(
                                        onPressed: () {
                                          _doLogin();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          side: BorderSide(color: text_color, width: 0.15),
                                          minimumSize: const Size(130, 30),
                                          padding: EdgeInsets.zero,
                                          backgroundColor: const Color.fromRGBO(71, 84, 100, 1),
                                        ),
                                        child:
                                        const Text(
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
                                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child:
                                    ElevatedButton(
                                      onPressed: () async {

                                        if(email == '') {
                                          displayLoginError("Please enter an Email.");
                                          return;
                                        }
                                        if(password == '') {
                                          displayLoginError("Please enter a Password.");
                                          return;
                                        }
                                        if (!email.contains('@')) {
                                          displayLoginError("Please enter a valid Email.");
                                          return;
                                        }

                                        String payload = '{"email":"$email","password":"$password"}';
                                        var userID;
                                        var jsonObject;
                                        var error;
                                        try {
                                          String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/login';
                                          var ret = await CardsData.postJson(url, payload);
                                          jsonObject = json.decode(ret.body);
                                          userID = jsonObject["id"];
                                          error = jsonObject["error"];
                                        }
                                        catch (e) {
                                          displayLoginError(e.toString());
                                          return;
                                        }
                                        if (userID == -1) {
                                          displayLoginError(error);
                                        }
                                        else {
                                          GlobalData.userID = userID;
                                          GlobalData.displayName = jsonObject["displayName"];
                                          Navigator.pushNamed(context, '/content');
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        side: BorderSide(color: text_color, width: 0.15),
                                        minimumSize: const Size(50, 30),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: const Color.fromRGBO(86, 189, 72, 1),
                                      ),
                                      child:
                                      const Text(
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
          enableOnTap: false,
          child:
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: background_color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
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
                            height: size.height/1.45,
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
                            child: const Icon(
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
                                width: size.width,
                                height: size.height/2.1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [background_color, Colors.transparent],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: const [0.7, 1]
                                  ),
                                ),
                                //color: background_color,
                                child:
                                Stack(
                                    children: [
                                      Positioned(
                                        top: 50,
                                        left: size.width/2 - 40,
                                        child:
                                        Image.asset(
                                          'assets/images/controllericon.png',
                                          height: 52,
                                          width: 80,
                                        ),
                                      ),
                                      Positioned(
                                          width: size.width,
                                          top: 110,
                                          child:
                                          const Text(
                                            'Join GameGrid',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
                                          )
                                      ),
                                      Positioned(
                                        top: 150,
                                        width: size.width,
                                        height: 45,
                                        child:
                                        TextField (
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: background_color,
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            floatingLabelStyle: TextStyle(color: text_color),
                                            labelText: 'Email',
                                          ),
                                          style: TextStyle(
                                            color: text_color,
                                          ),
                                          cursorColor: text_color,
                                          onChanged: (text)
                                          {
                                            emailR = text;
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 194,
                                        width: size.width,
                                        height: 45,
                                        child:
                                        TextField (
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: background_color,
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            floatingLabelStyle: TextStyle(color: text_color),
                                            labelText: 'Username',
                                          ),
                                          cursorColor: text_color,
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
                                        width: size.width,
                                        height: 45,
                                        child:
                                        TextField (
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: background_color,
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 0.15),
                                              borderRadius: BorderRadius.all(Radius.circular(0)),
                                            ),
                                            floatingLabelStyle: TextStyle(color: text_color),
                                            labelText: 'Password',
                                          ),
                                          obscureText: true,
                                          cursorColor: text_color,
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
                                        width: size.width,
                                        child:
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(45, 0, 20, 0),
                                              child:
                                              OutlinedButton(
                                                  onPressed: () {
                                                    panelController2.collapse();
                                                    panelController.expand();
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    side: BorderSide(color: text_color, width: 0.15),
                                                    minimumSize: const Size(65, 30),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child:
                                                  const Text(
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
                                              margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                              child:
                                              OutlinedButton(
                                                  onPressed: () async {
                                                    if(emailR == '') {
                                                      displayLoginError("Please enter an Email.");
                                                      return;
                                                    }
                                                    if (!emailR.contains('@')) {
                                                      displayLoginError("Please enter a valid Email.");
                                                      return;
                                                    }
                                                    else {
                                                      String payload = '{"email":"$emailR"}';
                                                      var jsonObject;
                                                      try {
                                                        String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/forgot-password';
                                                        var ret = await CardsData.postJson(url, payload);
                                                        jsonObject = ret;
                                                      }
                                                      catch (e) {
                                                        displayLoginError("Could not reset password");
                                                        return;
                                                      }
                                                      if(jsonObject.statusCode == 200) {
                                                        displayResetPassword();
                                                      }
                                                      else if(jsonObject.statusCode == 404) {
                                                        displayLoginError("User not found");
                                                      }
                                                      else {
                                                        displayLoginError("Could not reset password");
                                                      }
                                                    }
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    side: BorderSide(color: text_color, width: 0.15),
                                                    minimumSize: const Size(130, 30),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child:
                                                  const Text(
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
                                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                child:
                                                ElevatedButton(
                                                    onPressed: () {
                                                      _doRegister();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                      side: BorderSide(color: text_color, width: 0.15),
                                                      minimumSize: const Size(50, 30),
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor: const Color.fromRGBO(86, 189, 72, 1),
                                                    ),
                                                    child:
                                                    const Text(
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
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child:
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: RichText(
                                            text: TextSpan(
                                                text: 'Artwork from',
                                                style: TextStyle(color: text_color, fontSize: 12),
                                                children: const [
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
