import 'dart:ui';
import 'package:db_project/Playlist.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/choosPlaylist.dart';
import 'package:db_project/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

class MusicDetail extends StatefulWidget{
  final bool icons;
  final List<Map<String, dynamic>> artistsNames;
  final bool fulllike;
  final Map<String, dynamic> musicDetail;
  final String albumName;
  final Database database;
  @override
  _MusicDetail createState()=>_MusicDetail();
  MusicDetail({Key key,this.artistsNames,this.albumName,this.musicDetail,this.database,this.icons,this.fulllike,});
}
class _MusicDetail extends State<MusicDetail>{
  bool _liked=false;
  //bool _likedBefore=false;
  void initState(){
    super.initState();
    _liked=widget.fulllike;
  }
  String artistsNames(){
    String names="";
    for (int i=0 ; i < widget.artistsNames.length;i++){
      if(i+1==widget.artistsNames.length){
        names+="${widget.artistsNames[i]['artist_username']}";
      }
      else{
    names+="${widget.artistsNames[i]['artist_username']},";}
    } 
    return names;
  }
  String duration(){
  int min=(widget.musicDetail['duration']/60).toInt();
  int seconds=widget.musicDetail['duration']-(widget.musicDetail['duration']/60).toInt()*60;
  if (seconds<10){
    if(min<10){
      return "0$min : 0$seconds : مدت زمان";
    }
    return "$min : 0$seconds : مدت زمان";
  }
  else{
     if(min<10){
      return "0$min : $seconds : مدت زمان";
    }
    return "$min : $seconds : مدت زمان";
  }
}

  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){Navigator.pop(context);},),
        title: Text(widget.musicDetail['title'],style: TextStyle(fontSize: 23),),
        backgroundColor: Colors.black12,
      ),
      body:Stack(
        children: <Widget>[
                      Container(
                        alignment: Alignment(0,-0.4),
                        child: Text("${artistsNames()} : نام هنرمند",style: TextStyle(color: Colors.pink,fontSize: 30),),
                      ),
                      Container(
                        alignment: Alignment(0,0.6),
                        child:widget.musicDetail['is_active']=="TRUE" ? Text("فعال : بله",style: TextStyle(color: Colors.pink,fontSize: 30),)
                        :Text("فعال : خیر",style: TextStyle(color: Colors.pink,fontSize: 30),),
                      ),
                      Container(
            alignment: Alignment(0,-0.9),
              child: widget.musicDetail['cover_reference']==null ? ClipOval(
                child: Material(
                  color: Colors.pink,
                  child: InkWell(
                    splashColor: Colors.pink,
                    child: SizedBox(width: 100,height: 100,child: Icon(Icons.add_a_photo,size: 40,color: Colors.white,)),
                  ),
                ),
              ):
              
              CircleAvatar(
              backgroundImage:AssetImage(widget.musicDetail['cover_reference']) ,
              radius: 70,
              backgroundColor: Colors.pink[50],
              child: Container(
            height: 102,
            width: 102,
          ),
                      )),
                      Container(
                        alignment: Alignment(0,0.85),
                        child:widget.musicDetail['is_explicit']=="TRUE" ? Text("الفاظ رک : دارد",style: TextStyle(color: Colors.pink,fontSize: 30),)
                        :Text("الفاظ رک : ندارد",style: TextStyle(color: Colors.pink,fontSize: 30),),
                      ),
                      Container(
                        alignment: Alignment(0,0.35),
                        child:Text("${widget.musicDetail['number_of_plays']} : تعداد دفعات پخش",style: TextStyle(color: Colors.pink,fontSize: 30),)
                      ),
                      Container(
                        alignment: Alignment(0,-0.15),
                        child:Text("${widget.albumName} : نام آلبوم",style: TextStyle(color: Colors.pink,fontSize: 30),)
                      ),
                      Container(
            alignment: Alignment(0.8,-0.78),
            child: widget.icons==false || widget.musicDetail['is_active']=="FALSE" ? null : _liked==false ? IconButton(icon:Icon(IconData(0xe9a9,fontFamily: "EmptyLike"),color: Colors.pink,size: 30,),onPressed: () async {
              var date=await widget.database.rawQuery('SELECT DATE ("now")');
              var liked_insert=await widget.database.rawInsert('INSERT INTO Liked (user_id,music_id,email,date) VALUES ("$user_ID","${widget.musicDetail['id']}","$user_EMAIL","${date[0]['DATE ("now")']}")');
              var likeList=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,Music.album_id,Liked.date FROM Liked,Music WHERE Liked.user_id="$user_ID" AND Music.id=Liked.music_id');
              liked=likeList;
              setState(() {
                _liked=true;
              });
            },):IconButton(icon:Icon(IconData(0xe9a9,fontFamily: "FullLike"),color: Colors.pink,size: 30,),onPressed: () async {
              var liked_insert=await widget.database.rawDelete('DELETE FROM Liked WHERE Liked.user_id="$user_ID" and Liked.music_id="${widget.musicDetail['id']}"');
              var likeList=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,Music.album_id,Liked.date FROM Liked,Music WHERE Liked.user_id="$user_ID" AND Music.id=Liked.music_id');
              liked=likeList;
              setState(() {
                _liked=false;
              });
            },),
          ),
          Container(
            alignment: Alignment(-0.8,-0.8),
            child: widget.icons!=false && widget.musicDetail['is_active']=="TRUE"? IconButton(icon:Icon(Icons.playlist_add,color: Colors.pink,size: 37,),onPressed: () async {
              var which_playlists=await widget.database.rawQuery('SELECT Playlist.name,Playlist.description,Playlist.image_reference,Playlist.id FROM Playlist,On_Playlist WHERE On_Playlist.music_id ="${widget.musicDetail['id']}" and Playlist.id = On_Playlist.playlist_id and Playlist.user_id="$user_ID"');
              print(which_playlists);
              if (which_playlists.isEmpty){
                Navigator.push(context, PageTransition(child: ChoosPlaylist(whichPlaylists: playlists,database: widget.database,musicID: widget.musicDetail['id']),type: PageTransitionType.fade));
              }
              else{var which_playlists2=await widget.database.rawQuery('SELECT Playlist.name,Playlist.description,Playlist.image_reference,Playlist.id FROM Playlist,On_Playlist WHERE On_Playlist.music_id ="${widget.musicDetail['id']}" and Playlist.id = On_Playlist.playlist_id and Playlist.user_id="$user_ID"');
              print(which_playlists2);
              Navigator.push(context, PageTransition(child: ChoosPlaylist(whichPlaylists: which_playlists2,database: widget.database,musicID: widget.musicDetail['id']),type: PageTransitionType.fade));}
            },):null,
          ),
          Container(
            alignment: Alignment(0,0.1),
            child: Text(duration(),style: TextStyle(fontSize: 28,color: Colors.pink),),
          ),
        ],
      ),
    ));
  }
}