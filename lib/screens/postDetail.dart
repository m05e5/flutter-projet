import 'package:IUT_Project/services/databasehelper.dart';
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

  DataBaseHelper databaseHelper = new DataBaseHelper();
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //print("---------------------------------------------------------------------****************************${widget.post_detail_imgUrl}");
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
                
                color:Colors.teal[300],
                child: Text('Ask Question', style: TextStyle(color: Colors.white)),
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
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            widget.post_detail_imgUrl,
                            fit: BoxFit.cover,
                          )),
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
          ],
        ),
      ),
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
          child: new ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: list == null ? 0 : list.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      list[i]['user']['imgProfile'] == null
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.teal[300],
                                  borderRadius: BorderRadius.circular(25)),
                              child:
                                  Text(list[i]['user']['name'][0].toString()))
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
                      Container(
                          width: size.width * 0.6,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(list[i]['content'].toString())),
                    ],
                  ),
                );
              })),
    );
  }
}
