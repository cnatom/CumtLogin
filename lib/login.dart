//校园网登陆
import 'dart:convert';
import 'package:cumt_login/prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

Future<String> cumtLoginGet(BuildContext context,{@required String username,@required String password,@required int loginMethod}) async {
  Prefs.cumtLoginUsername = username;
  Prefs.cumtLoginPassword = password;
  Prefs.cumtLoginMethod = loginMethod;
  String text;
  try {
    String method;
    switch(loginMethod) {
      case 0:method = "";break;//校园网
      case 1:method = "%40telecom";break;//电信
      case 2:method = "%40unicom";break;//联通
      case 3:method = "%40cmcc";break;//移动
    }
    Response res;
    Dio dio = Dio();
    debugPrint("http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account="+username+method+"&user_password=$password");
    //配置dio信息
    res = await dio.get("http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account="+username+method+"&user_password=$password",);
    //Json解码为Map
    debugPrint(res.toString());
    Map<String, dynamic> map = jsonDecode(res.toString().substring(1,res.toString().length-1));
    debugPrint(map.toString());
    if (map['result']=="1") {
      return '登录成功,下次打开App就会自动登录';
    }else{
      switch(map["ret_code"]){
        case "2":{
          text = '您已登录校园网';
          break;
        }
        case "1":{
          if(map['msg']=="dXNlcmlkIGVycm9yMg=="){
            text = '账号或密码错误';
          }else if(map['msg']=='dXNlcmlkIGVycm9yMQ=='){
            text = '账号不存在，请切换运营商再尝试';
          }else if(map['msg']=='UmFkOkxpbWl0IFVzZXJzIEVycg=='){
            text = '您的登陆超限\n请在"用户自助服务系统"下线终端。';
          }else{
            text = '未知错误，欢迎向我们反馈QAQ';
          }
          break;
        }
      }
      return text;
    }
  } catch (e) {
    debugPrint(e.toString());
    text = "登录失败，确保您已经连接校园网(CUMT_Stu或CUMT_tec)";
    return text;
  }
}
Future<String> cumtAutoLoginGet(BuildContext context,{@required String username,@required String password,@required int loginMethod}) async {
  try {
    String method;
    switch(loginMethod) {
      case 0:method = "";break;//校园网
      case 1:method = "%40telecom";break;//电信
      case 2:method = "%40unicom";break;//联通
      case 3:method = "%40cmcc";break;//移动
    }
    Response res;
    Dio dio = Dio();
    //配置dio信息
    debugPrint("http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account="+username+method+"&user_password=$password");
    res = await dio.get("http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account="+username+method+"&user_password=$password",);
    //Json解码为Map
    debugPrint(res.toString());
    Map<String, dynamic> map = jsonDecode(res.toString().substring(1,res.toString().length-1));
    if (map['result']=="1") {

      return '已自动登录校园网！';
    }
    return '您已登录校园网！';
  } catch (e) {
    debugPrint(e.toString());
    return '自动登录失败';
  }
}
Future<String> cumtLogoutGet(BuildContext context)async{
  try {
    Response res;
    Dio dio = Dio();
    debugPrint("http://10.2.5.251:801/eportal/?c=Portal&a=logout&login_method=1");
    //配置dio信息
    res = await dio.get("http://10.2.5.251:801/eportal/?c=Portal&a=logout&login_method=1",);
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString().substring(1,res.toString().length-1));
    return map["msg"].toString();
  } catch (e) {
    debugPrint(e.toString());
    return '网络错误(X_X)';
  }
}