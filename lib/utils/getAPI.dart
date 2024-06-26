import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class GlobalData
{
  static String userID = '';
  static String displayName = '';
  static String email = '';
  static String password = '';
}

class CardsData {
  static Future postJson(String url, String outgoing) async
  {
    var ret;
    try
    {
      var response = await http.post(Uri.parse(url),
          headers:
          {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: utf8.encode(outgoing),
          encoding: Encoding.getByName("utf-8")
      );
      ret = response;
    }
    catch (e)
    {
      String err = e.toString();
      return err;
    }
    return ret;
  }

  static Future putJson(String url, String outgoing) async
  {
    var ret;
    try
    {
      var response = await http.put(Uri.parse(url),
          headers:
          {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: utf8.encode(outgoing),
          encoding: Encoding.getByName("utf-8")
      );
      ret = response;
    }
    catch (e)
    {
      String err = e.toString();
      return err;
    }
    return ret;
  }

  static Future getJson(String url) async
  {
    var ret;
    try
    {
      var response = await http.get(Uri.parse(url));
      ret = response;
    }
    catch (e)
    {
      String err = e.toString();
    }
    return ret;
  }

  static Future<http.Response> delJson(String url) async
  {
    var ret;
    try
    {
      var response = await http.delete(Uri.parse(url));
      ret = response;
    }
    catch (e)
    {
      String err = e.toString();
    }
    return ret;
  }
}

class GameCard {
  final String imageURL;
  final String gameId;

  const GameCard(this.imageURL,  this.gameId);
}

class GameCardRelease {
  final String imageURL;
  final String gameId;
  final String releaseDate;
  final String gameName;

  const GameCardRelease(this.imageURL,  this.gameId, this.releaseDate, this.gameName);
}

class ContentData {

  static Future<List<GameCard>> fetchGameCards(int limit, int offset, String search) async {
    String payload = '{"limit":$limit,"offset":$offset,"genre":"","search":"$search"}';
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/games';

    final response = await CardsData.postJson(url, payload);
    if(response.statusCode == 500) return [];
    var decoded = json.decode(response.body);

    List<GameCard> gameList = [];

    for(int i = 0; i<decoded.length; i++){
      if(decoded[i]['cover'] == null) continue;
      String formattedUrl = 'https:${decoded[i]['cover']['url'].replaceAll('t_thumb', 't_cover_big')}';
      String gameId = '${decoded[i]['id']}';
      gameList.add(GameCard(formattedUrl, gameId));
    }

    return gameList;
  }

  static Future<List<GameCardRelease>> fetchNewReleaseGameCards(int limit, int offset) async {
    String payload = '{"limit":"$limit","offset":"$offset","genre":"","search":"","newReleases":true}';
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/games';

    final response = await CardsData.postJson(url, payload);
    if(response.statusCode == 500) return [];
    var decoded = json.decode(response.body);

    List<GameCardRelease> gameList = [];

    for(int i = 0; i<decoded.length; i++){
      String formattedUrl = 'https:${decoded[i]['cover']['url'].replaceAll('t_thumb', 't_cover_big')}';
      String gameId = '${decoded[i]['id']}';
      int releaseDate = decoded[i]['first_release_date'];
      DateTime date = DateTime.fromMillisecondsSinceEpoch(releaseDate * 1000);
      String formattedDate = DateFormat('MM/dd/yyyy').format(date);
      String gameName = decoded[i]['name'];
      gameList.add(GameCardRelease(formattedUrl, gameId, formattedDate, gameName));
    }

    return gameList;
  }

/* -----------------------------
  *  Game related API requests
  *
  *  -- Game info container
    {
          "id": 250616,
          "cover": {
              "id": 331836,
              "url": "//images.igdb.com/igdb/image/upload/t_thumb/co741o.jpg"
          },
          "first_release_date": 1707350400,
          "involved_companies": [
              {
                  "id": 216800,
                  "company": {
                      "id": 953,
                      "name": "Arrowhead Game Studios"
                  }
              },
              {
                  "id": 219275,
                  "company": {
                      "id": 10100,
                      "name": "Sony Interactive Entertainment"
                  }
              }
          ],
          "name": "Helldivers 2",
          "platforms": [
              {
                  "id": 6,
                  "name": "PC (Microsoft Windows)"
              },
              {
                  "id": 167,
                  "name": "PlayStation 5"
              }
          ],
          "summary": "summary here",
      }
  * ----------------------------- */

// Add game to user's library (play list)
  static Future<String> addGametoList(String gameId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/addGame';
    String payload = '{"email":"${GlobalData.email}","videoGameId":"$gameId"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    String retErr = decoded['error']; //returning status message
    return retErr;
  }

// Remove game from user's library
  static Future<String> removeGameFromList(int gameId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/user/games/${GlobalData.userID}/$gameId';

    final response = await CardsData.delJson(url);
    var decoded = json.decode(response.body);

    String message = '';

    if (response.statusCode == 200) {
      message = decoded['message'];
    }
    else {
      message = decoded['error'];
    }
    return message;
  }

// Fetch info for a specific game
  static Future fetchGameInfo(String videoGameId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/games/gameName';
    String payload = '{"gameId":"$videoGameId"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    var info = decoded[0];
    if (response.statusCode == 200) {
      return info;
    }

    return null;
  }

// Fetch games list from specific user
  static Future fetchUserGames(String userId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/user/games/$userId';

    final response = await CardsData.getJson(url);
    var decoded = json.decode(response.body);

    var info = decoded["games"];
    if (response.statusCode == 200) {
      return info;
    }
    String err = decoded["error"];
    return err;
  }

  // Fetches "reviewCount" and "rating" for a specific game
  static Future fetchGameStats(String videoGameId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/reviews/stats/$videoGameId';

    final response = await CardsData.getJson(url);
    var decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      return decoded;
    }
    String retErr = decoded['error']; //returning error message
    return retErr;
  }

/* -----------------------------
  *  Friend related API requests
  * ----------------------------- */

// Fetch user's incoming friend requests
// id = friendRequests[index]["id"]
// name = friendRequests[index]["displayName"]
  static Future fetchFriendRequest() async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/received-requests/${GlobalData.userID}';

    final response = await CardsData.getJson(url);
    var decoded = json.decode(response.body);

    var receivedList = decoded["receivedRequests"];

    // null catcher
    for(int i = 0; i<receivedList.length; i++) {
      if(receivedList[i] == null) receivedList.removeAt(i);
    }

    if (response.statusCode == 200) {
      return receivedList;
    }
    String err = decoded["error"];
    return err;
  }

// Send friend request to another user
  static Future<String> sendFriendRequest(String friendId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/send-request';
    String payload = '{"userId":"${GlobalData.userID}","friendId":"$friendId"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      String mess = decoded['message'];
      return mess;
    }
    String retErr = decoded['error']; //returning status message
    return retErr;
  }

