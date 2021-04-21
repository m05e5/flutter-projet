import 'dart:io';
import 'dart:convert';

import 'package:IUT_Project/screens/login.dart';
import 'package:IUT_Project/screens/postDetail.dart';
import 'package:IUT_Project/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:object_mapper/object_mapper.dart';
import 'package:popover/popover.dart';
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

  @override
  void initState() {
    checkLoginState();
    this.getPosts();
    super.initState();
  }

  CrudMethods crudMethods = CrudMethods();
  List<Posts> posts = [];

  QuerySnapshot postSnapshot;
  Widget PostList() {
    Firebase.initializeApp();
    child:
    ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, i) {
        Posts post = posts[i];
        return Column(
          children: [
            Card(
              elevation: 2,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  height: 100,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

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

  Future<List> getPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print(value);
    final response = await http.get(
      "http://192.168.1.101:8000/api/posts",
      headers: {'Accept': "application/json", 'Authorization': '$value'},
    );

    Map<String, dynamic> posts = json.decode(response.body);
    List<dynamic> data = posts["data"];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[150],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,

            child: new FutureBuilder(
                future: getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new ItemList(
                          list: snapshot.data,
                        )
                      : new Center(child: new CircularProgressIndicator());
                }),

            // child: ListView.builder(
            //     itemCount: posts.length,
            //     itemBuilder: (context, i) {
            //       Posts post = posts[i];
            //       return Column(
            //         children: <Widget>[
            //           Card(
            //             color: Colors.white,
            //             elevation: 1,
            //             child: FlatButton(
            //               padding: EdgeInsets.all(0),
            //               onPressed: () =>
            //                   Navigator.of(context).push(new MaterialPageRoute(
            //                       // here we are passing the value of the product detail page
            //                       builder: (context) => new Post_Detail(
            //                             post_detail_id: post.id,
            //                             post_detail_title: post.title,
            //                             post_detail_description:
            //                                 post.description,
            //                             post_detail_imgUrl: post.imgUrl,
            //                           ))),
            //               child: Container(
            //                 padding: EdgeInsets.all(8),
            //                 width: double.infinity,
            //                 height: 150,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10)),
            //                 child: Row(
            //                   children: <Widget>[
            //                     // Container(
            //                     //   height: double.infinity,
            //                     //   width: 120,
            //                     //   decoration: BoxDecoration(
            //                     //     borderRadius: BorderRadius.circular(10),
            //                     //     image: DecorationImage(
            //                     //       image: NetworkImage(post.imgUrl)
            //                     //     ),
            //                     //     border: Border.all(color: Colors.grey)
            //                     //   ),
            //                     // ),
            //                     SizedBox(
            //                       width: 10,
            //                     ),

            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: <Widget>[
            //                         SizedBox(
            //                           height: 50,
            //                         ),
            //                         Text(post.title,
            //                             style: TextStyle(
            //                                 fontSize: 30,
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.grey[700])),
            //                         SizedBox(
            //                           height: 4,
            //                         ),
            //                         SizedBox(
            //                           height: 4,
            //                         ),
            //                         Row(
            //                           children: <Widget>[
            //                             // Text('Avis: ', style: TextStyle(color: Colors.grey),),
            //                             Container(
            //                               width: size.width * 0.9,
            //                               child: Text(
            //                                 post.description,
            //                                 overflow: TextOverflow.ellipsis,
            //                                 style: TextStyle(
            //                                     color: Colors.grey,
            //                                     fontSize: 15),
            //                               ),
            //                             ),
            //                           ],
            //                         )
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //           SizedBox(
            //             height: 2,
            //           )
            //         ],
            //       );
            //     }),
            //
            //

            // padding: EdgeInsets.only(bottom: 90),
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
                      heightFactor: 0.6,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/create');
                        },
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.edit),
                        elevation: 0.1,
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
                                Navigator.pushReplacementNamed(context, '/');
                              }),
                          IconButton(
                              // color:Colors.white,
                              icon: Icon(Icons.search),
                              onPressed: () {}),
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
                              icon: Icon(Icons.notifications),
                              onPressed: () {}),
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

