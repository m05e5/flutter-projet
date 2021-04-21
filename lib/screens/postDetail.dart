import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:object_mapper/object_mapper.dart';

class Post_Detail extends StatefulWidget {
  final post_detail_id;
  final post_detail_title;
  final post_detail_description;
  final post_detail_imgUrl;
  final post_detail_is_resolved;

  Post_Detail({
    this.post_detail_id,
    this.post_detail_title,
    this.post_detail_description,
    this.post_detail_imgUrl,
    this.post_detail_is_resolved,
  });

  @override
  _Post_DetailState createState() => _Post_DetailState();
}

class _Post_DetailState extends State<Post_Detail>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello world'),
        actions: [],
        leading: null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: widget.post_detail_imgUrl != null
                  ? Container(
                      height: 200,
                      width: size.width,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            widget.post_detail_imgUrl,
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
                        children: [Text('No pic for this post')],
                      )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.post_detail_title),
            SizedBox(
              height: 10,
            ),
            Text(widget.post_detail_description),
          ],
        ),
      ),
    );
  }
}
