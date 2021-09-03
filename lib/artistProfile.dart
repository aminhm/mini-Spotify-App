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


class ArtistProfile extends StatefulWidget{
  final Map<String, dynamic> artistDetail;
  final Database database;
  ArtistProfile({Key key,this.artistDetail,this.database});
  @override 
  createState()=>_ArtistProfile();
}
class _ArtistProfile extends State<ArtistProfile>{

  TextEditingController _username=TextEditingController();
  TextEditingController _about=TextEditingController();

  void initState(){
    super.initState();
    _username=TextEditingController(text: widget.artistDetail['username']);
    if(widget.artistDetail['about']==null){_about=TextEditingController(text: widget.artistDetail['ندارد']);}
    else{_about=TextEditingController(text: widget.artistDetail['about']);}
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: MaterialApp(debugShowCheckedModeBanner: false,
        home:
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('حساب کاربری',style: TextStyle(fontSize: 26,color: Colors.indigoAccent),),
          backgroundColor: Colors.black45,
        ),
        body:Stack(children:<Widget>[new GestureDetector(
            onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
           },),
           Container(
             alignment: Alignment(0,-0.02),
             child: FlatButton(
               child: Text("دنبال کننده ها",style: TextStyle(color: Colors.blue[200],fontSize: 25),),
               onPressed: () async {
                 var followings=await widget.database.rawQuery('SELECT User.id,User.image_reference,User.name,User.land,User.email FROM User,Artist_Follow WHERE User.id=Artist_Follow.user_id and User.email=Artist_Follow.user_email and "$artist_ID"=Artist_Follow.artist_id and "$artist_Username"=Artist_Follow.artist_username');
                 Navigator.push(context, PageTransition(child: SearchPage(type:"User",database: widget.database,list: followings,),type: PageTransitionType.fade));
               },
             ),
           ),
           widget.artistDetail['is_verified']=="TRUE" ?
           Container(
             alignment: Alignment(0,-0.22),
             child: Icon(IconData(0xe9a9,fontFamily: "Verify"),color: Colors.blue,size: 40,),
           ):Container(),
           Container(
             alignment: Alignment(0,-0.9),
             child: (widget.artistDetail['image_reference']==null) ? ClipOval(
                child: Material(
                  color: Colors.pink[50],
                  child: InkWell(
                    splashColor: Colors.pink[200],
                    child: SizedBox(width: 140,height: 140,child: Icon(Icons.add_a_photo,size: 40,color: Colors.black45,)),
                  ),
                )):
              CircleAvatar(
              backgroundImage:AssetImage(widget.artistDetail['image_reference']) ,
              radius:100 ,
              backgroundColor: Colors.pink[50],
              child: Container(
            height: 150,
            width: 150,
          ),  
           )),      
        Align(
          alignment: Alignment(0.85,0.25),
          child: Icon(IconData(0xe9a9,fontFamily: "Name"),color: Colors.indigoAccent,),
        ),
        Align(
          alignment: Alignment(0.13,0.25),
          child: Padding(
            padding: EdgeInsets.only(left: 50,right: 80),
            child:Text(widget.artistDetail['username'],style: TextStyle(fontSize: 25,color: Colors.white),),
        )
      ),
      Align(
          alignment: Alignment(0.85,0.5),
          child: Icon(Icons.info,color: Colors.indigoAccent),
        ),
        Align(
          alignment: Alignment(0.13,0.5),
          child: Padding(
            padding: EdgeInsets.only(left: 50,right: 80),
            child: widget.artistDetail['about']!=null ? Text(widget.artistDetail['about'],style: TextStyle(fontSize: 25,color: Colors.white),):Text('ندارد',style: TextStyle(fontSize: 25,color: Colors.white),),
        )
      ),
      ]),
    )));
  }
}