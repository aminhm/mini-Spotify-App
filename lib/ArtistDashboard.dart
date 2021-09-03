import 'package:db_project/Playlist.dart';
import 'package:db_project/artistProfile.dart';
import 'package:db_project/search.dart';
import 'package:db_project/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class ArtistDashboard extends StatefulWidget{
  final Map<String, dynamic> artistDetail;
  final Database database;
  ArtistDashboard({Key key,this.artistDetail,this.database}) : super(key: key) ;
  @override 
  _ArtistDashboard createState() => _ArtistDashboard();
}

class _ArtistDashboard extends State<ArtistDashboard>{
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int currentIndex=0;
  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _navigatorKey.currentState.pushReplacementNamed("قطعات");
        break;
      case 1:
        _navigatorKey.currentState.pushReplacementNamed("حساب کاربری");
        break;
    }
    setState(() {
      currentIndex = tabIndex;
    });
  }
  Widget _bottomNavigationBar(){
    return BottomNavigationBar(
      backgroundColor: Colors.black,
        onTap: _onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.indigoAccent,unselectedItemColor: Colors.pink,items: 
      [BottomNavigationBarItem(icon: Icon(Icons.album,size: 35,),title: Text("قطعات",style: TextStyle(fontSize: 18),)
      )
      , BottomNavigationBarItem(icon: Icon(IconData(0xe9a9,fontFamily: "Artist"),size: 35,),title: Text("حساب کاربری",style: TextStyle(fontSize: 18),))
      ]
      );
  }
   Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "حساب کاربری":
        return MaterialPageRoute(builder: (context) => ArtistProfile(database: widget.database,artistDetail: widget.artistDetail,));
      default:
        return MaterialPageRoute(builder: (context) => Search(type: "artistWorks",database: widget.database,));
    }
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
     Scaffold(
      body: Navigator(key: _navigatorKey, onGenerateRoute: generateRoute),
        bottomNavigationBar: _bottomNavigationBar(),
      ));
  }
}