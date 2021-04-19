import 'package:IUT_Project/screens/home.dart';
import 'package:IUT_Project/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  SharedPreferences sharedPreferences;

  Future<Widget> checkLoginState() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      await Future.delayed(const Duration(seconds: 10));
      return  Future.value(new LoginPage());
      //  new LoginPage();
      // Navigator.pushReplacementNamed(context, '/login');
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      //     (Route<dynamic> route) => false);
    } else {
      await Future.delayed(const Duration(seconds: 10));
      return Future.value(new Home());
      // new Home();
      // Navigator.pushReplacementNamed(context, '/home');
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (BuildContext context) => Home()),
      // (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new SplashScreen(
        
          navigateAfterFuture: checkLoginState(),
        //  title: new Text('Welcome In SplashScreen'),
          image: Image.asset('assets/IUT2.png',fit: BoxFit.cover ),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 50.0,
          loaderColor: Colors.red),
    );
  }
}
