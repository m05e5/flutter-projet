import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
   int _page = 2;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // body: Container(
      //   color: Colors.grey[70],
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[ Text("I'm a hero", style: TextStyle(color:Colors.black),), 
           
      //        ]),
      // ),
      body: Container(
          color:Colors.grey[70],
          child: Center(
            child: Column(
              children: <Widget>[
                Text(_page.toString(), textScaleFactor: 10.0),
                RaisedButton(
                  child: Text('Go To Page of index 2'),
                  onPressed: () {
                    final CurvedNavigationBarState navBarState =
                        _bottomNavigationKey.currentState;
                    navBarState.setPage(2);
                  },
                )
              ],
            ),
          ),
          ),
      bottomNavigationBar: CurvedNavigationBar( 
        index: 2,
        key: _bottomNavigationKey,
        color: Colors.white,
        backgroundColor: Colors.grey[70],
        buttonBackgroundColor: Colors.orangeAccent[400],
        height: 70,
          items: <Widget>[
            Icon(
              Icons.search,
              size: 20,
              color: Colors.black,
            ),
              Icon(
              Icons.data_usage_rounded,
              size: 20,
              color: Colors.black,
            ),
            Icon(
              Icons.add,
              size: 20,
              color: Colors.black,
            ),
            Icon(
              Icons.card_travel,
              size: 20,
              color: Colors.black,
            ),
             Icon(
              Icons.list,
              size: 20,
              color: Colors.black,
            ),
             
            
          ],
          animationCurve: Curves.bounceInOut,
          animationDuration: Duration(milliseconds:200),
          onTap: (index) {
            debugPrint("current index is $index");

          }),
    );
  }
}
