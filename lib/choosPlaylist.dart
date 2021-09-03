import 'dart:io';

import 'package:db_project/AddPlaylist.dart';
import 'package:db_project/PlaylistDetail.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

import 'Playlist.dart';

class ChoosPlaylist extends StatefulWidget{
  final int musicID;
  final List<Map<String, dynamic>> whichPlaylists;
  final Database database;
  ChoosPlaylist({Key key,this.database,this.musicID,this.whichPlaylists});
  @override 
  _ChoosPlaylist createState() => _ChoosPlaylist();
}
class _ChoosPlaylist extends State<ChoosPlaylist>{
  File _image;
  Widget playlist_pic(List<Map<String, dynamic>> _pl,int index){
    if (_pl[index]['image_reference']!=null){
    return CircleAvatar(
          backgroundColor: Colors.pink[50],
          backgroundImage: AssetImage(_pl[index]['image_reference'])
          );
          }
    else{
        return CircleAvatar(
          backgroundColor: Colors.pink[50],
          child: Container(
            alignment: Alignment.center,
            child: Icon(Icons.photo,color: Colors.pink,),
          ),

        );}
  }

  Widget check_playlist(BuildContext cntx){
    if (widget.whichPlaylists.isEmpty){
      return Container(
      );
    }
    else{
      return
      ListView.builder(
      itemExtent: 115,
      itemCount: widget.whichPlaylists.length,
      itemBuilder: (BuildContext context,int index){
        return Container(
          padding: EdgeInsets.only(top:15,left: 15,right: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.indigo[800],width: 3))
          ),
          child:
        ListTile(leading:
        Container(
          height: 60,
          width: 60,
          child: playlist_pic(widget.whichPlaylists,index)
        )
          ,
          title: Text(widget.whichPlaylists[index]['name'],textAlign: TextAlign.center,style: TextStyle(fontSize: 25,
          color: Colors.white
          )),
          onTap: () async {
            var date=await widget.database.rawQuery('SELECT DATE ("now")');
            var inser_music=await widget.database.rawInsert('INSERT INTO On_Playlist (music_id,playlist_id,date_of_add) VALUES ("${widget.musicID}","${widget.whichPlaylists[index]['id']}","${date[0]['DATE ("now")']}")');
            var a=await widget.database.rawQuery('SELECT * FROM On_Playlist');
            Navigator.pop(cntx);
               },
        ));
      },
    );
    }
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
        backgroundColor: Colors.black45,
        title: Text("انتخاب پلی لیست",style: TextStyle(color: Colors.indigoAccent,fontSize: 25),),
      ),
      body: Stack(
        children: <Widget>[
          check_playlist(context),
        ],
      )
    ));
  }
}