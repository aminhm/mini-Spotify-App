import 'dart:ui';
import 'package:db_project/choosPlaylist.dart';
import 'package:db_project/searchPage.dart';
import 'package:db_project/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

class AlbumDetail extends StatefulWidget{
  final String isOwner;
  final Map<String, dynamic> albumDetail;
  final Database database;
  final int count;
  final int duration;
  @override
  _AlbumDetail createState()=>_AlbumDetail();
  AlbumDetail({Key key,this.duration,this.count,this.database,this.albumDetail,this.isOwner});
}

class _AlbumDetail extends State<AlbumDetail>{
    String duration(){
  int hour=(widget.duration~/3600);
  int min=(widget.duration~/60);
  int seconds=widget.duration-(widget.duration~/60)*60;
  if (seconds<10){
    if(hour<10){
      if(min<10){
        return "0$hour : 0$min : 0$seconds";
      }
      return "0$hour : $min : 0$seconds";
    }
    return "$hour : $min : 0$seconds";
  }
  else{
    if(hour<10){
      if(min<10){
        return "0$hour : 0$min : $seconds";
      }
      return "0$hour : $min : $seconds";
    }
    return "$hour : $min : $seconds";
  }
}
  bool follow_icon=false;
  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){Navigator.pop(context);},),
        title: Text(widget.albumDetail['title'],style: TextStyle(fontSize: 23),),
        backgroundColor: Colors.black12,
      ),
      body:Stack(
        children: <Widget>[
          Container(
            alignment: Alignment(0,0.25),
            child: Text("${widget.count} : تعداد قطعات",style: TextStyle(fontSize: 25,color: Colors.pink[200]),),
          ),
          Container(
            alignment: Alignment(0,0.45),
            child: Text("${duration()} : زمان کل",style: TextStyle(fontSize: 25,color: Colors.pink[200]),),
          ),
                      Container(
            alignment: Alignment(0,-0.9),
              child: widget.albumDetail['image_reference']==null ? ClipOval(
                child: Material(
                  color: Colors.pink,
                  child: InkWell(
                    splashColor: Colors.pink,
                    child: SizedBox(width: 100,height: 100,child: Icon(Icons.add_a_photo,size: 40,color: Colors.white,)),
                  ),
                ),
              ):
              
              CircleAvatar(
              backgroundImage:AssetImage(widget.albumDetail['image_reference']) ,
              radius: 70,
              backgroundColor: Colors.pink[50],
              child: Container(
            height: 102,
            width: 102,
          ),
                      )),
          Container(
            alignment: Alignment(0,-0.35),
            child: Text("${widget.isOwner} : صاحب اثر",style: TextStyle(fontSize: 25,color: Colors.pink[200]),),
          ),
          Container(
            alignment: Alignment(0,-0.15),
            child: Text("${widget.albumDetail['release_year']} : سال انتشار",style: TextStyle(color: Colors.pink[200],fontSize: 25),),
          ),
          widget.albumDetail['is_single_or_ep']=="ep" ?
          Container(
            alignment: Alignment(0,0.05),
            child: Text("     نوع آلبوم : کوتاه",style: TextStyle(color: Colors.pink[200],fontSize: 25),),
          ):Container(
            alignment: Alignment(0,0.05),
            child: Text("نوع آلبوم : کامل",style: TextStyle(color: Colors.pink[200],fontSize: 25),),
          ),
          Container(
            alignment: Alignment(0,0.65),
            child: Text("        : کپی رایت",style: TextStyle(color: Colors.pink[200],fontSize: 25),),
          ),
          Container(
            alignment: Alignment(-0.25,0.65),
            child: widget.albumDetail['copy_right']=="FALSE" ? Text("ندارد",style: TextStyle(color: Colors.pink[200],fontSize: 25),):Text("دارد",style: TextStyle(color: Colors.pink[200],fontSize: 25),),
          ),
          Container(
            alignment: Alignment(0,0.9),
            child:OutlineButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
              highlightedBorderColor: Colors.red,
              textColor: Colors.red,
              splashColor: Colors.orange,
              onPressed: () async {
                var songsList=await widget.database.rawQuery('SELECT * FROM Music WHERE Music.album_id="${widget.albumDetail['id']}"');
                Navigator.push(context, PageTransition(child: SearchPage(type: "Music",database: widget.database,list:songsList,),type: PageTransitionType.fade));
              }, child: Text("مشاهده قطعه ها",style: TextStyle(fontSize: 25,color: Colors.red),))
          )
        ],
      ),
    ));
  }
}