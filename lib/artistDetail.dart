import 'dart:ui';
import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/choosPlaylist.dart';
import 'package:db_project/createAlbum.dart';
import 'package:db_project/searchPage.dart';
import 'package:db_project/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

class ArtistDetail extends StatefulWidget{
  final bool followIcon;
  final Map<String, dynamic> artistDetail;
  final Database database;
  final String type;
  final int albumID;
  @override
  _ArtistDetail createState()=>_ArtistDetail();
  ArtistDetail({Key key,this.albumID,this.type,this.database,this.artistDetail,this.followIcon});
}
class _ArtistDetail extends State<ArtistDetail>{
  bool follow_icon=false;
  void initState(){
    super.initState();
    follow_icon=widget.followIcon;
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(automaticallyImplyLeading: false,
        leading:IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if(widget.type=="ArtistFollow"){
            var artist_followings=await widget.database.rawQuery('SELECT Artist.id,Artist.image_reference,Artist.about,Artist.is_verified,Artist.username FROM Artist,Artist_Follow WHERE "$user_ID"=Artist_Follow.user_id and "$user_EMAIL"=Artist_Follow.user_email and Artist_Follow.artist_id=Artist.id and Artist_Follow.artist_username=Artist.username');
            Navigator.pop(context);
            //Navigator.of(context).push(PageTransition(child: SearchPage(type: "ArtistFollow",list: artist_followings,database: widget.database,),type: PageTransitionType.fade));
            }
            else{Navigator.pop(context);}
          },
        ),
        actions: <Widget>[
          follow_icon==false && is_artist==false ?
          FlatButton(
            onPressed: () async {
              var artist_follow=await widget.database.rawInsert('INSERT INTO Artist_Follow (artist_id,artist_username,user_id,user_email) VALUES ("${widget.artistDetail['id']}","${widget.artistDetail['username']}","$user_ID","$user_EMAIL")');
              setState(() {
                follow_icon=true;
              });

            },
            child: Text("Follow",style: TextStyle(fontSize: 20,color: Colors.blue),),
          ):follow_icon==true && is_artist==false? FlatButton(
            onPressed: () async {
              var artist_follow_delete=await widget.database.rawDelete('DELETE FROM Artist_Follow WHERE user_id = "$user_ID" and user_email="$user_EMAIL" and artist_id="${widget.artistDetail['id']}" and artist_username="${widget.artistDetail['username']}"');
              setState(() {
                follow_icon=false;
              });
            },
            child: Text("Unfollow",style: TextStyle(fontSize: 20,color: Colors.red),),):
            follow_icon==false && is_artist==true ?
          FlatButton(
            onPressed: () async {
              addArtist.add(
                {
                  'artist_id' : widget.artistDetail['id'],
                  'artist_username' : widget.artistDetail['username']
                }
              );
              setState(() {
                follow_icon=true;
              });

            },
            child: Text("Add",style: TextStyle(fontSize: 20,color: Colors.blue),),
          ):follow_icon==true && is_artist==true? FlatButton(
            onPressed: () async {
              addArtist.remove(
                {
                  'artist_id' : widget.artistDetail['id'],
                  'artist_username' : widget.artistDetail['username']
                }
              );
              setState(() {
                follow_icon=false;
              });
            },
            child: Text("Remove",style: TextStyle(fontSize: 20,color: Colors.red),),): Container()
        ],
        title: Text(widget.artistDetail['username'],style: TextStyle(fontSize: 23),),
        backgroundColor: Colors.black12,
      ),
      body:Stack(
        children: <Widget>[
          Container(
            alignment: Alignment(0,-0.9),
              child: widget.artistDetail['image_reference']==null ? ClipOval(
                child: Material(
                  color: Colors.pink,
                  child: InkWell(
                    splashColor: Colors.pink,
                    child: SizedBox(width: 100,height: 100,child: Icon(Icons.add_a_photo,size: 40,color: Colors.white,)),
                  ),
                ),
              ):
              
              CircleAvatar(
              backgroundImage:AssetImage(widget.artistDetail['image_reference']) ,
              radius: 70,
              backgroundColor: Colors.pink[50],
              child: Container(
            height: 102,
            width: 102,
          ),
                      )),
          Container(
            alignment: Alignment(0,-0.2),
            child: widget.artistDetail['about']!=null ? Text("${widget.artistDetail['about']}",style: TextStyle(color: Colors.pink[200],fontSize: 25),):Container(),
          ),
          Container(
            alignment: Alignment(0,-0.4),
            child: widget.artistDetail['is_verified']=="TRUE" ? Icon(IconData(0xe9a9,fontFamily: "Verify"),size: 40,color: Colors.blue,):Container(),
          ),
          Container(
            alignment: Alignment(0,-0.4),
            child: widget.artistDetail['is_verified']=="TRUE" ? Icon(IconData(0xe9a9,fontFamily: "Verify"),size: 40,color: Colors.blue,):Container(),
          ),
          is_artist!=true ?
          Container(
            alignment: Alignment(0,0.65),
            child: OutlineButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
              highlightedBorderColor: Colors.red,
              textColor: Colors.red,
              splashColor: Colors.orange,
              onPressed: () async {
                String type="Music";
                if(is_artist==true){type="MusicArtist";}
                var songsList=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,Music.album_id FROM _In,Album,Music WHERE _In.album_id=Album.id and _In.artist_id="${widget.artistDetail['id']}" and _In.artist_username="${widget.artistDetail['username']}" and Album.id=Music.album_id and Album.is_single_or_ep="single"');
                Navigator.push(context, PageTransition(child: SearchPage(type: type,database: widget.database,list:songsList ,),type: PageTransitionType.fade));
              },
              child: Text("مشاهده تک آهنگ ها",style: TextStyle(color: Colors.red,fontSize: 25),),
            ),
          ):Container(),
          is_artist!=true ?
          Container(
            alignment: Alignment(0,0.45),
            child: OutlineButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
              highlightedBorderColor: Colors.red,
              textColor: Colors.red,
              splashColor: Colors.orange,
              onPressed: () async {
                var albumLists=await widget.database.rawQuery('SELECT Album.title,Album.id,Album.release_year,Album.copy_right,Album.is_single_or_ep,Album.image_reference FROM Album,_In WHERE "${widget.artistDetail['id']}"=_In.artist_id and _In.album_id=Album.id and Album.is_single_or_ep not in ("single")');
                Navigator.push(context, PageTransition(child: SearchPage(type: "Album",database: widget.database,list: albumLists,),type: PageTransitionType.fade));
              },
              child: Text("مشاهده آلبوم ها",style: TextStyle(color: Colors.red,fontSize: 25),),
            ),
          ):Container(),
          is_artist!=true ?
          Container(
            alignment: Alignment(0,0.85),
            child: OutlineButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
              highlightedBorderColor: Colors.red,
              textColor: Colors.red,
              splashColor: Colors.orange,
              onPressed: () async {
                String type="Music";
                if(is_artist==true){type="MusicArtist";}
                var songsList=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,Music.album_id FROM _In,Album,Music WHERE _In.album_id=Album.id and _In.artist_id="${widget.artistDetail['id']}" and _In.artist_username="${widget.artistDetail['username']}" and Album.id=Music.album_id ORDER BY Music.number_of_plays DESC LIMIT 5');
                Navigator.push(context, PageTransition(child: SearchPage(type: type,database: widget.database,list:songsList ,),type: PageTransitionType.fade));
              },
              child: Text("مشاهده 5 موزیک برتر هنرمند",style: TextStyle(color: Colors.red,fontSize: 25),),
            ),
          ):Container()
        ],
      ),
    ));
  }
}