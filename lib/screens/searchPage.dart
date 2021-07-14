import 'package:IUT_Project/services/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
SharedPreferences sharedPreferences;
DataBaseHelper databaseHelper = new DataBaseHelper();

  checkLoginState() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
@override
  void initState() {
    checkLoginState();
    databaseHelper.getPost();
    initState();
  }
  
  
class SearchPageState extends SearchDelegate<String> {
  final list = [
    "Flutter",
    "PHP",
    "DataBase",
    "Authomatisme",
    "Math",
    "Algebre numerique",
    "seven",
    "Electronique",
    "nine",
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
  ];

  final recentlsit = [
    "PHP",
    "DataBase",
    "Authomatisme",
    "Math",
    "Algebre numerique",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
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
    final suggesionlist = query.isEmpty
        ? recentlsit
        : list.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.search),
        title: RichText(
            text: TextSpan(
                text: suggesionlist[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: suggesionlist[index].substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ])),
      ),
      itemCount: suggesionlist.length,
    );
    throw UnimplementedError();
  }
}
