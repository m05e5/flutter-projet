import 'dart:convert';

import 'package:IUT_Project/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
               setState(() {
        _isLoading = false;
      });
            },
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black)),
        centerTitle: true,
        title: Text('Sign in', style: TextStyle(color: Colors.black)),
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white
            // gradient: LinearGradient(
            //     colors: [Colors.blue, Colors.teal],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter),
            ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ))
            : ListView(
                children: <Widget>[
                  headerSection(),
                  textSection(),
                  buttonSection(),
                  // register(),
                ],
              ),
      ),

      // backgroundColor: Colors.white,
      // body: Center(
      //   child: ListView(
      //     shrinkWrap: true,
      //     padding: EdgeInsets.only(left: 24.0, right: 24.0),
      //     children: <Widget>[
      //       logo,
      //       SizedBox(height: 48.0),
      //       email,
      //       SizedBox(height: 8.0),
      //       password,
      //       SizedBox(height: 24.0),
      //       loginButton,
      //       forgotLabel
      //     ],
      //   ),
      // ),
    );
  }

  signIn(String matricule, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'matricule': matricule, 'password': pass};
    var jsonResponse = null;

    var response =
        await http.post("http://192.168.1.36:8000/api/users/login", body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      Map userInfo = jsonResponse['data'];
      print('------------------------');
      print(userInfo);
      print('------------------------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        focusElevation: 4.0,
        highlightElevation: 4.0,
        hoverElevation: 4.0,
        onPressed:
            // matriculeController.text == "" || passwordController.text == ""
            //     ? null
            //     :
            () {
          setState(() {
            _isLoading = true;
          });
          signIn(matriculeController.text, passwordController.text);
        },
        color: Colors.teal[300],
        child: Text("Sign In",
            style: TextStyle(
              color: Colors.white70,
            )),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }

  final TextEditingController matriculeController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).size.height * 0.18, 20, 20),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: matriculeController,
            cursorColor: Colors.white,
            // initialValue: '18i00933',
            // style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              labelText: 'Matricule',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Entrer votre matricule",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              // hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            autofocus: false,
            controller: passwordController,
            cursorColor: Colors.black,
            //initialValue: '12345678',
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Password',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Entrer votre mot de passe",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
      margin: EdgeInsets.only(top: 50.0),
      // padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Column(
        children: [
          Text("Welcome",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold)),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
                "Pour vous loger vous avez besoin de votre matricule d'etudiant",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                )),
          ),
        ],
      ),
    );
  }

  Container register() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 25.0),
      child: InkWell(
        child: Text('I dont have an account yet'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/signup');
        },
      ),
    );
  }
}
