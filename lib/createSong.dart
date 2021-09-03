import 'dart:io';
import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/Playlist.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/createAlbum.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:password/password.dart';
import 'package:sqflite/sqflite.dart';

import 'UserDashboard.dart';

class CreateSong extends StatefulWidget {
  final Database database;
  final String imagePath;
  CreateSong({Key key,this.database,this.imagePath});
  @override
  _CreateSong createState() => _CreateSong();
}

class _CreateSong extends State<CreateSong> {
  bool _isButtonDisabled_title=true;
  bool _isButtonDisabled_duration=true;
  bool _isButtonDisabled_isActive=true;
  bool _isButtonDisabled_isExplicit=true;
  final title=TextEditingController();
  final duration=TextEditingController();
  final isActive=TextEditingController();
  final isExplicit=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios) , onPressed: (){Navigator.pop(context);}),
        backgroundColor: Colors.black,
        title: Text("اضافه کردن آهنگ",style: TextStyle(color: Colors.white,fontSize: 25),),
      ),
      body: Stack(
        
        children: <Widget>[
          new GestureDetector(
                        onTap: () {
                     FocusScope.of(context).requestFocus(new FocusNode());
                      },),
          Container(
            child: Align(
              alignment: Alignment(0.83,-0.8),
              child: Text(" : عنوان",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.8,-0.4),
              child: Text(" : مدت زمان به ثانیه",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.83,0),
              child: Text(" : فعال",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.83,0.4),
              child: Text(" : الفاظ رک",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          new Container(
                          alignment: Alignment(0, -0.87),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              cursorColor: Colors.pink,
                              controller: title,
                              onChanged:(_text1) {
                                _text1=title.text;
                                if (_text1.isNotEmpty) {
                                      setState(() => _isButtonDisabled_title = false); 
                                      //_name=_text1;                            
                                }
                                else{
                                      setState(() => _isButtonDisabled_title = true);  
                                }
                              },
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            hintStyle: TextStyle(color: Colors.white60),
                              hintText:"مثال: هزار و یک شب",
                            ))
                      ) ,
                    ),
                     new Container(
                          alignment: Alignment(0, -0.45),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:200,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
                              controller: duration,
                              onChanged:(_text2) {
                                _text2=duration.text;
                                if (_text2.isNotEmpty) {
                                      setState(() => _isButtonDisabled_duration = false);                             
                                }
                                else{
                                      setState(() => _isButtonDisabled_duration = true);  
                                }
                              },
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            hintStyle: TextStyle(color: Colors.white60),
                              hintText:"243 :مثال",
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, 0),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
                              controller: isActive,
                              onChanged:(_text3) {
                                _text3=isActive.text;
                                if (_text3=="خیر" || _text3=="بله") {
                                      setState(() => _isButtonDisabled_isActive = false);                             
                                }
                                else{
                                      setState(() => _isButtonDisabled_isActive = true);  
                                }
                              },
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            hintStyle: TextStyle(color: Colors.white60),
                              hintText:"بله - خیر",
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, 0.43),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              cursorColor: Colors.pink,
                              controller: isExplicit,
                              onChanged:(_text1) {
                                _text1=isExplicit.text;
                                if (_text1=="دارد" || _text1=="ندارد") {
                                      setState(() => _isButtonDisabled_isExplicit = false);                           
                                }
                                else{
                                      setState(() => _isButtonDisabled_isExplicit = true);  
                                }
                              },
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            hintStyle: TextStyle(color: Colors.white60),
                              hintText:"دارد - ندارد",
                            ))
                      ) ,
                    ),
          Container(
            alignment: Alignment(0,0.8),
            child: OutlineButton(
              textColor: Colors.pink,
              highlightedBorderColor: Colors.pink,
              splashColor: Colors.pink,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed: _isButtonDisabled_duration==false && _isButtonDisabled_title==false &&
        _isButtonDisabled_isActive == false && _isButtonDisabled_isExplicit==false?
            () async {
              String _duration=duration.text;
              String active;
              String explixit;
              if(isActive.text=="بله"){active="TRUE";}
              else{active="FALSE";}
              if(isExplicit.text=="دارد"){explixit="TRUE";}
              else{explixit="FALSE";}
              if(widget.imagePath.isNotEmpty){
              createMusicForAlbum.add(
                {
                  'title' : title.text,
                  'duration' : _duration,
                  'is_active' : active,
                  'is_explicit' : explixit,
                  'number_of_plays' : 0,
                  'file_reference' : '/Users/aminhasanzadehmoghadam/Desktop/db/${title.text}.mp3',
                  'cover_reference' : "${widget.imagePath}"
                }
              );}
              else{
                createMusicForAlbum.add(
                {
                  'title' : title.text,
                  'duration' : _duration,
                  'is_active' : active,
                  'is_explicit' : explixit,
                  'number_of_plays' : 0,
                  'file_reference' : '/Users/aminhasanzadehmoghadam/Desktop/db/${title.text}.mp3',
                }
              );
              }
              Navigator.pop(context);
        }
        :null,
        child: Text("ثبت اطلاعات",style: TextStyle(fontSize: 30),),
      ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
