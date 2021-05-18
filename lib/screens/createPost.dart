import 'dart:io';

import 'package:IUT_Project/services/crud.dart';
import 'package:IUT_Project/services/databasehelper.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String title, desc;
  File selectedImage;
  bool _isLoading = false;
  List<bool> _isSelected = [];
  int numTag;
  List<int> tChoosed = [];

  CrudMethods crudMethods = new CrudMethods();
  SharedPreferences sharedPreferences;
  DataBaseHelper databaseHelper = new DataBaseHelper();
  myTag() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  final picker = ImagePicker();

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

  uploadPost() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        final Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("postImages")
            .child("${randomAlphaNumeric(9)}.jpg");
        final UploadTask task = firebaseStorageRef.putFile(selectedImage);
        var downloadUrl = await (await task).ref.getDownloadURL();
        print("this is url $downloadUrl");

        // Map<String, String> postMap = {
        //   "imgUrl": downloadUrl,
        //   "title": title,
        //   "desc": desc
        // };
        int data = await databaseHelper.createPost(titleController.text.trim(),
            descriptionController.text.trim(), downloadUrl);
            print(data);
        print(
            "$titleController---- $descriptionController ------- $downloadUrl");
        for (int j; j < _isSelected.length; j++) {
          var v = _isSelected[j];
          if (v == true) {
            tChoosed.add(j);
          } else {
            print('ya pas');
          }
        }
        for (int k = 0; k < tChoosed.length; k++) {
          databaseHelper.createPostWithTag(data, tChoosed[k]);
        }

        Navigator.pushReplacementNamed(context, '/home');

        // crudMethods.addData(postMap).then((result) {
        //   Navigator.pushReplacementNamed(context, '/');
        // });
      } catch (e) {
        print(e);
      }

      ///uploading image to firebase storage

    } else {
      for (int j = 0; j < _isSelected.length; j++) {
        var v = _isSelected[j];
        if (v == true) {
          tChoosed.add(j);
        }
      }
      print(_isSelected);
      int data = await databaseHelper.createPost(
          titleController.text.trim(), descriptionController.text.trim());
      print(data);

      for (int k = 0; k < tChoosed.length; k++) {
        databaseHelper.createPostWithTag(data, tChoosed[k]);
      }
      print("$titleController---- $descriptionController");
      print(
          "******************************************************************3");

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  @override
  void initState() {
    myTag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData.fallback(),
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.pushReplacementNamed(context, '/home');
        //   },
        //   //https://www.youtube.com/watch?v=8kcNYoaLctI
        //   child: Icon(
        //     Icons.chevron_left_rounded,
        //     color: Colors.black,
        //   ),
        // ),
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
        actions: [
          GestureDetector(
            onTap: () {
              uploadPost();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.send_outlined, color: Colors.black)),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: selectedImage != null
                          ? Container(
                              height: 150,
                              width: size.width,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    selectedImage,
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(6)),
                              width: size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo),
                                  Text('Click here to add a photo')
                                ],
                              )),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: "Title",
                            ),
                            onChanged: (val) {
                              title = val;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              hintText: "desc",
                              border: OutlineInputBorder(),
                            ),
                            minLines:
                                6, // any number you need (It works as the rows for the textarea)
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (val) {
                              desc = val;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FutureBuilder(
                              future: databaseHelper.getTags(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? new Wrap(
                                        spacing: 5.0,
                                        runSpacing: 3.0,
                                        children: getTag(snapshot.data))
                                    /* child: ListView.builder(
                      shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, j) {
                              return 
                                  Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(horizontal: 6),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Text(
                                        snapshot.data[j]['name'].toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,),
                                      ));

                            })*/

                                    : new Center(
                                        child: new CircularProgressIndicator());
                              }),
                        ],
                      ),
                    ),
                    /*
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
                     */
                  ],
                ),
              ),
            ),
    );
  }

  List<FilterChip> getTag(List<dynamic> data) {
    List<FilterChip> list = [];
    for (int i = 0; i < data.length; i++) {
      var e = data[i];
      if (_isSelected.length < data.length) {
        _isSelected.add(false);
      }
      list.add(
        FilterChip(
          label: Text(e['name']),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
          backgroundColor: Colors.grey[300],
          onSelected: (selected) {
            setState(() {
              _isSelected[i] = selected;
            });
            // print(i);
            // print(_isSelected);
          },
          selected: _isSelected[i],
          selectedColor: Colors.teal[300],
        ),
      );
    }

    return list;
  }
}

//
