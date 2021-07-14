import 'package:IUT_Project/screens/login.dart';
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
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.black)),
          ),
        ],
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: databaseHelper.getMyData(),
         builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView(
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
                    ]
                    ): new Center(child: new CircularProgressIndicator());
                    
            }
        
    
        )
      
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
              labelText: 'Nom',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Entrer votre matricule",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              // hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 20.0),
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
          SizedBox(height: 20.0),
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

//  Container buttonSection() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 40.0,
//       padding: EdgeInsets.symmetric(horizontal: 20.0),
//       margin: EdgeInsets.only(top: 15.0),
//       child: RaisedButton(
//         focusElevation: 4.0,
//         highlightElevation: 4.0,
//         hoverElevation: 4.0,
//         onPressed:
//             // matriculeController.text == "" || passwordController.text == ""
//             //     ? null
//             //     :
//             () {
//           setState(() {
//             _isLoading = true;
//           });
//           signIn(matriculeController.text, passwordController.text);
//         },
//         color: Colors.teal[300],
//         child: Text("Sign In",
//             style: TextStyle(
//               color: Colors.white70,
//             )),
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
//       ),
//     );
//   }


}

// Container(
//               padding: EdgeInsets.all(10.0),
//               width: size.width * 0.5,
//               height: size.width * 0.5,
//               decoration: BoxDecoration(
//                 border:
//                     Border.all(color: Colors.white, width: 5),
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//                 ),
//                 child: Text('H'),
//             ),