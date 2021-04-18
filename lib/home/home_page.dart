import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {


    return Container(
      color: Color(0xFFFFFFFF),
      alignment: Alignment.center,
      child: Text("这就是登录成功后的主页啦!",style: TextStyle(fontSize: 20),),
    );
  }
}