import 'package:db_project/musicDetail.dart';
import 'package:db_project/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

class Favorite extends StatefulWidget{
  final Database database;
  @override
  _Favorite createState()=>_Favorite();
  Favorite({Key key,this.database});
}
Widget playlist_pic(List<Map<String, dynamic>> _pl,int index){
    if (_pl[index]['cover_reference']!=null){
    return CircleAvatar(
          backgroundColor: Colors.pink[50],
          backgroundImage: AssetImage(_pl[index]['cover_reference'])
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
class _Favorite extends State<Favorite>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
        backgroundColor: Colors.black,
        title: Text("علاقه ها",style: TextStyle(fontSize: 25,color: Colors.indigoAccent),),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
      itemExtent: 115,
      itemCount: liked.length,
      itemBuilder: (BuildContext context,int index){
        return Container(
          padding: EdgeInsets.only(top:15,left: 15,right: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.indigo[800],width: 3))
          ),
          child:
        ListTile(subtitle:liked[index]['date'] !=null ? Text('''
        
                     ${liked[index]['date']}''',style: TextStyle(color: Colors.white),):null ,
          leading:
        Container(
          height: 60,
          width: 60,
          child: playlist_pic(liked,index)
        )
        ,
          trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,)
          ,
          title: Text(liked[index]['title'],textAlign: TextAlign.center,style: TextStyle(fontSize: 25,
          color: Colors.white
          )),
          onTap: () async {
            var album_name=await widget.database.rawQuery('SELECT Album.title,Album.id FROM Music,Album WHERE Music.id="${liked[index]['id']}" and Music.album_id=Album.id');
            var artistsname=await widget.database.rawQuery('SELECT _In.artist_username,_In.is_owner FROM _In,Artist WHERE _In.album_id="${album_name[0]['id']}" and _In.artist_username=Artist.username');
            var musicdetail=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,Music.album_id FROM Music WHERE Music.id="${liked[index]['id']}"');
            Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: MusicDetail(artistsNames: artistsname,albumName: album_name[0]['title'],musicDetail: musicdetail[0],database: widget.database,icons: true,fulllike: true)));
            },
        ));
      },
    )
    ));
  }
}
