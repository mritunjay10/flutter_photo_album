import 'package:flutter/material.dart';
import 'package:flutter_photo_album/ui/pages/login_page.dart';
import 'package:flutter_photo_album/ui/pages/dashboard.dart';
import 'package:flutter_photo_album/utils/constants.dart';
import 'package:flutter_photo_album/ui/pages/slide_show.dart';
import 'package:flutter_photo_album/ui/pages/splash_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: app_name,
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder> {
        '/splash': (BuildContext context) => new SplashScreen(),
        '/login': (BuildContext context) => new LoginPage(), //6
        '/dashboard' : (BuildContext context) => new DashBoard(), //7
        '/slide' : (BuildContext context) => new Slideshow()//8
      },

    );
  }
}