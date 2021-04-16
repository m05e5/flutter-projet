import 'dart:convert';

import 'package:IUT_Project/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SignUp extends StatefulWidget {

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
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
                ],
              ),
      ),
    );
  }

  register(String name, pseudo, email, matricule, pass, filiere) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': name,
      'pseudo': pseudo,
      'email': email,
      'matricule': matricule,
      'password': pass,
      'filiere': filiere
    };
    var jsonResponse = null;

    var response = await http
        .post("http://192.168.1.36:8000/api/users/register", body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
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

  Container buttonSection(){
     return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed:
            nameController.text == "" ||
           pseudoController.text == "" ||
             matriculeController.text == "" ||
             passwordController.text == ""  ||
            filiereController.text == ""
                ? null
                : () {
                    setState(() {
                      _isLoading = true;
                    });
                    register(
                      nameController.text,
                      pseudoController.text,
                      emailController.text,
                      matriculeController.text,
                      passwordController.text,
                      filiereController.text,
                    );
                  },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Register", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController pseudoController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController matriculeController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController filiereController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
             TextFormField(
            controller: nameController,
            cursorColor: Colors.white,
            // initialValue: '18i00933',
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle_rounded, color: Colors.white70),
              hintText: "Name",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 20.0),
             TextFormField(
            controller: pseudoController,
            cursorColor: Colors.white,
            // initialValue: '18i00933',
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle_outlined, color: Colors.white70),
              hintText: "Pseudo",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 20.0),
             TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            // initialValue: '18i00933',
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: matriculeController,
            cursorColor: Colors.white,
            // initialValue: '18i00933',
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Matricule",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            autofocus: false,
            controller: passwordController,
            cursorColor: Colors.white,
            //initialValue: '12345678',
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          SizedBox(height: 20.0),
             TextFormField(
            controller: filiereController,
            cursorColor: Colors.white,
            // initialValue: '18i00933',
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Filiere",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Register",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }
}
