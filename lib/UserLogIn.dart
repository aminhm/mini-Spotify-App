import 'dart:io';
import 'package:db_project/Playlist.dart';
import 'package:db_project/UserDashboard.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:password/password.dart';
import 'package:sqflite/sqflite.dart';

int user_ID;
String user_EMAIL;

class UserLogIn extends StatefulWidget {
  final Database database;
  UserLogIn({Key key,this.database});
  @override
  _UserLogIn createState() => _UserLogIn();
}

class _UserLogIn extends State<UserLogIn> {
  Database _database;
  bool _isButtonDisabled_email=true;
  bool _isButtonDisabled_password=true;
  final email=TextEditingController();
  final password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
        backgroundColor: Colors.black,
        title: Text("ورود کاربر",style: TextStyle(color: Colors.white,fontSize: 25),),
      ),
      body: Stack(
        
        children: <Widget>[
          new GestureDetector(
                        onTap: () {
                     FocusScope.of(context).requestFocus(new FocusNode());
                      },),
          Container(
            child: Align(
              alignment: Alignment(0.85,-0.5),
              child: Text(" : ایمیل",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.83,-0.2),
              child: Text(" : رمز عبور",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          new Container(
                          alignment: Alignment(0, -0.53),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              cursorColor: Colors.white,
                              controller: email,
                              onChanged:(_text1) {
                                _text1=email.text;
                                if (_text1.isNotEmpty) {
                                      setState(() => _isButtonDisabled_email = false); 
                                      //_name=_text1;                            
                                }
                                else{
                                      setState(() => _isButtonDisabled_email = true);  
                                }
                              },
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigoAccent,width: 3)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigoAccent,width: 3)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, -0.21),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.white,
                              controller: password,
                              onChanged:(_text3) {
                                _text3=password.text;
                                if (_text3.isNotEmpty) {
                                      setState(() => _isButtonDisabled_password = false);                             
                                }
                                else{
                                      setState(() => _isButtonDisabled_password = true);  
                                }
                              },
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigoAccent,width: 3)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigoAccent,width: 3)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            ))
                      ) ,
                    ),
          Container(
            alignment: Alignment(0,0.2),
            child: OutlineButton(
              textColor: Colors.indigoAccent,
              highlightedBorderColor:Colors.indigoAccent,
              splashColor: Colors.indigoAccent,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed: _isButtonDisabled_email==false && _isButtonDisabled_password == false ?
            () async {
              _database=widget.database;
              var user_counts=await _database.rawQuery("SELECT * FROM User");
              var user_id=(user_counts);
              int id=0;
              if (user_id.isEmpty){
                id=0;
              }
              else {
                id=user_id[user_id.length-1]['id'];
              }
              //var hashed_password=Password.hash(password.text, new PBKDF2());
              var hashed_password=password.text;
                var user_adding=await _database.rawQuery('SELECT id,email , hashed_password FROM User WHERE User.email="${email.text}" and User.hashed_password="$hashed_password"');

                if (user_adding.isEmpty){

                 showDialog(barrierDismissible: false,context: context,builder: (BuildContext context){return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                  title: Stack(children: <Widget>[
                    Align(alignment:Alignment.centerRight,child:
                    Text('خطا',textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.w900),)),
                    Icon(Icons.error_outline,color: Colors.red,size: 30),
                  ],),
                  content: Text('اطلاعات ورودی اشتباه است',textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                  actions: <Widget>[FlatButton(child: Text('باشه',style: TextStyle(color: Colors.blue,fontSize: 17)),onPressed: (){Navigator.of(context).pop();},),],
                );});
              }
              else{
              //   var _users=await _database.rawQuery('SELECT * FROM User WHERE User.id="$id"');
              // var _playlists= await _database.rawQuery('SELECT Playlist.name,Playlist.description,Playlist.image_reference FROM Playlist_Follow,Playlist,User WHERE Playlist_Follow.user_id=User.id and Playlist_Follow.user_email=User.email and Playlist_Follow.playlist_id=Playlist.id');
              //print(user_adding);
              var _playlists=await widget.database.rawQuery('SELECT * FROM Playlist WHERE "${user_adding[0]['id']}"=Playlist.user_id and "${email.text}"=Playlist.user_email ');
              playlists=_playlists;
              var userDetail=await widget.database.rawQuery('SELECT * FROM User WHERE User.id="${user_adding[0]['id']}"');
              user_ID=user_adding[0]['id'];
              user_EMAIL=user_adding[0]['email'];
              print(user_ID);
              print(user_EMAIL);
              Navigator.push(context, PageTransition(child: UserDashboard(userDetail:userDetail[0],database: widget.database),type: PageTransitionType.fade));
              }
              }
        
        :null,
        child: Text("ورود",style: TextStyle(fontSize: 30),),
      ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
