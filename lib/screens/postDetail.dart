import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:object_mapper/object_mapper.dart';

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
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
        title: Text('Hello world', style: TextStyle(color:Colors.black),),
        actions: [],
        leading: null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(widget.post_detail_title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700])),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: widget.post_detail_imgUrl != null
                  ? Container(
                      height: 200,
                      width: size.width,
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            widget.post_detail_imgUrl,
                            fit: BoxFit.cover,
                          )),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      height: 200,
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
            Text(widget.post_detail_description),

  SizedBox(
              height: 30,
            ),
             Row(
                                    children: [
                                      Container(
                                          height: 20,
                                          width: size.width * 0.85,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: widget.post_detail_tags.length,
                                              itemBuilder: (context, j) {
                                                return Container(
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[400],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Text(
                                                      widget.post_detail_tags[j]['name']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13),
                                                    ));

                                                /* Text(
                                                  list[i]['tags'][j]['name']
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                );*/
                                              }))
                                    ],
                                  )
          ],
        ),
      ),
    );
  }
}
