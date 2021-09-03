import 'dart:io';
import 'package:db_project/Playlist.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqlite_api.dart';

class AddPlaylist extends StatefulWidget{
  final Database database;
  AddPlaylist({Key key,this.database});
  @override 
  _AddPlaylist createState() => _AddPlaylist();
}

class _AddPlaylist extends State<AddPlaylist>{
  File _image;
  Database _database;
  bool _isButtonDisabled_name=true;
  final name=TextEditingController();
  final description=TextEditingController();
  Future getImageFromGallery() async {// for gallery
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(home:
    Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,), onPressed:() {Navigator.pop(context);}),
        backgroundColor: Colors.black,
        title: Text("اضافه کردن پلی لیست",style: TextStyle(color: Colors.black,fontSize: 25),),
      ),
      body:Stack(
        
        children: <Widget>[
          new GestureDetector(
                        onTap: () {
                     FocusScope.of(context).requestFocus(new FocusNode());
                      },),
                      Container(
            alignment: Alignment(0,-0.9),
              child: _image==null ? ClipOval(
                child: Material(
                  color: Colors.pink,
                  child: InkWell(
                    splashColor: Colors.pink[200],
                    onTap: (){
                      getImageFromGallery();
                    },
                    child: SizedBox(width: 120,height: 120,child: Icon(Icons.add_a_photo,size: 50,color: Colors.white,)),
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
              alignment: Alignment(0.85,-0.3),
              child: Text(" : نام",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.83,0),
              child: Text(" : توضیحات ",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          new Container(
                          alignment: Alignment(0, -0.32),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              cursorColor: Colors.pink,
                              controller: name,
                              onChanged:(_text1) {
                                _text1=name.text;
                                if (_text1.isNotEmpty) {
                                      setState(() => _isButtonDisabled_name = false); 
                                      //_name=_text1;                            
                                }
                                else{
                                      setState(() => _isButtonDisabled_name = true);  
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
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, 0.45),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 10,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
                              controller: description,
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            ))
                      ) ,
                    ),
          Container(
            alignment: Alignment(0,0.9),
            child: OutlineButton(
              highlightedBorderColor: Colors.pink,
              splashColor: Colors.pink,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed: _isButtonDisabled_name==false ?
            () async {
              _database=widget.database;
              var playlist_adding;
              var playlist_follow_adding;
              if (_image==null){
                playlist_adding=await _database.rawInsert('INSERT INTO Playlist(name,user_id,user_email,description,image_reference) VALUES("${name.text}","$user_ID","$user_EMAIL","${description.text}",NULL)');
              }
              else {
                playlist_adding=await _database.rawInsert('INSERT INTO Playlist(name,user_id,user_email,description,image_reference) VALUES("${name.text}","$user_ID","$user_EMAIL","${description.text}","${_image.path}")');
              }
              // var playlist_counts=await _database.rawQuery("SELECT id FROM Playlist");
              //   int id=0;
              //   id=playlist_counts[playlist_counts.length-1]['id'];
              //   playlist_follow_adding=await _database.rawInsert('INSERT INTO Playlist_Follow(user_id,user_email,playlist_id) VALUES("$user_ID","$user_EMAIL","$id")');
                //print(playlist_follow_adding);
                var _playlists=await widget.database.rawQuery('SELECT * FROM Playlist WHERE "$user_ID"=Playlist.user_id and "$user_EMAIL"=Playlist.user_email');
                playlists=_playlists;
                Navigator.pop(context);
              }
        
        :null,
        child: Text("ثبت",style: TextStyle(fontSize: 25,color: Colors.pink),),
      ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}