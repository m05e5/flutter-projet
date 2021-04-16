import 'package:IUT_Project/screens/login.dart';
import 'package:IUT_Project/screens/postDetail.dart';
import 'package:IUT_Project/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    if (sharedPreferences.getString('token') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }
    @override
  void initState() {
    checkLoginState();
   getPosts();
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
    snapshot.docs.forEach((element){
      setState(()=>posts.add(Mapper.fromJson(element.data()).toObject<Posts>())
      );
    });
    print("===========================================${posts.toString()}");
    return posts;
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
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.black)),
          ),
        ],),
      body: Stack(
        children: [
          Container(
            height: size.height,
            child:ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, i){
                Posts post = posts[i];
                return Column(
                  children: <Widget>[
                    Card(
                      color: Colors.white,
                      elevation: 1,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: ()
                        => Navigator.of(context).push(new MaterialPageRoute(
               // here we are passing the value of the product detail page
                builder: (context) => new Post_Detail( 
                  post_detail_id:post.id,
                  post_detail_title:post.title ,
                  post_detail_description:post.description,
                  post_detail_imgUrl:post.imgUrl,
                ))),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            children: <Widget>[
                              // Container(
                              //   height: double.infinity,
                              //   width: 120,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     image: DecorationImage(
                              //       image: NetworkImage(post.imgUrl)
                              //     ),
                              //     border: Border.all(color: Colors.grey)
                              //   ),
                              // ),
                              SizedBox(width: 10,),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 50,),
                                  Text(post.title,
                                      style: TextStyle(
                                        fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]
                                      )
                                  ),
                                  SizedBox(height: 4,),
                                 
                                  SizedBox(height: 4,),
                                  Row(
                                    children: <Widget>[
                                      // Text('Avis: ', style: TextStyle(color: Colors.grey),),
                                      Container(
                                        width: size.width*0.9,
                                        child: Text(post.description,
                                        overflow: TextOverflow.ellipsis,
                                         style: TextStyle(
                                           color: Colors.grey,
                                           fontSize: 15
                                           ),
                                         ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],  
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2,)
                  ],
                 
                );
              }
            )   ,
            padding: EdgeInsets.only(bottom: 90),    
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
                              icon: Icon(Icons.home),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/');
                              }),
                          IconButton(
                              icon: Icon(Icons.search), onPressed: () {
                             
                              }),
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
