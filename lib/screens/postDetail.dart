import 'dart:io';

import 'package:IUT_Project/screens/searchPage.dart';
import 'package:IUT_Project/services/databasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:object_mapper/object_mapper.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Post_Detail extends StatefulWidget {
  final post_detail_id;
  final post_detail_title;
  final post_detail_description;
  final post_detail_imgUrl;
  final post_detail_is_resolved;
  final post_detail_tags;
  final post_detail_user;

  Post_Detail({
    this.post_detail_id,
    this.post_detail_title,
    this.post_detail_description,
    this.post_detail_imgUrl,
    this.post_detail_is_resolved,
    this.post_detail_tags,
    this.post_detail_user,
  });

  @override
  _Post_DetailState createState() => _Post_DetailState();
}

class _Post_DetailState extends State<Post_Detail>
    with SingleTickerProviderStateMixin {
  String content;
  TabController _tabController;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //print("----------------------****************************${widget.post_detail_imgUrl}");
    final imgval = widget.post_detail_imgUrl.toString();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(children: [
                Image.asset(
                  'assets/IUT2.png',
                  fit: BoxFit.cover,
                  width: 25,
                  height: 25,
                ),
                Text(
                  'GoAsk',
                  style: TextStyle(color: Colors.black),
                )
              ]),
            ),
          ],
        ),
        actions: [],
        leading: null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create');
                },
                color: Colors.teal[300],
                child:
                    Text('Ask Question', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.post_detail_title,
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800])),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [],
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 9,
              ),
              child: Text(widget.post_detail_description),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: imgval != 'null'
                  ? Container(
                      height: 200,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      //: new Center(child: new CircularProgressIndicator());
                      child: FullScreenWidget(
                        backgroundColor: Colors.grey[200],
                        child: InteractiveViewer(
                          child: Center(
                            child: Hero(
                              tag: 'smallImage',
                              child: ClipRRect(
                                  child: Image.network(
                                widget.post_detail_imgUrl,
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ), /*Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(6)),
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('No pic for this post')],
                      )),*/
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                    height: 25,
                    width: size.width * 0.85,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.post_detail_tags.length,
                        itemBuilder: (context, j) {
                          return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                widget.post_detail_tags[j]['name'].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ));
                        }))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.grey[300],
              height: size.height * 0.5,
              child: new FutureBuilder(
                  future:
                      databaseHelper.getCommentsPerPosts(widget.post_detail_id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new CommentList(
                            list: snapshot.data,
                          )
                        : new Center(child: new CircularProgressIndicator());
                  }),
            ),
            Container(alignment: Alignment.topRight, child: commentBtn()),
          ],
        ),
      ),
    );
  }

  RaisedButton commentBtn() {
    return RaisedButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) =>
              CommentDialogContent(post_detail_id: widget.post_detail_id)),
      color: Colors.teal[300],
      child: Text('Answer', style: TextStyle(color: Colors.white)),
    );
  }
}

class CommentDialogContent extends StatefulWidget {
  final post_detail_id;
  const CommentDialogContent({Key key, this.post_detail_id}) : super(key: key);

  @override
  _CommentDialogContentState createState() => _CommentDialogContentState();
}

class _CommentDialogContentState extends State<CommentDialogContent> {
  File selectedImage;
  final picker = ImagePicker();
  bool _isLoading = false;
  final TextEditingController contentController = new TextEditingController();
  DataBaseHelper databaseHelper = new DataBaseHelper();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadComment() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        final Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("commentsImages")
            .child("${randomAlphaNumeric(9)}.jpg");
        final UploadTask task = firebaseStorageRef.putFile(selectedImage);
        var downloadUrl = await (await task).ref.getDownloadURL();
        print("this is url $downloadUrl");
        int data = await databaseHelper.createComment(
            contentController.text.trim(),
            widget.post_detail_id.toString(),
            downloadUrl);
        print('321321321313321 $data ');
        print(" $contentController ------- $downloadUrl");
        // Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        print('error: $e');
      }

      ///uploading image to firebase storage

    } else {
      int data = await databaseHelper.createComment(
          contentController.text.trim(), widget.post_detail_id.toString());

      print("$contentController----");
      print(
          "******************************************************************3");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Answer the question'),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: selectedImage != null
                    ? Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              selectedImage,
                              fit: BoxFit.cover,
                            )),
                      )
                    : Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(6)),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo),
                            Text('Click here to add a photo')
                          ],
                        )),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: "desc",
                  border: OutlineInputBorder(),
                ),
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                // onChanged: (val) {
                //   desc = val;
                // },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            uploadComment();
            Navigator.pop(context, null);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class CommentList extends StatelessWidget {
  final List list;

  const CommentList({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scrollbar(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: list.length == 0
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text('No Answer Yet'),
                      Text('Be the first to answer this question'),
                    ],
                  ),
                )
              : new ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    print(
                        " ----------------------------------5555555555555$list ");
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          list[i]['user']['imgProfile'] == null
                              ? Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.teal[300],
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Text(
                                      list[i]['user']['name'][0].toString()))
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: 6),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.network(
                                        list[i]['user']['imgProfile'],
                                        fit: BoxFit.cover,
                                      )),
                                ),
                          Material(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: Column(
                                children: [
                                  Container(
                                      width: size.width * 0.6,
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          //    color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child:
                                          Text(list[i]['content'].toString())),
                                  list[i]['imgUrl'] == null
                                      ? SizedBox(
                                          width: 2,
                                        )
                                      : GestureDetector(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 6),
                                            //height: size.width*0.7,
                                            width: size.width * 0.6,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: FullScreenWidget(
                                              child: InteractiveViewer(
                                                child: Center(
                                                    // borderRadius: BorderRadius.circular(25),
                                                    child: ClipRRect(
                                                  child: Image.network(
                                                    list[i]['imgUrl'],
                                                    fit: BoxFit.fill,
                                                  ),
                                                )),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
    );
  }

  //commentBtn() {}
}
