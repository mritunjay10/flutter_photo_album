import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_photo_album/models/User.dart';
import 'package:flutter_photo_album/models/Album.dart';

class PreferenceManager{

  static SharedPreferences sharedPreferences;

  static void saveUserData(User user) async {

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('user', json.encode(user).toString());
    //sharedPreferences.commit();
  }

  static Future<User> getUserData() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromJson(new JsonDecoder().convert(prefs.getString('user')));
  }

  static void saveSelectedAlbum(Album album) async {

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('album', json.encode(album).toString());
    //sharedPreferences.commit();
  }

  static Future<Album> getSelectedAlbum() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Album.fromJson(new JsonDecoder().convert(prefs.getString('album')));
  }

  static Future<bool> logout() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

}