import 'package:IUT_Project/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:object_mapper/object_mapper.dart';
import 'package:popover/popover.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
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
                onPressed: (){},
                child: Container(
                   padding: EdgeInsets.all(8),
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                              Text(post.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]
                                      )
                                  ),
                  ],),
                ),
               
                ),
            )
          ],
        );
      },
    );
  }

  // Widget PostList() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         postSnapshot != null
  //             ? ListView.builder(
  //                 itemCount: postSnapshot.docs.length,
  //                 shrinkWrap: true,
  //                 itemBuilder: (context, index) {
  //                   return PostTile(
  //                     title: postSnapshot.docs[index].data()['title'],
  //                     description: postSnapshot.docs[index].data()['desc'],
  //                     tags: postSnapshot.docs[index].data()['tags'],
  //                     imgUrl: postSnapshot.docs[index].data()['imgUrl'],
  //                   );
  //                 })
  //             : Container(
  //                 alignment: Alignment.center,
  //                 child: CircularProgressIndicator(),
  //               )
  //       ],
  //     ),
  //   );
  // }
  Future<List<Posts>> getPosts() async {
    CollectionReference ref =
        FirebaseFirestore.instance.collection(Posts.table_name);
    QuerySnapshot snapshot = await ref.get();
    snapshot.docs.forEach((element) {
      setState(() {
        posts.add(Mapper.fromJson(element.data()).toObject<Posts>());
      });
    });
    print("===========================================${posts.toString()}");
    return posts;
  }

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[150],
      body: Stack(
        children: [
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
                              icon: Icon(Icons.home),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/');
                              }),
                          IconButton(
                              icon: Icon(Icons.search), onPressed: () {}),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
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
