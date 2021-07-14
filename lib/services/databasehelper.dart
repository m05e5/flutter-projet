import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper {
  String serverUrl = "http://192.168.43.45:8000/api";
  String serverUrlPosts = "http://192.168.43.45:8000/api/posts";

  var status;

  var token;
  loginData(String matricule, String password) async {
    String myUrl = "$serverUrl/login";
    final response = await http.post(myUrl, headers: {
      'Accept': 'application/json'
    }, body: {
      "matricule": "$matricule",
      "password": "$password",
    });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  Future<int> createPost(String titleController, String descriptionController,
      [String
          imgUrlController] // the square bracets is to say that the imgUrl is optional
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* $value");
    //String myUrl = "http://192.168.1.36:8000/api/posts/create";
    final response =
        await http.post("http://192.168.43.45:8000/api/posts/create", headers: {
      'Accept': "application/json",
      'Authorization': '$value'
    }, body: {
      "title": "$titleController",
      "description": "$descriptionController",
      "imgUrl": "$imgUrlController",
    });

    var data = json.decode(response.body);
    var id = data["data"]["id"];
    return id;
  }

  Future<int> createComment(String contentController, String postId,
      [String
          imgUrlController] // the square bracets is to say that the imgUrl is optional
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* $value");
    //String myUrl = "http://192.168.1.36:8000/api/posts/create";
    final response = await http
        .post("http://192.168.43.45:8000/api/comments/create", headers: {
      'Accept': "application/json",
      'Authorization': '$value'
    }, body: {
      "content": "$contentController",
      "post_id": "$postId",
      "imgUrl": "$imgUrlController"
    });

    var data = json.decode(response.body);
    var id = data["data"]["id"];
    return id;
  }

  void createPostWithTag(int postId, int tagChoosed) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* $value");
    //String myUrl = "http://192.168.1.36:8000/api/posts/create";
    final response = await http
        .post("http://192.168.43.45:8000/api/PostWithTag/create", headers: {
      'Accept': "application/json",
      'Authorization': '$value'
    }, body: {
      "post_id": "$postId",
      "tag_id": "$tagChoosed",
    });

    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    }
  }

  void updatePost(
    String id,
    String title,
    String description,
    String imgUrl,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/posts/update/$id";
    http.put(myUrl, headers: {
      'Accept': "application/json",
      'Authorization': '$value'
    }, body: {
      "title": "$title",
      "description": "$description",
      "imgUrl": "$imgUrl"
    }).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    });
  }

  void deletePost(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/posts/delete/$id";
    http.delete(myUrl, headers: {
      'Accept': "application/json",
      'Authorization': '$value'
    }).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    });
  }

  Future<List> getPost() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrlPosts";
    http.Response response = await http.get(myUrl,
        headers: {'Accept': "application/json", 'Authorization': '$value'});

    Map<String, dynamic> posts = json.decode(response.body);
    List<dynamic> data = posts["data"];
    return data;
  }

  Future<List> getTags() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/tags";
    http.Response response = await http.get(myUrl,
        headers: {'Accept': "application/json", 'Authorization': '$value'});

    Map<String, dynamic> tags = json.decode(response.body);
    List<dynamic> data = tags["data"];
    return data;
  }

  getMyData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/getMyData";
    http.Response response = await http.get(myUrl,
        headers: {'Accept': "application/json", 'Authorization': '$value'});
    return json.decode(response.body);
  }

  Future<List> getCommentsPerPosts(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/comments/onPost/$id";
    http.Response response = await http.get(myUrl,
        headers: {'Accept': "application/json", 'Authorization': '$value'});

    Map<String, dynamic> posts = json.decode(response.body);
    List<dynamic> data = posts["data"];
    return data;
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $token');
  }
}
/*

4.1091071,
9.7675340

 */