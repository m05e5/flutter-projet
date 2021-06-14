import 'package:flutter/material.dart';

class SearchPageState extends SearchDelegate<String> {
  final list = [
    "sdf0",
    "sdf1",
    "sdf2",
    "sdf3",
    "sdf4",
    "sdf5",
    "sdf6",
    "sdf7",
    "qsdqsddfdzg",
    "qsdqsddfg",
    "qsdqsd9",
    "qsdqsd8",
    "qsdqsd7",
    "qsdqsd6",
    "qsdqsd5",
    "qsdqsd4",
  ];

  final recentlsit = [
    "qsdqsddfgdg",
    "qsdqsdtretr",
    "qsdqsd3",
    "qsdqsd2",
    "qsdqsd1",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: Icon(Icons.clear))];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggesionlist = query.isEmpty ? recentlsit : list;
    return ListView.builder(itemBuilder: (context, index) => ListTile(
      leading: null,
    ));
    throw UnimplementedError();
  }
}
