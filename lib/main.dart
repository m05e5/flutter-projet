import 'package:IUT_Project/screens/home.dart';
import 'package:IUT_Project/screens/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          "/": (context)=>Scaffold(
            body: Welcome(),
          ),
          "home":(context)=>Scaffold(
            body: Home(),
          ),
        },
      ),
    );
  }
}
