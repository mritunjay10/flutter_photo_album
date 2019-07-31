import 'dart:async';

import 'package:flutter/services.dart';

class Permission {
  static const MethodChannel channel = const MethodChannel('indilabz.in/permission');


  static Future<String> checkPermission() async{

    var status = await channel.invokeMethod("getPermissionsStatus");

    return status;
  }

  static Future<String> requestPermission() async{

    var status = await channel.invokeMethod("requestPermission");

    return status;
  }

  static void openSettings(){

    channel.invokeMethod("openSettings");
  }
}
