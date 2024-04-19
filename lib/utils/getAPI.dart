import 'package:http/http.dart' as http;
import 'dart:convert';

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

class ContentData {

  static Future<List<GameCard>> fetchGameCards(int limit, int offset, String search) async {
    String payload = '{"limit":"$limit","offset":"$offset","genre":"","search":"$search"}';
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/games';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    List<GameCard> gameList = [];

    for(int i = 0; i<decoded.length; i++){
      String formattedUrl = 'https:' + decoded[i]['cover']['url'].replaceAll('t_thumb','t_cover_big');
      String gameId = '${decoded[i]['id']}';
      gameList.add(GameCard(formattedUrl, gameId));
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

    return "";
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


/* -----------------------------
  *  Friend related API requests
  * ----------------------------- */

// Fetch user's incoming friend requests
// id = friendRequests[index]["id"]
// name = friendRequests[index]["displayName"]
  static Future<List<dynamic>> fetchFriendRequest() async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/received-requests/${GlobalData.userID}';

    final response = await CardsData.getJson(url);
    var decoded = json.decode(response.body);

    var receivedList = decoded["receivedRequests"];
    if (response.statusCode == 200) {
      return receivedList;
    }
    List<String> err = [decoded["error"]];
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

  // Fetch all friends info
  // id = friendList[index]["id"]
  // email = friendList[index]["email"]
  // name = friendList[index]["displayName"]
  static Future fetchFriendList() async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/friends/${GlobalData.userID}';

    final response = await CardsData.getJson(url);
    var decoded = json.decode(response.body);

    var receivedList = decoded["friends"];
    if (response.statusCode == 200) {
      return receivedList;
    }
    return "Failed to fetch friends";
  }

/* -----------------------------
  *  User specific API requests
  * ----------------------------- */

// Update user display name, or email, or password
  static Future<String> updateUserInfo(String password, String displayName, String email) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/updateuser';
    String payload = '{"email":"${GlobalData.email}","newEmail":"$email","newPassword":"$password","newDisplayName":"$displayName"}';

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
  static Future<String> addReview(String textBody, String rating, String videoGameId, String displayName) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/reviews';
    String payload = '{"textBody":"$textBody","rating":"$rating","videoGameId":"$videoGameId","displayName":"$displayName"}';

    final response = await CardsData.postJson(url, payload);
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

// Fetches most recent reviews (default = 10; set pageSize for different amount)
  static Future<List<dynamic>> fetchRecentReviews(int pageSize) async {
    String url = 'https://g26-big-project-6a388f7e71aa.herokuapp.com/api/getRecentReviews';
    String payload = '{"pageSize":"$pageSize"}';

    final response = await CardsData.postJson(url, payload);
    var decoded = json.decode(response.body);

    var receivedList = decoded['recentReviews'];
    return receivedList;

  }
}

