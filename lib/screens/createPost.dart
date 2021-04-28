import 'dart:io';

import 'package:IUT_Project/services/crud.dart';
import 'package:IUT_Project/services/databasehelper.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String title, desc;
  File selectedImage;
  bool _isLoading = false;

  CrudMethods crudMethods = new CrudMethods();
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
        databaseHelper.createPost(titleController.text.trim(),
            descriptionController.text.trim(), downloadUrl);
        Navigator.pushReplacementNamed(context, '/home');
        print("$titleController---- $descriptionController ------- $downloadUrl");

        // crudMethods.addData(postMap).then((result) {
        //   Navigator.pushReplacementNamed(context, '/');
        // });
      } catch (e) {
        print(e);
      }

      ///uploading image to firebase storage

    } else {
      databaseHelper.createPost(titleController.text.trim(),
            descriptionController.text.trim());
        Navigator.pushReplacementNamed(context, '/home');
        print("$titleController---- $descriptionController");
      print(
          "******************************************************************3");
    }
  }

  DataBaseHelper databaseHelper = new DataBaseHelper();

  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "IUT",
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            Text(
              "_Project",
              style: TextStyle(
                fontSize: 22,
                color: Colors.blue,
              ),
            )
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
