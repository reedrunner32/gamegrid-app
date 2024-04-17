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

      ret = response.body;

    }
    catch (e)
    {
      print(e.toString());
    }
    return ret;
  }

  static Future<String> getJsonG(String url) async
  {
    String ret = "";
    try
    {
      http.Response response = await http.get(Uri.parse(url));
      ret = response.body;
    }
    catch (e)
    {
      throw Exception(e.toString());
    }
    return ret;
  }

  static Future<String> delJson(String url) async
  {
    String ret = "";
    try
    {
      http.Response response = await http.delete(Uri.parse(url));
      ret = response.body;
    }
    catch (e)
    {
      throw Exception(e.toString());
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

