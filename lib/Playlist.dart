import 'dart:io';

import 'package:db_project/AddPlaylist.dart';
import 'package:db_project/PlaylistDetail.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';
List<Map<String, dynamic>> playlists;
List<Map<String, dynamic>> on_playlists;

class Playlist extends StatefulWidget{
  final Database database;
  Playlist({Key key,this.database});
  @override 
  _Playlist createState() => _Playlist();
}
class _Playlist extends State<Playlist>{
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

  Widget check_playlist(){
    if (playlists.isEmpty){
      return Container(
        alignment: Alignment(0,-0.2),
        child: RichText(textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [TextSpan(style: TextStyle(color: Colors.indigoAccent[700],fontSize: 25,fontWeight: FontWeight.w700),
                      text: '''پلی لیست شما خالی است        
لطفا برای اضافه کردن پلی لیست
را فشار دهید'''
                    ),
                    WidgetSpan(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.add,color: Colors.pink,),
                    )),
                    // TextSpan(style: TextStyle(color: Colors.indigoAccent[700],fontSize: 25,fontWeight: FontWeight.w700),
                    //   text: 
                    // 'را فشار دهید'),
                    ]
                  ),
      )
      );
    }
    else{
      return
      ListView.builder(
      itemExtent: 115,
      itemCount: playlists.length,
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
          child: playlist_pic(playlists,index)
        )
        ,
          trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,)
          ,
          title: Text(playlists[index]['name'],textAlign: TextAlign.center,style: TextStyle(fontSize: 25,
          color: Colors.white
          )),
          onLongPress: (){ showDialog(barrierDismissible: false,context: context,builder: (BuildContext context){return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                  title: Stack(children: <Widget>[
                    Align(alignment:Alignment.centerRight,child:
                    Text('حذف',textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.w900),)),
                    Icon(Icons.delete,color: Colors.red,size: 30),
                  ],),
                  content: Text('این پلی لیست حذف شود؟',textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                  actions: <Widget>[FlatButton(child: Text('بله',style: TextStyle(color: Colors.blue,fontSize: 20)),onPressed: () async {
                    await widget.database.rawDelete('DELETE FROM On_Playlist WHERE On_Playlist.playlist_id="${playlists[index]['id']}"');
                    await widget.database.rawDelete('DELETE FROM Playlist WHERE Playlist.id="${playlists[index]['id']}"');
                    var new_playlist=await widget.database.rawQuery('SELECT * FROM Playlist WHERE "$user_ID"=Playlist.user_id and "$user_EMAIL"=Playlist.user_email ');
                    setState(() {
                      playlists=new_playlist;
                    });
                    Navigator.of(context).pop();
                  },),
                  FlatButton(child: Text('خیر',style: TextStyle(color: Colors.blue,fontSize: 20)),onPressed: (){Navigator.of(context).pop();},)],
                );});},
          onTap: () async {
            var _on_playlist=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${playlists[index]['id']}" AND Music.id=On_Playlist.music_id');
            var _duration=await widget.database.rawQuery('SELECT SUM(Music.duration),Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${playlists[index]['id']}" AND Music.id=On_Playlist.music_id');
            var _count=await widget.database.rawQuery('SELECT COUNT(*),Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${playlists[index]['id']}" AND Music.id=On_Playlist.music_id');
            int duration=_duration[0]['SUM(Music.duration)'];
            int count=_count[0]['COUNT(*)'];
            on_playlists=_on_playlist;
            Navigator.push(context,PageTransition(type: PageTransitionType.fade,child: PlaylistDetail(duration:duration,numberOfSongs:count,type:"own",database: widget.database,name: playlists[index]['name'],id:playlists[index]['id'],about: playlists[index]['description'],imageReference: playlists[index]['image_reference'],)));          },
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
      appBar: AppBar(
        automaticallyImplyLeading:false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add,color: Colors.white,size: 30,), onPressed:(){
             Navigator.push(context, PageTransition(child: AddPlaylist(database: widget.database,),type: PageTransitionType.fade));
          } )
        ],
        backgroundColor: Colors.black45,
        title: Text("پلی لیست",style: TextStyle(color: Colors.indigoAccent,fontSize: 25),),
      ),
      body: Stack(
        children: <Widget>[
          check_playlist(),
        ],
      )
    ));
  }
}