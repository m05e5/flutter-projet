
import 'package:IUT_Project/provider/authentication_notifier.dart';
import 'package:IUT_Project/provider/authentication_provider.dart';
import 'package:IUT_Project/screens/home.dart';
import 'package:IUT_Project/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splashscreen/splashscreen.dart';

class AuthenticationManager extends StatefulWidget {
  static String routeName = 'manager';
  @override
  _AuthenticationManagerState createState() => _AuthenticationManagerState();
}

class _AuthenticationManagerState extends State<AuthenticationManager> {

  @override
  void initState() {
    final _authNotifier = context.read(authenticationNotifierProvider);
    _authNotifier.loginWithToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child){
        final _authState = watch(authenticationNotifierProvider.state);
        if(_authState is BaseAuthenticationState){
          return SplashScreen();
        } else if (_authState is UserConnectedState) {
          return Home();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
