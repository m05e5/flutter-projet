import 'package:IUT_Project/screens/createPost.dart';
import 'package:IUT_Project/screens/home.dart';
import 'package:IUT_Project/screens/login.dart';
import 'package:IUT_Project/services/crud.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:IUT_Project/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:object_mapper/object_mapper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() async {
  
  Mappable.factories = {
    Posts : () => Posts(),  
  };
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
  await Firebase.initializeApp();
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: "/",
//         routes: {
//           "/": (context) => Scaffold(
//                 body: LoginPage(),
//               ),
//           "/home": (context) => Scaffold(
//                 body: Home(),
//               ),
//           "/create": (context) => Scaffold(
//                 body: CreatePost(),
//               ),
//         },
//       ),
//     );
//   }
// }
