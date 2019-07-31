import 'dart:async';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_album/utils/constants.dart';
import 'package:flutter_photo_album/utils/PreferenceManager.dart';
import 'package:flutter_photo_album/models/User.dart';
import 'package:flutter_photo_album/style/theme.dart' as theme;
import 'dart:convert';
import 'package:flutter_photo_album/utils/permission.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    requestPermission();
  }


  void userLogin(username, password){

    checkUserLogin(username, password).then((onValue) async
    {
      dynamic resultArray = new JsonDecoder().convert(onValue.body);

      print(onValue.body);

      User us = User.fromJson(resultArray[0]['data']);
      us.password = password;

      PreferenceManager.saveUserData(us);

      PreferenceManager
          .getUserData()
          .then((u){

        if(int.parse(u.id)>0){
          Navigator.of(context).pushNamed('/dashboard');
        }
        else{
          Navigator.of(context).pushNamed('/login');
        }

      });

    }).catchError((onError){

      Navigator.of(context).pushNamed('/login');
    });
  }

  static Future<http.Response> checkUserLogin(username, password) async {
    final response =
    await http.post(url,body: {
      "user_name": username,
      "password": password,
      "method": "user_login"
    });
    return response;
  }

  void requestPermission() async{

    Future<String> data = Permission.checkPermission();

    data.then((value){

      checkPermissionResult(value);

    }).catchError((err){
      permissionDialog('Permission denied',
          'Failed to acquire some permission which are critical for functioning of app. Go to settings and grant them manually and restart app');
    });
  }

  void checkPermissionResult(String value){

    if(value == '3'){
      showDialog(context: context, builder: (BuildContext context) =>
          permissionDialog('Permission denied',
              'You denied some permission which are critical for functioning of app. Go to settings and grant them manually and restart app'));
    }
    else if(value == '2'){

      Future<String> data = Permission.requestPermission();
      data.then((val){

        checkPermissionResult(val);

      }).catchError((err){

        permissionDialog('Permission denied',
            'Failed to acquire some permission which are critical for functioning of app. Go to settings and grant them manually and restart app');
      });
    }
    else if(value == '1'){
      appProcess();
    }
  }

  void appProcess(){

    PreferenceManager
        .getUserData()
        .then((u) {
      if (int.parse(u.id) > 0) {
        //Navigator.of(context).pushNamed('/dashboard');
        userLogin(u.userName, u.password);
      }
      else {
        Navigator.of(context).pushNamed('/login');
      }
    }).catchError((error) {
      Navigator.of(context).pushNamed('/login');
    });
  }

  AlertDialog permissionDialog(title, body) => AlertDialog(
    title: new Text("$title"),
    content: new Text("$body"),
    actions: <Widget>[
      // usually buttons at the bottom of the dialog
      new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
          Permission.openSettings();
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      theme.Colors.loginGradientStart,
                      theme.Colors.loginGradientEnd
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)
            ),
          ),
          Image(
            image: new AssetImage('assets/img/login_logo.png'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(accentColor: Colors.white),
                      child:CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      app_name,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
