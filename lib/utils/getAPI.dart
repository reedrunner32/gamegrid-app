import 'package:http/http.dart' as http;
import 'dart:convert';

class CardsData {
  static Future<String> getJson(String url, String outgoing) async
  {
    String ret = "";
    try
    {
      http.Response response = await http.post(Uri.parse(url),
          headers:
          {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: utf8.encode(outgoing),
          encoding: Encoding.getByName("utf-8")
      );
      if (response.statusCode == 200) {
        ret = response.body;
      }
      else {
        throw Exception('Failed to load data');
      }
    }
    catch (e)
    {
      print(e.toString());
    }
    return ret;
  }
}

class GlobalData
{
  static String userID = '';
  static String displayName = '';
  static String email = '';
  static String password = '';
}

