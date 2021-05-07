import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:IUT_Project/services/databasehelper.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      body: new FutureBuilder(
          future: databaseHelper.getMyData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            print(
                '-------------------------------------------${snapshot.data}');
            return snapshot.hasData
                ? ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      // Text(snapshot.data['data']['name']),
                      // Text(snapshot.data['data']['imgProfile']),
                      // Text(snapshot.data['data']['email']),
                      // Text(snapshot.data['data']['matricule']),
                      // Text(snapshot.data['data']['role']),
                      // Text(snapshot.data['data']['filiere']),
                      Stack(alignment: Alignment.center, children: [
                        CustomPaint(
                          child: Container(
                            width: size.width,
                            height:size.width,
                          ),
                          painter:HeaderCurvedContainer(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Profile',
                                  style: TextStyle(
                                      fontSize: 35,
                                      letterSpacing: 1.5,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: size.width * 0.5,
                              height: size.width * 0.5,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 5),
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    snapshot.data['data']['imgProfile'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Positioned(
                        //   bottom: 50,
                        //   right: size.width * 0.3,
                        //   child: CircleAvatar(
                        //     backgroundColor: Colors.black54,
                        //     child: IconButton(
                        //       icon: Icon(Icons.add_a_photo),
                        //       color: Colors.white,
                        //       onPressed: () {},
                        //     ),
                        //   ),
                        // )
                      ]),
                    ],
                  )
                // ? new ItemList(
                //     list: snapshot.data,
                //   )
                : new Center(child: new CircularProgressIndicator());
          }),
    );
  }
}

/*
 list[i]['user']['imgProfile'] == null
                                  ? Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.teal[300],
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Text(list[i]['user']['name'][0]
                                              .toString())),
                                    )
                                  : Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image.network(
                                              list[i]['user']['imgProfile'],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
 */
class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.teal[300];
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 275, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
