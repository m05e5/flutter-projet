import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  List<dynamic> Posts(List<dynamic> data) {
    List<dynamic> post = [];
    for (int i = 0; i < data.length; i++) {
      var e = data[i];
      post.add(e);
    }
    return post;
  }

  // final posts =
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {});
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