// class PostTile extends StatelessWidget {
//   String title, description, imgUrl, tags;
//   PostTile(
//       {@required this.title,
//       @required this.description,
//       @required this.imgUrl,
//       @required this.tags});
//   @override
//   Widget build(BuildContext context) {
//     Firebase.initializeApp();
//     return Container(
//       child: Stack(
//         children: [
//           Container(
//             height: 150,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(6)),
//           ),
//           Container(
//               child: Column(
//             children: [
//               Text(title),
//             ],
//           ))
//         ],
//       ),
//     );
//   }
// }

class ItemList extends StatelessWidget {
  final List list;

  const ItemList({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var fin = list.length - 1;
    print(fin);
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: new ListView.builder(
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 1,
                    child: FlatButton(
                        onPressed: () =>
                            Navigator.of(context).push(new MaterialPageRoute(
                                // here we are passing the value of the product detail page
                                builder: (context) => new Post_Detail(
                                      post_detail_id: list[i]['id'],
                                      post_detail_title:
                                          list[i]['title'].toString(),
                                      post_detail_description:
                                          list[i]['description'].toString(),
                                      post_detail_imgUrl:
                                          list[i]['imgUrl'].toString(),
                                    ))),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          width: double.infinity,
                          height: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(list[i]['user']['name']
                                              .toString()),
                                          Text(list[i]['created_at']
                                              .toString()
                                              .substring(0, 10)),
                                        ],
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Text(list[i]['user']['name'][0]
                                              .toString())),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    width: size.width * 0.85,
                                    child: Text(list[i]['title'].toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700])),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: size.width * 0.85,
                                        child: Text(
                                          list[i]['description'].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                      )
                                    ],
                                  )
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
              // return new Container(
              //     child: new GestureDetector(
              //   onTap: () => Navigator.of(context).push(
              //     new MaterialPageRoute(
              //         // here we are passing the value of the product detail page
              //         builder: (context) => new Post_Detail(
              //               post_detail_id: list[i]['id'],
              //               post_detail_title: list[i]['title'].toString(),
              //               post_detail_description:
              //                   list[i]['description'].toString(),
              //               post_detail_imgUrl: list[i]['imgUrl'].toString(),
              //             )),
              //   ),
              //   child: Container(
              //     padding: EdgeInsets.all(8),
              //     width: double.infinity,
              //     height: 150,
              //     decoration:
              //         BoxDecoration(borderRadius: BorderRadius.circular(10)),
              //     child: Row(
              //       children: <Widget>[
              //         // Container(
              //         //   height: double.infinity,
              //         //   width: 120,
              //         //   decoration: BoxDecoration(
              //         //     borderRadius: BorderRadius.circular(10),
              //         //     image: DecorationImage(
              //         //       image: NetworkImage(post.imgUrl)
              //         //     ),
              //         //     border: Border.all(color: Colors.grey)
              //         //   ),
              //         // ),
              //         SizedBox(
              //           width: 10,
              //         ),

              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             SizedBox(
              //               height: 50,
              //             ),
              //             Text(list[i]['title'].toString(),
              //                 style: TextStyle(
              //                     fontSize: 30,
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.grey[700])),
              //             SizedBox(
              //               height: 4,
              //             ),
              //             SizedBox(
              //               height: 4,
              //             ),
              //             Row(
              //               children: <Widget>[
              //                 // Text('Avis: ', style: TextStyle(color: Colors.grey),),
              //                 Container(
              //                   width: size.width * 0.9,
              //                   child: Text(
              //                     list[i]['description'].toString(),
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(
              //                         color: Colors.grey, fontSize: 15),
              //                   ),
              //                 ),
              //               ],
              //             )
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // ));
            }),
      ),
    );
  }
}

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
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
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
