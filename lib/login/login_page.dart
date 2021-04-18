import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_test_login_demo/tools/ddky_toast.dart';
import 'package:flutter_app_test_login_demo/home/home_page.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  //记住我的手机号
  bool _rememberMyNum = true;
  //用于实时获取手机号输入框文本
  final TextEditingController _phoneController = new TextEditingController();
  //用于实时获取密码输入框文本
  final TextEditingController _passwordController = new TextEditingController();
  //用于实时获取验证码输入框文本
  final TextEditingController _verfiCodeController = new TextEditingController();
  //网络请求加载中...
  bool _netloading = false;
  //定时器
  Timer _countdownTimer;
  String _countdownStr = '获取验证码';
  //登录方式：1(账号密码登录)、2(验证码登录)
  int _loginType = 1;

  @override
  void initState() {
    super.initState();

    setState(() {
      _phoneController.text = "13866663333";
      _passwordController.text = "123456";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: LoadingOverlay(
                isLoading: _netloading,
                child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 60+MediaQuery.of(context).padding.top),
                              ClipRRect(child: Image.asset('images/icon_login_logo.png',fit: BoxFit.cover,width: 72,height: 72),borderRadius: BorderRadius.circular(5.0)),
                              SizedBox(height: 30),
                              ConstrainedBox(constraints: BoxConstraints.tightFor(width: double.infinity),child: Text("配送人员系统",style: TextStyle(fontSize: 26),textAlign:TextAlign.left)),
                              createUserAccountTextField(),
                              createPasswordTextField(),
                              createRememberPhoneNum(),
                              SizedBox(height: 28),
                              createLoginButton(),
                              SizedBox(height: 20,),
                            ]
                        )
                    )
                )
            )
        )
    );
  }

  //工号/手机号输入框
  Widget createUserAccountTextField(){
    return TextField(
      decoration: InputDecoration(
        hintText: "手机号" ,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEEEEEE))),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEEEEEE))),
        contentPadding: const EdgeInsets.symmetric(vertical: 25.0),
      ),
      controller:_phoneController,
      keyboardType: TextInputType.number,
    );
  }

  //密码输入框
  Widget createPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "密码",
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEEEEEE))),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEEEEEE))),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
      ),
      controller: _passwordController,
      obscureText: true,
    );
  }

  //记住手机号
  Widget createRememberPhoneNum() {
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: (){setState(() {_rememberMyNum = !_rememberMyNum;});},
              child: Row(
                  children: [
                    Image.asset(_rememberMyNum==true ? 'images/icon_remember_num.png' : 'images/icon_un_remember_num.png'),
                    SizedBox(width: 5),
                    Text('记住我的手机号', style: TextStyle(color: Color(0xFF888888), fontSize: 12.0),),
                  ]
              ),
              style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero),),
            )
          ],
        )
    );
  }

  //登录按钮
  Widget createLoginButton() {
    return Container(
      height: 44,
      width: double.infinity,
      child: TextButton(
        onPressed: (){loginClicked();},
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),)),
          backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xFFE94544),),
        ),
        child: Text('登录',style: TextStyle(color: Colors.white)),
      ),
    );
  }

  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$    点击事件都写在这里了    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

  //点击了登录按钮
  void loginClicked() {
    FocusScope.of(context).requestFocus(FocusNode());

    if(1==_loginType) {
      //密码登录
      if(_phoneController.text.length == 0){
        DdkyToast.toast(context,msg: "请输入登录账号!",position: ToastPostion.center);
        return;
      }else if(_passwordController.text.length == 0){
        DdkyToast.toast(context,msg: "请输入登录密码!",position: ToastPostion.center);
        return;
      }
      _beginPWDLoginRequest();
    }

  }

  showUserMainPage() {

    //进入配送员任务列表页
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context){
            return HomePage();
          },
        ),
            (route) {return route == null;}
    );
  }

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    网络请求以及数据解析都写在这里了    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  //密码登录的请求
  void _beginPWDLoginRequest() {

    setState(() {_netloading = true;});

    //模拟登录网络请求....
    Future.delayed(Duration(seconds: 2),() {
      setState(() {_netloading = false;});
      DdkyToast.toast(context,msg:"登录成功",position: ToastPostion.center);
      showUserMainPage();
    });
  }


  //##############################################################        资源回收以防内存泄漏        ##############################################################

  void dispose() {
    _phoneController.dispose();
    _verfiCodeController.dispose();
    if(_countdownTimer != null) {
      _countdownTimer.cancel();
    }
    super.dispose();
  }
}