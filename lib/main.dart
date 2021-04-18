import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost_app.dart';
import 'package:flutter_app_test_login_demo/home/home_page.dart';
import 'package:flutter_app_test_login_demo/login/login_page.dart';
import 'package:flutter_boost/boost_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  static Map<String, FlutterBoostRouteFactory>
  routerMap = {
    '/': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___)
      => Container());
    },
    'homePage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) =>
              HomePage());
    },
    'loginPage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) =>
              LoginPage());
    }};

  Route<dynamic> routeFactory(RouteSettings settings, String uniqueId) {
    FlutterBoostRouteFactory func =routerMap[settings.name];
    if (func == null) {
      return null;
    }
    return func(settings, uniqueId);
  }

  Widget _materialAppBuilder(Widget home) {
    return MaterialApp(
        home: home,
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    Future.delayed(Duration.zero,(){
      Future result = BoostNavigator.of().push('loginPage');
    });
  }
  
  @override
  Widget build(BuildContext context) {

    return FlutterBoostApp(
        routeFactory,
      appBuilder: _materialAppBuilder,
    );
  }
}
