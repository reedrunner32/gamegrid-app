import 'package:flutter/material.dart';
import 'package:gamegrid/utils/getAPI.dart';
import 'dart:convert';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
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
  String addMessage = '', newAddMessage = '';
  String searchMessage = '', newSearchMessage = '';

  void changeText() {
    setState(() {
      message = newMessageText;
    });
  }
  void changeAddText() {
    setState(() {
      addMessage = newAddMessage;
    });
  }
  void changeSearchText() {
    setState(() {
      searchMessage = newSearchMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    String card = '';
    String search = '';
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
                          labelText: 'Search',
                          hintText: 'Search for a Card'
                      ),
                      onChanged: (text)
                      {
                        search = text;
                      },
                    ),
                  ),
                  ElevatedButton(
                      child: Text('Search',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                    onPressed: () async
                    {
                      newSearchMessage = "";
                      changeSearchText();
                      String payload = '{"userId":"' + GlobalData.userID.toString() + '","search":"' +
                          search.trim() + '"}';
                      var jsonObject;
                      try
                      {
                        String url = 'https://cop4331-10.herokuapp.com/api/searchcards';
                        String ret = await CardsData.getJson(url, payload);
                        jsonObject = json.decode(ret);
                      }
                      catch(e)
                      {
                        newSearchMessage = e.toString();
                        changeSearchText();
                        return;
                      }
                      var results = jsonObject["results"];
                      var i = 0;
                      while( true )
                      {
                        try
                        {
                          newSearchMessage += results[i];
                          newSearchMessage += "\n";
                          i++;
                        }
                        catch(e)
                        {
                          break;
                        }
                      }
                      changeSearchText();
                    },

                  )
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
                          obscureText: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: 'Add',
                              hintText: 'Add a Card'
                          ),
                          onChanged: (text)
                          {
                            card = text;
                          }
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text('$addMessage',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                      child: Text('Add',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                    onPressed: () async
                    {
                      newAddMessage = "";
                      changeAddText();
                      String payload = '{"userId":"' + GlobalData.userID.toString() + '","card":"' +
                          card.trim() + '"}';
                      var jsonObject;
                      try
                      {
                        String url = 'https://cop4331-10.herokuapp.com/api/addcard';
                        String ret = await CardsData.getJson(url, payload);
                        jsonObject = json.decode(ret);
                      }
                      catch(e)
                      {
                        newAddMessage = e.toString();
                        changeAddText();
                        return;
                      }
                      newAddMessage = "Card has been added";
                      changeAddText();
                    },
                  )
                ]
            ),
            Row(
              children: <Widget>[
                Text('$message',style: TextStyle(fontSize: 14 ,color:Colors.black)),
              ],
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                    child: Text('Logout',style: TextStyle(fontSize: 14 ,color:Colors.black)),
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