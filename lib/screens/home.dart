import 'dart:io';
import 'dart:convert';

import 'package:IUT_Project/main.dart';
import 'package:IUT_Project/screens/login.dart';
import 'package:IUT_Project/screens/postDetail.dart';
import 'package:IUT_Project/screens/searchPage.dart';
import 'package:IUT_Project/services/crud.dart';
import 'package:IUT_Project/services/databasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:object_mapper/object_mapper.dart';
import 'package:popover/popover.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences sharedPreferences;

  checkLoginState() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  DataBaseHelper databaseHelper = new DataBaseHelper();
  @override
  void initState() {
    checkLoginState();
    this.databaseHelper.getPost();
    super.initState();
  }

  CrudMethods crudMethods = CrudMethods();
  List<Posts> posts = [];

  QuerySnapshot postSnapshot;
  // Widget PostList() {
  //   Firebase.initializeApp();
  //   child:
  //   ListView.builder(
  //     itemCount: posts.length,
  //     itemBuilder: (context, i) {
  //       Posts post = posts[i];
  //       return Column(
  //         children: [
  //           Card(
  //             elevation: 2,
  //             child: FlatButton(
  //               padding: EdgeInsets.all(0),
  //               onPressed: () {},
  //               child: Container(
  //                 padding: EdgeInsets.all(8),
  //                 width: double.infinity,
  //                 height: 100,
  //                 decoration:
  //                     BoxDecoration(borderRadius: BorderRadius.circular(10)),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(post.title,
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.grey[700])),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<List<Posts>> getPosts() async {
  //   CollectionReference ref =
  //       FirebaseFirestore.instance.collection(Posts.table_name);
  //   QuerySnapshot snapshot = await ref.get();
  //   snapshot.docs.forEach((element){
  //     setState(()=>posts.add(Mapper.fromJson(element.data()).toObject<Posts>())
  //     );
  //   });
  //   print("===========================================${posts.toString()}");
  //   return posts;
  // }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Stack(
        children: [
          Container(
            height: size.height,
            child: RefreshIndicator(
              onRefresh: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) => Home(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
                return Future.value(false);
              },
              child: new FutureBuilder(
                  future: databaseHelper.getPost(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new ItemList(
                            list: snapshot.data,
                          )
                        : new Center(child: new CircularProgressIndicator());
                  }),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size.width,
                height: 80,
                color: Colors.grey[150],
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(size.width, 80),
                      painter: BNBCustomePainter(),
                    ),
                    Center(
                      heightFactor: 0.7,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/create');
                        },
                        backgroundColor: Colors.teal[300],
                        child: Icon(Icons.edit),
                        elevation: 1,
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              // color:Colors.white,
                              icon: Icon(Icons.home),
                              onPressed: () {
                              //  Navigator.pushReplacementNamed(context, '/');
                              Share.share(
                                    'check out my website https://example.com',
                                    subject: 'Look what I made!');

                              }),
                          IconButton(
                              // color:Colors.white,
                              icon: Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                              context: context, delegate: SearchPageState());
                              }),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
                              // color:Colors.white,
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                showPopover(
                                  context: context,
                                  bodyBuilder: (context) => const ListItems(),
                                  onPop: () => print('Popover was popped!'),
                                  direction: PopoverDirection.top,
                                  width: 200,
                                  height: 400,
                                  arrowHeight: 15,
                                  arrowWidth: 30,
                                );
                              }),
                          IconButton(
                              // color:Colors.white,
                              icon: Icon(Icons.account_circle),
                              onPressed: () {
                                Navigator.pushNamed(context, '/profilePage');
                                // Navigator.pushReplacementNamed(
                                //     context, '/profilePage');
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

//
//
//
//
//
//
//

class ItemList extends StatelessWidget {
  final List list;

  const ItemList({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var fin = list.length;
    int num = 0;
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: new ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (context, i) {
              num += 1;
              // print(list[i]);
              // print(fin);
              return Column(
                children: [
                  Card(
                    margin: num == fin
                        ? EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 85.0)
                        : EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 5.0),
                    color: Colors.white,
                    elevation: 1,
                    child: FlatButton(
                        onPressed: () => Navigator.of(context).push(
                            new MaterialPageRoute(
                                // here we are passing the value of the product detail page
                                builder: (context) => new Post_Detail(
                                    post_detail_id: list[i]['id'],
                                    post_detail_title:
                                        list[i]['title'].toString(),
                                    post_detail_description:
                                        list[i]['description'].toString(),
                                    post_detail_imgUrl:
                                        list[i]['imgUrl'].toString(),
                                    post_detail_tags: list[i]['tags'],
                                    post_detail_user: list[i]['user']))),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(6, 15, 0, 18),
                          //height: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(list[i]['user']['name'].toString()),
                                      Text(
                                        list[i]['created_at']
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  //SizedBox(width: size.width * 0.43),

                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    // width: size.width * 0.87,
                                    child: Text(list[i]['title'].toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700])),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  // Row(
                                  //   children: [
                                  Container(
                                      height: 25,
                                      width: size.width * 0.85,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: list[i]['tags'].length,
                                          itemBuilder: (context, j) {
                                            return Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 3),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Text(
                                                  list[i]['tags'][j]['name']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ));
                                          }))
                                  //   ],
                                  // )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                  list[i] == fin
                      ? SizedBox(
                          height: 160,
                        )
                      : SizedBox(
                          height: 1,
                        )
                ],
              );
            }),
      ),
    );
  }
}

//
//
//
//
//
//
//
//

class ListItems extends StatelessWidget {
  const ListItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            InkWell(
              onTap: () {
                print('GestureDetector was called on Entry A');
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry A')),
              ),
            ),
            const Divider(),
            Container(
              height: 50,
              color: Colors.amber[200],
              child: const Center(child: Text('Entry B')),
            ),
          ],
        ),
      ),
    );
  }
}



class BNBCustomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 00, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 00, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