// Accept friend request from another user
  static Future<String> acceptFriendRequest(String friendId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/accept-request';
    String payload = '{"userId":"${GlobalData.userID}","friendId":"$friendId"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      String mess = decoded['message'];
      return mess;
    }
    String retErr = decoded['error']; //returning status message
    return retErr;
  }

// Reject friend request from another user
  static Future<String> rejectFriendRequest(String friendId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/reject-request';
    String payload = '{"userId":"${GlobalData.userID}","friendId":"$friendId"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      String mess = decoded['message'];
      return mess;
    }
    String retErr = decoded['error']; //returning status message
    return retErr;
  }

  // Remove friend from friends list
  static Future<String> removeFriend(String friendId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/remove';
    String payload = '{"userId":"${GlobalData.userID}","friendId":"$friendId"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      String mess = "Friend removed";
      return mess;
    }
    String retErr = decoded['error']; //returning status message
    return retErr;
  }



  // Fetch all friends info
  // id = friendList[index]["id"]
  // email = friendList[index]["email"]
  // name = friendList[index]["displayName"]
  static Future fetchFriendList(String userId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/$userId';

    final response = await CardsData.getJson(url);
    var decoded = json.decode(response.body);

    var receivedList = decoded["friends"];

    // null catcher
    for(int i = 0; i<receivedList.length; i++) {
      if(receivedList[i] == null) receivedList.removeAt(i);
    }

    if (response.statusCode == 200) {
      return receivedList;
    }
    return null;
  }

