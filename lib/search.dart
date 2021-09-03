import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/UserSignUp.dart';
import 'package:db_project/createAlbum.dart';
import 'package:db_project/createSong.dart';
import 'package:db_project/searchPage.dart';
import 'package:db_project/main.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

import 'ArtistSignUp.dart';

class Search extends StatefulWidget {
  final Database database;
  final String type;
  Search({Key key,this.type,this.database});
  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      appBar:AppBar(
        automaticallyImplyLeading:false,
        backgroundColor: Colors.black45,
        title: Text(widget.type!="artistWorks" ?  "جست و جو" : "قطعات",style: TextStyle(fontSize: 28,color: Colors.indigoAccent),),
      ),
      body: widget.type!="artistWorks" ? Stack(children:[ 
        Container(
        alignment: Alignment(0,-0.7),
        child: FloatingActionButton.extended(
          heroTag: "menu1",
          label: Text("      هنرمند     ",style: TextStyle(fontSize: 25),),
          icon: Icon(IconData(0xe9a9,fontFamily: "Artist"),size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            var _artistList=await widget.database.rawQuery('SELECT * FROM Artist');
            Navigator.push(context, PageTransition(child: SearchPage(list: _artistList,type: "Artist",database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,-0.4),
        child: FloatingActionButton.extended(
          heroTag: "menu2",
          label: Text("       کاربر     ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.supervised_user_circle,size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            var _userList=await widget.database.rawQuery('SELECT * FROM User WHERE User.id NOT IN ("$user_ID")');
              Navigator.push(context, PageTransition(child: SearchPage(list: _userList,type: "User",database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,-0.1),
        child: FloatingActionButton.extended(
          heroTag: "menu3",
          label: Text("    پلی لیست   ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.playlist_play,size: 32,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            var _playLists=await widget.database.rawQuery('SELECT * FROM Playlist WHERE Playlist.user_id NOT IN ("$user_ID")');
            Navigator.push(context, PageTransition(child: SearchPage(list: _playLists,type:"Playlist",database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,0.2),
        child: FloatingActionButton.extended(
          heroTag: "menu4",
          label: Text("       موزیک      ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.music_note,size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            var _music=await widget.database.rawQuery('SELECT * FROM Music');
             Navigator.push(context, PageTransition(child: SearchPage(list: _music,type: "Music",database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,0.5),
        child: FloatingActionButton.extended(
          heroTag: "menu5",
          label: Text("        آلبوم      ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.album,size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
             var _music=await widget.database.rawQuery('SELECT * FROM Album WHERE Album.is_single_or_ep not in ("single")');
             Navigator.push(context, PageTransition(child: SearchPage(list: _music,type: "Album",database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      ]):Stack(
        children: <Widget>[
          Container(
        alignment: Alignment(0,-0.6),
        child: FloatingActionButton.extended(
          heroTag: "menu6",
          label: Text("            آلبوم ها          ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.album,size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
             var _albums=await widget.database.rawQuery('SELECT * FROM _In,Album WHERE Album.is_single_or_ep not in ("single") and Album.id=_In.album_id and _In.artist_id="$artist_ID" and _In.artist_username="$artist_Username"');
             Navigator.push(context, PageTransition(child: SearchPage(list: _albums,type: "Album",database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,-0.2),
        child: FloatingActionButton.extended(
          heroTag: "menu7",
          label: Text("         تک آهنگ ها        ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.music_note,size: 30,),
          backgroundColor: Colors.indigoAccent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            var _singles=await widget.database.rawQuery('SELECT * FROM _In,Album,Music WHERE Album.is_single_or_ep in ("single") and Album.id=_In.album_id and _In.artist_id="$artist_ID" and _In.artist_username="$artist_Username" and Music.album_id=Album.id');
             Navigator.push(context, PageTransition(child: SearchPage(list: _singles,type: "Music",database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
      Container(
        alignment: Alignment(0,0.2),
        child: FloatingActionButton.extended(
          heroTag: "menu9",
          label: Text("        ساخت آلبوم       ",style: TextStyle(fontSize: 25),),
          icon: Icon(Icons.create,size: 30,),
          backgroundColor: Colors.pink,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
          onPressed: () async {
            createMusicForAlbum=[];
            addArtist=[];
            //var _music=await widget.database.rawQuery('SELECT * FROM Music WHERE is_active not in ("FALSE")');
             Navigator.push(context, PageTransition(child: CreateAlbum(database: database,),type: PageTransitionType.fade));
          },
        ),
      ),
        ],
      )
      ))
      ;
}}