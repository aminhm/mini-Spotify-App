import 'package:db_project/Playlist.dart';
import 'package:db_project/search.dart';
import 'package:db_project/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class UserDashboard extends StatefulWidget{
  final Map<String, dynamic> userDetail;
  final Database database;
  UserDashboard({Key key,this.userDetail,this.database}) : super(key: key) ;
  @override 
  _UserDashboard createState() => _UserDashboard();
}

class _UserDashboard extends State<UserDashboard>{
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int currentIndex=0;
  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _navigatorKey.currentState.pushReplacementNamed("پلی لیست");
        break;
      case 1:
        _navigatorKey.currentState.pushReplacementNamed("جست و جو");
        break;
      case 2:
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
      [BottomNavigationBarItem(icon: Icon(Icons.playlist_play,size: 35,),title: Text("پلی لیست",style: TextStyle(fontSize: 18),)
      )
      ,BottomNavigationBarItem(icon: Icon(Icons.search,size: 35,),title: Text("جست و جو",style: TextStyle(fontSize: 18),))
      , BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle,size: 35,),title: Text("حساب کاربری",style: TextStyle(fontSize: 18),))
      ]
      );
  }
   Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "جست و جو":
        return MaterialPageRoute(builder: (context) => Search(database: widget.database,));
      case "حساب کاربری":
        return MaterialPageRoute(builder: (context) => UserProfile(type: "own",database: widget.database,userDetail: widget.userDetail,));
      default:
        return MaterialPageRoute(builder: (context) => Playlist(database: widget.database,) );
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Navigator(key: _navigatorKey, onGenerateRoute: generateRoute),
        bottomNavigationBar: _bottomNavigationBar(),
      );
  }
}