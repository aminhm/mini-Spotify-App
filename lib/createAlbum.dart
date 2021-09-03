import 'dart:io';
import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/createSong.dart';
import 'package:db_project/searchPage.dart';
import 'package:db_project/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqflite.dart';


List<Map<String, dynamic>> createMusicForAlbum=List<Map<String, dynamic>>();
List<Map<String, dynamic>> addArtist=List<Map<String, dynamic>>();

class CreateAlbum extends StatefulWidget {
  final Database database;
  CreateAlbum({Key key,this.database});
  @override
  _CreateAlbum createState() => _CreateAlbum();
}


class _CreateAlbum extends State<CreateAlbum> {
  bool imagedeleted=false;
  File _image;
  bool _isButtonDisabled_title=true;
  bool _isButtonDisabled_releaseYear=true;
  bool _isButtonDisabled_copyRight=true;
  final title=TextEditingController();
  final releaseYear=TextEditingController();
  final copyRight=TextEditingController();
  Future getImageFromGallery() async {// for gallery
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      imagedeleted=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
        backgroundColor: Colors.black,
        title: Text("ساخت آلبوم",style: TextStyle(color: Colors.white,fontSize: 25),),
      ),
      body: Stack(
        
        children: <Widget>[
          new GestureDetector(
                        onTap: () {
                     FocusScope.of(context).requestFocus(new FocusNode());
                      },),
            Container(
              alignment: Alignment(0.9,0.65),
              child: FlatButton(onPressed: (){
                String path;
                if(_image==null){path="NULL";}
                else{path=_image.path;}
                Navigator.push(context, PageTransition(child: CreateSong(imagePath: path,database: widget.database,),type: PageTransitionType.fade));
              }, child: Text("اضافه کردن آهنگ",style: TextStyle(fontSize: 25,color: Colors.green[200]),)),
            ),
            Container(
              alignment: Alignment(-0.9,0.65),
              child: FlatButton(onPressed: () async {
                var list=await widget.database.rawQuery('SELECT * FROM Artist WHERE Artist.id not in ("$artist_ID") and Artist.username not in ("$artist_Username")');
                Navigator.push(context, PageTransition(child: SearchPage(list: list,type: "Artist",database: widget.database,),type: PageTransitionType.fade));
              }, child: Text("اضافه کردن هنرمند",style: TextStyle(fontSize: 25,color: Colors.green[200]),)),
            ),
            imagedeleted == true && _image!=null ? Container(
            alignment: Alignment(-0.05,-0.55),
            child: FlatButton(onPressed: (){
              setState(() {
                _image=null;
              });
            }, child: Text("حذف عکس",style: TextStyle(color: Colors.green[200],fontSize: 25),)),
          ):Container(),
          Container(
            alignment: Alignment(0,-0.9),
              child: _image==null ? ClipOval(
                child: Material(
                  color: Colors.pink,
                  child: InkWell(
                    splashColor: Colors.pink,
                    onTap: (){
                      getImageFromGallery();
                    },
                    child: SizedBox(width: 100,height: 100,child: Icon(Icons.add_a_photo,size: 40,color: Colors.white,)),
                  ),
                ),
              ):
              
              CircleAvatar(
              backgroundImage:AssetImage(_image.path) ,
              radius: 50,
              backgroundColor: Colors.pink[50],
              child: Container(
            height: 102,
            width: 102,
            child: OutlineButton(
              
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
                onPressed: (){
                  getImageFromGallery();
                }),
          ),
            //),
          )),
          Container(
            child: Align(
              alignment: Alignment(0.83,-0.3),
              child: Text(" : عنوان",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.8,0),
              child: Text(" : سال انتشار",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.83,0.335),
              child: Text(" : کپی رایت",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          new Container(
                          alignment: Alignment(0, -0.33),
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
                          alignment: Alignment(0, 0),
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
                              controller: releaseYear,
                              onChanged:(_text2) {
                                _text2=releaseYear.text;
                                if (_text2.isNotEmpty) {
                                      setState(() => _isButtonDisabled_releaseYear = false);                             
                                }
                                else{
                                      setState(() => _isButtonDisabled_releaseYear = true);  
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
                              hintText:"2019 :مثال",
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, 0.35),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
                              controller: copyRight,
                              onChanged:(_text3) {
                                _text3=copyRight.text;
                                if (_text3=="خیر" || _text3=="بله") {
                                      setState(() => _isButtonDisabled_copyRight = false);                             
                                }
                                else{
                                      setState(() => _isButtonDisabled_copyRight = true);  
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
          Container(
            alignment: Alignment(0,0.95),
            child: OutlineButton(
              textColor: Colors.pink,
              highlightedBorderColor: Colors.pink,
              splashColor: Colors.pink,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed: _isButtonDisabled_releaseYear==false && _isButtonDisabled_title==false &&
        _isButtonDisabled_copyRight == false && createMusicForAlbum.isNotEmpty ?
            () async {
              String albumType;
              if(createMusicForAlbum.length==1){albumType="single";}
              else if(createMusicForAlbum.length>1 && createMusicForAlbum.length <5){albumType="ep";}
              else{albumType="album";}
              if(_image==null){var album_insert=await widget.database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep) VALUES ("${title.text}","${releaseYear.text}","${copyRight.text}","$albumType")');}
              else{var album_insert=await widget.database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep,image_reference) VALUES ("${title.text}","${releaseYear.text}","${copyRight.text}","$albumType","${_image.path}")');}
              var getAlbumId=await widget.database.rawQuery('SELECT id FROM Album');
              int album_ID=getAlbumId[getAlbumId.length-1]['id'];
              var insert_in=await widget.database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("$artist_ID","$artist_Username","$album_ID","$artist_Username")');
              for (int j=0 ; j <addArtist.length ; j++){
               await widget.database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("${addArtist[j]['artist_id']}","${addArtist[j]['artist_username']}","$album_ID","$artist_Username")');
              }
              for (int i=0 ; i <createMusicForAlbum.length ; i++){
                if(_image!=null){
                await widget.database.rawInsert('INSERT INTO Music (album_id,title,duration,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("$album_ID","${createMusicForAlbum[i]['title']}","${createMusicForAlbum[i]['duration']}","${createMusicForAlbum[i]['number_of_plays']}","${createMusicForAlbum[i]['file_reference']}","${createMusicForAlbum[i]['is_active']}","${createMusicForAlbum[i]['is_explicit']}","${createMusicForAlbum[i]['cover_reference']}")');}
                else{await widget.database.rawInsert('INSERT INTO Music (album_id,title,duration,number_of_plays,file_reference,is_active,is_explicit) VALUES ("$album_ID","${createMusicForAlbum[i]['title']}","${createMusicForAlbum[i]['duration']}","${createMusicForAlbum[i]['number_of_plays']}","${createMusicForAlbum[i]['file_reference']}","${createMusicForAlbum[i]['is_active']}","${createMusicForAlbum[i]['is_explicit']}")');}
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