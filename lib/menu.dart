import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/UserSignUp.dart';
import 'package:db_project/main.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

import 'ArtistSignUp.dart';

class Menu extends StatefulWidget {
  Database database;
  Menu({Key key,this.database});
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      body:Stack(children:[ 
        Container(
          alignment: Alignment(0,-0.75),
          child: Text("!!!!خوش آمدید",style: TextStyle(fontSize: 30,color: Colors.white),),
        ),
        Container(
        alignment: Alignment(0,-0.4),
        child: FloatingActionButton.extended(
          heroTag: "menu1",
          label: Text("     ثبت نام هنرمند     ",style: TextStyle(fontSize: 25),),
          icon: Icon(IconData(0xe9a9,fontFamily: "Artist"),size: 30,),
          backgroundColor: Colors.pink,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            Navigator.push(context, PageTransition(child: ArtistSignUp(database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,-0.1),
        child: FloatingActionButton.extended(
          heroTag: "menu2",
          label: Text("      ورود هنرمند         ",style: TextStyle(fontSize: 25),),
          icon: Icon(IconData(0xe9a9,fontFamily: "Artist"),size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
              Navigator.push(context, PageTransition(child: ArtistLogIn(database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,0.2),
        child: FloatingActionButton.extended(
          heroTag: "menu3",
          label: Text("     ثبت نام کاربر      ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.supervised_user_circle,size: 30,),
          backgroundColor: Colors.pink,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            Navigator.push(context, PageTransition(child: UserSignUp(database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,0.5),
        child: FloatingActionButton.extended(
          heroTag: "menu4",
          label: Text("        ورود کاربر        ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.supervised_user_circle,size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
             Navigator.push(context, PageTransition(child: UserLogIn(database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      ])));
}}