import 'package:cumt_login/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'login.dart';

void main() async{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _formKey; //表单状态
  TextEditingController usernameController;
  TextEditingController passwordController;
  int loginType;
  String text = 'Flying Studio';
  bool loading = false;
  void initFunc()async{
    await Prefs.init();
    _formKey = GlobalKey<FormState>(); //表单状态
    usernameController = new TextEditingController(text: Prefs.cumtLoginUsername??'');
    passwordController = new TextEditingController(text: Prefs.cumtLoginPassword??'');
    loginType = Prefs.cumtLoginMethod??1;
    await cumtAutoLogin();
  }
  //校园网自动登录
  Future<void> cumtAutoLogin()async{
    setState(() {
      text = '自动登录中……';
    });
    if(Prefs.cumtLoginUsername!=null){
      text = await cumtAutoLoginGet(context,
          username: Prefs.cumtLoginUsername,
          password: Prefs.cumtLoginPassword,
          loginMethod: Prefs.cumtLoginMethod);
    }
    setState(() {

    });
  }
  Future<void> login()async{
    setState(() {
      loading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());//收起键盘
    //判空
    String username = usernameController.text??'';
    String password = passwordController.text??'';
    if (username==''||password=='') {
      setState(() {
        text = '请填写账号密码';
      });
      return;
    }
    //登录请求并决定是否跳转
    text = await cumtLoginGet(context,username: username,password: password,loginMethod: loginType);
    setState(() {

    });
    setState(() {
      loading = false;
    });
  }
  Future<void> logout()async{
    text = await cumtLogoutGet(context);
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    initFunc();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Cumt 校园网自动登录',),
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(text,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      inputBar('账号', usernameController),
                      SizedBox(height: 20,),
                      inputBar('密码', passwordController,obscureText: true),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [_buildSelect(),],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // color: colorLoginPageMain.withOpacity(0.6),
                        ),
                        child: InkWell(
                          splashColor: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => login(),
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).primaryColor,

                              ),
                              child: Text(loading?'登录中……':'登录', style: TextStyle(color: Colors.white),)),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // color: colorLoginPageMain.withOpacity(0.6),
                        ),
                        child: InkWell(
                          splashColor: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => logout(),
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 247,248,249),

                              ),
                              child: Text('注销', style: TextStyle(color: Theme.of(context).primaryColor),)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text('相当于在校园网网站上登录\n完全免费，随便造作\n— 阿腾木 —',style: TextStyle(color: Colors.black38,),textAlign: TextAlign.center,),

                    ],
                  ),
                )

              ],
            ),
          )
      ),
    );
  }
  Container _buildSelect() {
    return Container(
      child: DropdownButton(
        elevation: 0,
        underline: Container(),
        value: loginType ,
        onChanged: (value) {
          setState(() {
            loginType = value;
          });
        }, items: [
        DropdownMenuItem(value: 0,child: Text("校园"),onTap: (){},),
        DropdownMenuItem(value: 1,child: Text("电信"),onTap: (){},),
        DropdownMenuItem(value: 2,child: Text("联通"),onTap: (){},),
        DropdownMenuItem(value: 3,child: Text("移动"),onTap: (){},),
      ],
      ),
    );
  }
  //输入框组件
  Widget inputBar(String hintText, TextEditingController controller,
      {FormFieldSetter<String> onSaved, bool obscureText = false}) =>
      Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:Color.fromARGB(255, 247,248,249)
        ),
        child: TextFormField(
          textAlign: TextAlign.center,
          obscureText: obscureText, //是否是密码
          controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
          decoration: InputDecoration(
            border: InputBorder.none, //下划线
            hintText: hintText, //点击后显示的提示语
          ),
          onSaved: onSaved,
        ),
      );
}
