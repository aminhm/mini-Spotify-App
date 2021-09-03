import 'dart:io';
import 'package:db_project/AddPlaylist.dart';
import 'package:db_project/ArtistDashboard.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:password/password.dart';
import 'package:sqflite/sqflite.dart';
bool is_artist=false;
int artist_ID;
String artist_Username;

class ArtistLogIn extends StatefulWidget {
  final Database database;
  ArtistLogIn({Key key,this.database});
  @override
  _ArtistLogIn createState() => _ArtistLogIn();
}

class _ArtistLogIn extends State<ArtistLogIn> {
  Database _database;
  bool _isButtonDisabled_username=true;
  bool _isButtonDisabled_password=true;
  final username=TextEditingController();
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
        title: Text("ورود هنرمند",style: TextStyle(color: Colors.indigoAccent,fontSize: 25),),
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
              child: Text(" : نام کاربری",style: TextStyle(fontSize: 20,color: Colors.white),),
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
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              cursorColor: Colors.indigoAccent,
                              controller: username,
                              onChanged:(_text1) {
                                _text1=username.text;
                                if (_text1.isNotEmpty) {
                                      setState(() => _isButtonDisabled_username = false); 
                                      //_name=_text1;                            
                                }
                                else{
                                      setState(() => _isButtonDisabled_username = true);  
                                }
                              },
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigoAccent,)
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
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.indigoAccent,
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
                              borderSide: BorderSide(color: Colors.indigoAccent,)
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
              highlightedBorderColor: Colors.indigoAccent,
              splashColor: Colors.indigoAccent,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed: _isButtonDisabled_username==false && _isButtonDisabled_password == false ?
            () async {
              _database=widget.database;
              var artist_counts=await _database.rawQuery("SELECT id FROM Artist");
              var artist_id=(artist_counts);
              int id=0;
              if (artist_id.isEmpty){
                id=0;
              }
              else {
                id=artist_id[artist_id.length-1]['id']+1;
              }
              var hashed_password=Password.hash(password.text, new PBKDF2());
                var artist_adding=await _database.rawQuery('SELECT * FROM Artist WHERE Artist.username="${username.text}" and Artist.hashed_password="$hashed_password"');

                if (artist_adding.isEmpty){

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
                is_artist=true;
                artist_ID=artist_adding[0]['id'];
                artist_Username=artist_adding[0]['username'];

                Navigator.push(context, PageTransition(child: ArtistDashboard(database: widget.database,artistDetail: artist_adding[0],),type: PageTransitionType.fade));}
              }
        
        :null,
        child: Text("ورود",style: TextStyle(fontSize: 28,color: Colors.indigoAccent),),
      ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
