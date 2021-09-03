import 'dart:io';
import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/favorite.dart';
import 'package:db_project/followings.dart';
import 'package:db_project/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

List<Map<String, dynamic>> liked;

class UserProfile extends StatefulWidget{
  final Map<String, dynamic> userDetail;
  final Database database;
  final String type;
  final bool followIcon;
  UserProfile({Key key,this.followIcon,this.type,this.userDetail,this.database});
  @override 
  createState()=>_UserProfile();
}
class _UserProfile extends State<UserProfile>{
  bool follow_icon=false;

  void initState(){
    super.initState();
    follow_icon=widget.followIcon;
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: <Widget>[
            widget.type!="own" && follow_icon==false ?
            FlatButton(
            onPressed: () async {
              var user_follow=await widget.database.rawInsert('INSERT INTO User_Follow (follower_id,follower_email,followed_id,followed_email) VALUES ("$user_ID","$user_EMAIL","${widget.userDetail['id']}","${widget.userDetail['email']}")');
              setState(() {
                follow_icon=true;
              });

            },
            child: Text("Follow",style: TextStyle(fontSize: 20,color: Colors.blue),),
          ): widget.type!="own" && follow_icon==true ? FlatButton(
            onPressed: () async {
              var user_follow_delete=await widget.database.rawDelete('DELETE FROM User_Follow WHERE follower_id = "$user_ID" and follower_email="$user_EMAIL" and followed_id="${widget.userDetail['id']}" and followed_email="${widget.userDetail['email']}"');
              setState(() {
                follow_icon=false;
              });
            },
            child: Text("Unfollow",style: TextStyle(fontSize: 20,color: Colors.red),),)
            : Container()
          ],
          leading: widget.type!="own" || is_artist==true? IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}):
          Container(),
          title: Text('حساب کاربری',style: TextStyle(fontSize: 26,color: Colors.indigoAccent),),
          backgroundColor: Colors.black45,
        ),
        body:Stack(children:<Widget>[new GestureDetector(
            onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
           },),
           widget.type=="own" && is_artist!=true? Container(
             alignment: Alignment(0.85,-0.2),
             child: OutlineButton(
              child: Text("دنبال ها",style: TextStyle(fontSize: 28,fontWeight: FontWeight.w800),),
              textColor: Colors.indigoAccent,
              highlightedBorderColor:Colors.indigoAccent,
              splashColor: Colors.indigoAccent,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed:() async {
          Navigator.push(context, PageTransition(type: PageTransitionType.fade,child:Fallowings(database: widget.database) ));
              }
            ),
           ):Container(),
           widget.type!="own" ? Container(
             alignment: Alignment(0,-0.15),
             child: FlatButton(
               child: Text("دنبال ها",style: TextStyle(color: Colors.blue,fontSize: 25),),
               onPressed: () async {
                 var play_list=await widget.database.rawQuery('SELECT * FROM Playlist WHERE Playlist.user_id="${widget.userDetail['id']}" and Playlist.user_email="${widget.userDetail['email']}"');
                 Navigator.push(context, PageTransition(type: PageTransitionType.fade,child:Fallowings(userID: widget.userDetail['id'],userEmail: widget.userDetail['email'],type:"following",database: widget.database) ));
               },
             ),
           ):Container(),
           Container(
             alignment: Alignment(0,-0.9),
             child: (widget.userDetail['image_reference']==null) ? ClipOval(
                child: Material(
                  color: Colors.pink[50],
                  child: InkWell(
                    splashColor: Colors.pink[200],
                    child: SizedBox(width: 140,height: 140,child: Icon(Icons.add_a_photo,size: 40,color: Colors.black45,)),
                  ),
                )):
              CircleAvatar(
              backgroundImage:AssetImage(widget.userDetail['image_reference']) ,
              radius: widget.type=="own" && is_artist==false ? 100 : is_artist==true ? 130 : 110,
              backgroundColor: Colors.pink[50],
              child: Container(
            height: 150,
            width: 150,
          ),
           )),
           
        Align(
          alignment: Alignment(0.85,0.12),
          child: Icon(IconData(0xe9a9,fontFamily: "Name"),color: Colors.indigoAccent,),
        ),
        Align(
          alignment: Alignment(0.13,0.12),
          child: Padding(
            padding: EdgeInsets.only(left: 50,right: 80),
            child:Text(widget.userDetail['name'],style: TextStyle(fontSize: 20,color: Colors.white),),
        )
      ),
      Align(
          alignment: Alignment(0.85,0.45),
          child: Icon(IconData(0xe9a9,fontFamily: "Email"),color: Colors.indigoAccent,),
        ),
        Align(
          alignment: Alignment(0,0.45),
          child: Padding(
            padding: EdgeInsets.only(left: 50,right: 80),
            child:Text(widget.userDetail['email'],style: TextStyle(fontSize: 20,color: Colors.white),),
        )
      ),
      Align(
          alignment: Alignment(0.85,0.75),
          child: Icon(IconData(0xe9a9,fontFamily: "Land"),color: Colors.indigoAccent),
        ),
        Align(
          alignment: Alignment(0.13,0.75),
          child: Padding(
            padding: EdgeInsets.only(left: 50,right: 80),
            child:Text(widget.userDetail['land'],style: TextStyle(fontSize: 20,color: Colors.white),),
        )
      ),
      widget.type=="own" && is_artist!=true ? Container(
            alignment: Alignment(-0.9,-0.2),
            child: OutlineButton(
              child: Text("علاقه ها",style: TextStyle(fontSize: 28,fontWeight: FontWeight.w800),),
              textColor: Colors.indigoAccent,
              highlightedBorderColor:Colors.indigoAccent,
              splashColor: Colors.indigoAccent,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed:() async {
           var likeList=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,Music.album_id,Liked.date FROM Liked,Music WHERE Liked.user_id="${widget.userDetail['id']}" AND Music.id=Liked.music_id');
           if(likeList.isEmpty){
             showDialog(barrierDismissible: false,context: context,builder: (BuildContext context){return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                  title: Stack(children: <Widget>[
                    Align(alignment:Alignment.centerRight,child:
                    Text('خطا',textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.w900),)),
                    Icon(Icons.error_outline,color: Colors.red,size: 30),
                  ],),
                  content: Text('علاقه های شما خالی است',textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                  actions: <Widget>[FlatButton(child: Text('باشه',style: TextStyle(color: Colors.blue,fontSize: 17)),onPressed: (){Navigator.of(context).pop();},),],
                );});
           }
           else{
             setState(() {
               liked=likeList;
               Navigator.push(context, PageTransition(child: Favorite(database: widget.database),type: PageTransitionType.fade));
             });
           }
        }
            )):Container()
      ]),
    ));
  }
}