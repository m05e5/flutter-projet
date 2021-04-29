import 'package:IUT_Project/screens/ProfilePage.dart';
import 'package:IUT_Project/screens/createPost.dart';
import 'package:IUT_Project/screens/home.dart';
import 'package:IUT_Project/screens/login.dart';
import 'package:IUT_Project/screens/signup.dart';
import 'package:IUT_Project/screens/welcome.dart';
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
    Posts: () => Posts(),
  };

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => Scaffold(
                body: Welcome(),
              ),
          "/home": (context) => Scaffold(
                body: Home(),
              ),
          "/login": (context) => Scaffold(
                body: LoginPage(),
          ),
          "/signup": (context) => Scaffold(
                body: SignUp(),
          ),
          "/create": (context) => Scaffold(
                body: CreatePost(),
              ),
           "/profilePage": (context) => Scaffold(
                body: ProfilePage(),
              ),
              
        },
      ),
    );
  }
}

// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   SharedPreferences sharedPreferences;

//   @override
//   void initState() {
//     super.initState();
//     checkLoginState();
//   }

//   checkLoginState() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     if (sharedPreferences.getString('token') == null) {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
//           (Route<dynamic> route) => false);
//     }
//   }

//   Widget build(BuildContext context) {
//    return Scaffold(
//       appBar: AppBar(
//         title: Text(" Flutter", style: TextStyle(color: Colors.white)),
//         actions: <Widget>[
//           FlatButton(
//             onPressed: () {
//               sharedPreferences.clear();
//               sharedPreferences.commit();
//               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
//             },
//             child: Text("Log Out", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//       body: Center(child: Text("Main Page")),
//       drawer: Drawer(
//         child: new ListView(
//               children: <Widget>[
//                 new UserAccountsDrawerHeader(
//                   accountName: new Text('Hiro'),
//                   accountEmail: new Text('hiro@gmail.com'),
//                   // decoration: new BoxDecoration(
//                   //   image: new DecorationImage(
//                   //     fit: BoxFit.fill,
//                   //    // image: AssetImage('img/estiramiento.jpg'),
//                   //   )
//                   // ),
//                 ),
//                 new Divider(),
//                 // new ListTile(
//                 //   title: new Text("Add data"),
//                 //   trailing: new Icon(Icons.fitness_center),
//                 //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(
//                 //     builder: (BuildContext context) => AddData(),
//                 //   )),
//                 // ),
//                 // new Divider(),
//                 // new ListTile(
//                 //   title: new Text("Mostrar listado"),
//                 //   trailing: new Icon(Icons.help),
//                 //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(
//                 //     builder: (BuildContext context) => ShowData(),
//                 //   )),
//                 // ),
//               ],
//             ),
//       ),
//     );
//   }
// }

