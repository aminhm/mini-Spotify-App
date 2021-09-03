import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/UserSignUp.dart';
import 'package:db_project/main.dart';
import 'package:db_project/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

import 'ArtistSignUp.dart';

class Fallowings extends StatefulWidget {
  final Database database;
  final String type;
  final int userID;
  final String userEmail;
  Fallowings({Key key,this.type,this.database,this.userEmail,this.userID});
  @override
  _Fallowings createState() => _Fallowings();
}

class _Fallowings extends State<Fallowings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("دنبال ها",style: TextStyle(fontSize: 30,color: Colors.white),),
        leading: IconButton(icon:Icon(Icons.arrow_back_ios),onPressed: (){Navigator.pop(context);},),
      ),
      backgroundColor: Colors.black,
      body:Stack(children:[ 
        widget.type=="following" ? Container(
          alignment: Alignment(0,0.6),
          child: FloatingActionButton.extended(
          heroTag: "menu0",
          label: Text("  created playlists ",style: TextStyle(fontSize: 25),),
          //icon: Icon(IconData(0xe9a9,fontFamily: "Artist"),size: 30,),
          backgroundColor: Colors.pink,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
           var playlist_followings=await widget.database.rawQuery('SELECT Playlist.id,Playlist.image_reference,Playlist.description,Playlist.name FROM Playlist WHERE "${widget.userID}"=Playlist.user_id and "${widget.userEmail}"=Playlist.user_email');
           Navigator.push(context, PageTransition(child: SearchPage(type:"Playlist",list: playlist_followings,database: database,),type: PageTransitionType.fade));
          },
        ),
        ): Container(),
        Container(
        alignment: Alignment(0,-0.6),
        child: FloatingActionButton.extended(
          heroTag: "menu1",
          label: Text("   user followings   ",style: TextStyle(fontSize: 25),),
          //icon: Icon(IconData(0xe9a9,fontFamily: "Artist"),size: 30,),
          backgroundColor: Colors.pink,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {

            //var user_followings=await widget.database.rawQuery('SELECT * FROM Artist_Follow');
            var user_followings=await widget.database.rawQuery('SELECT User.id,User.name,User.image_reference,User.land,User.email,User.name FROM User,User_Follow WHERE "$user_ID"=User_Follow.follower_id and "$user_EMAIL"=User_Follow.follower_email and User_Follow.followed_id=User.id and User_Follow.followed_email=User.email and User_Follow.followed_id not in ("${widget.userID}") and User_Follow.followed_email not in ("${widget.userEmail}")');
            Navigator.push(context, PageTransition(child: SearchPage(type:"User",database: database,list: user_followings,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,-0.3),
        child: FloatingActionButton.extended(
          heroTag: "menu2",
          label: Text("    user followers    ",style: TextStyle(fontSize: 25),),
          //icon: Icon(IconData(0xe9a9,fontFamily: "Artist"),size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            var user_followers=await widget.database.rawQuery('SELECT User.id,User.name,User.image_reference,User.land,User.email,User.name FROM User,User_Follow WHERE "$user_ID"=User_Follow.followed_id and "$user_EMAIL"=User_Follow.followed_email and User_Follow.follower_id=User.id and User_Follow.follower_email=User.email and User_Follow.follower_id not in ("${widget.userID}") and User_Follow.follower_email not in ("${widget.userEmail}")');
            Navigator.push(context, PageTransition(child: SearchPage(type:"User",database: database,list: user_followers,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,0),
        child: FloatingActionButton.extended(
          heroTag: "menu3",
          label: Text("  artist followings  ",style: TextStyle(fontSize: 25),),
          //icon: Icon(Icons.supervised_user_circle,size: 30,),
          backgroundColor: Colors.pink,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            var artist_followings;
            if(is_artist==true){artist_followings=await widget.database.rawQuery('SELECT Artist.id,Artist.image_reference,Artist.about,Artist.is_verified,Artist.username FROM Artist,Artist_Follow WHERE "$user_ID"=Artist_Follow.user_id and "$user_EMAIL"=Artist_Follow.user_email and Artist_Follow.artist_id=Artist.id and Artist_Follow.artist_username=Artist.username and "$artist_ID" not in (Artist.id) and "$artist_Username" not in (Artist.username)');}
            else{artist_followings=await widget.database.rawQuery('SELECT Artist.id,Artist.image_reference,Artist.about,Artist.is_verified,Artist.username FROM Artist,Artist_Follow WHERE "$user_ID"=Artist_Follow.user_id and "$user_EMAIL"=Artist_Follow.user_email and Artist_Follow.artist_id=Artist.id and Artist_Follow.artist_username=Artist.username');}
            Navigator.push(context, PageTransition(child: SearchPage(type:"ArtistFollow",database: database,list: artist_followings,),type: PageTransitionType.fade));
          },
        ),
      ),

      Container(
        alignment: Alignment(0,0.3),
        child: FloatingActionButton.extended(
          heroTag: "menu4",
          label: Text("playlist followings",style: TextStyle(fontSize: 25),),
          //icon: Icon(Icons.supervised_user_circle,size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            var playlist_followings=await widget.database.rawQuery('SELECT Playlist.id,Playlist.image_reference,Playlist.description,Playlist.name FROM Playlist,Playlist_Follow WHERE "$user_ID"=Playlist_Follow.user_id and "$user_EMAIL"=Playlist_Follow.user_email and Playlist_Follow.playlist_id=Playlist.id and Playlist.user_id not in ("$user_ID") and Playlist.user_email not in ("$user_EMAIL")');
             Navigator.push(context, PageTransition(child: SearchPage(type: "Playlist",list: playlist_followings,database: database,),type: PageTransitionType.fade));
          },
        ),
      ),

      ])));
}}