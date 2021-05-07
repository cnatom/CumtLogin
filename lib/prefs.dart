

import 'dart:core';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

//获取本地信息
//Prefs.init()
//Prefs.getSchoolYear()
//Prefs.setSchoolYear()

class Prefs{

  static SharedPreferences prefs;

  static String _cumtLoginUsername = 'username';

  static String _cumtLoginPassword = 'password';

  static String _cumtLoginMethod = 'cumtLoginMethod';


  static String get cumtLoginUsername => prefs.getString(_cumtLoginUsername)??'';
  static String get cumtLoginPassword => prefs.getString(_cumtLoginPassword)??'';
  static int get cumtLoginMethod => prefs.getInt(_cumtLoginMethod);

  static set cumtLoginUsername(String value) =>prefs.setString(_cumtLoginUsername, value);
  static set cumtLoginPassword(String value) =>prefs.setString(_cumtLoginPassword, value);
  static set cumtLoginMethod(int value) =>prefs.setInt(_cumtLoginMethod, value);



  static Future<void> init()async{
    prefs = await SharedPreferences.getInstance();
  }


}