import 'package:IUT_Project/services/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  SharedPreferences sharedPreferences;
  DataBaseHelper databaseHelper = new DataBaseHelper();

  myData() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    myData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        //leading: BackButton(),
        backgroundColor: Colors.teal[300],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:size.height*0.05),
            Container(
              padding: EdgeInsets.all(10.0),
              width: size.width * 0.5,
              height: size.width * 0.5,
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.white,
                ),
                child: Text('H'),
            ),

        ],),
        )
      
    );
  }
}