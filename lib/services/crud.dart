import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:object_mapper/object_mapper.dart';

class CrudMethods {
  Future<void> addData(postData) async {
    Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection("posts")
        .add(postData)
        .catchError((e) {
      print(e);
    });
  }

  getPosts() async {
    return await FirebaseFirestore.instance.collection("posts").get();
  }

  getTags() async {
    return await FirebaseFirestore.instance.collection("tags").get();
  }
}

class Posts with Mappable {
  String id;
  String title;
  String description;
  String imgUrl;

  static final table_name = "posts";
  static final label_id = "id";
  static final label_title = "title";
  static final label_imgUrl = "imgUrl";
  static final label_description = "desc";

  Posts({this.id, this.title, this.imgUrl, this.description});

  @override
  void mapping(Mapper map) {
    map('id', id, (v) => id = v);
    map('title', title, (v) => title = v);
    map('desc', description, (v) => description = v);
    map('imgUrl', imgUrl, (v) => imgUrl = v);
  }

  @override
  String toString() {
    return 'post{id: $id,title: $title,description: $description,imgUrl: $imgUrl,}';
  }
}