/* -----------------------------
  *  User specific API requests
  * ----------------------------- */

// Update user display name, or email, or password
  static Future<String> changeUserPassword(String password) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/updateuser';
    String payload = '{"email":"${GlobalData.email}","newEmail":"","newPassword":"$password","newDisplayName":""}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    String retErr = decoded['error']; //returning status message
    return retErr;
  }

// Search for a user (returns list of users)
  static Future searchUsers(String displayName) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/searchusers';
    String payload = '{"displayName":"$displayName"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);
    String retErr = decoded['error']; //returning status message
    var userInfo = decoded['user'];

    if(retErr != '') {
      return retErr;
    }

    return userInfo;

    // add info handling here
    /*
    "user": {
      "id": "660b375bda67e0e30895a46b",
      "email": "richardzz3233@gmail.com",
      "displayName": "richardzz32",
      "dateCreated": "2024-04-01T22:38:19.338Z",
      "dateLastLoggedIn": null
    },
    * */
  }

// Delete a user --confirm to prevent accidental calls
  static Future<String> deleteUser(bool confirm) async {
    if (!confirm) return '';

    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/deleteuser';
    String payload = '{"id":"${GlobalData.userID}"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    String retErr = decoded['error']; //empty if successful
    String success = decoded['successMessage']; //empty if error

    if(retErr == '') {
      return success;
    }

    return retErr;

  }

/* -----------------------------
  *         REVIEWS APIs
  *
  *  -- Review container data
        {
            "_id": "6619bc03ad668a962cd885b8",
            "dateWritten": "2024-04-12T22:56:03.974Z",
            "textBody": "Its peak",
            "rating": 5,
            "videoGameId": "133236",
            "displayName": null
        },
  *
  * ----------------------------- */

// Update user display name, or email, or password
  static Future<String> addReview(String textBody, String rating, String videoGameId, String displayName, String videoGameName) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/reviews';
    String payload = '{"textBody":"$textBody","rating":$rating,"videoGameId":"$videoGameId","displayName":"$displayName","videoGameName":"$videoGameName"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      String mess = decoded['message'];
      return mess;
    }
    String retErr = decoded['error']; //returning error message
    return retErr;
  }

  // Sends updated review
  static Future<String> editReview(String textBody, int rating, String reviewId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/reviews/edit/$reviewId';
    String payload = '{"textBody":"$textBody","rating":$rating}';

    final response = await CardsData.putJson(url, payload);
    var decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      String mess = decoded['message'];
      return mess;
    }
    String retErr = decoded['error']; //returning error message
    return retErr;
  }

  // Delete a review
  static Future<String> deleteReview(String reviewId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/reviews/delete/$reviewId';

    final response = await CardsData.delJson(url);
    var decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      String mess = decoded['message'];
      return mess;
    }
    String retErr = decoded['error']; //returning error message
    return retErr;
  }

// Fetch reviews for an individual user

  static Future fetchUserReviews(String displayName) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/reviews/search/$displayName';
    final response = await CardsData.getJson(url);

    var decoded = json.decode(response.body);

    var receivedList = decoded["reviews"];
    if (response.statusCode == 200) {
      return receivedList;
    }
    String err = decoded["error"];
    return err;

  }

  // Fetches reviews for a specific review
  static Future fetchGameReviews(String videoGameId) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/getReviews';
    String payload = '{"videoGameId":"$videoGameId"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    var receivedList = decoded['reviews'];
    return receivedList;

  }

// Fetches most recent reviews (default = 10; set pageSize for different amount)
  static Future fetchRecentReviews(int pageSize) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/getRecentReviews';
    String payload = '{"pageSize":$pageSize}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    var receivedList = decoded['recentReviews'];
    return receivedList;

  }
}

