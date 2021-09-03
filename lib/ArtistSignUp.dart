import 'dart:io';
import 'package:db_project/ArtistDashboard.dart';
import 'package:db_project/ArtistLogIn.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:password/password.dart';
import 'package:sqflite/sqflite.dart';

class ArtistSignUp extends StatefulWidget {
  final Database database;
  ArtistSignUp({Key key,this.database});
  @override
  _ArtistSignUp createState() => _ArtistSignUp();
}

class _ArtistSignUp extends State<ArtistSignUp> {
  File _image;
  Database _database;
  bool imagedeleted=false;
  bool _isButtonDisabled_name=true;
  bool _isButtonDisabled_password=true;
  final username=TextEditingController();
  final password=TextEditingController();
  final about=TextEditingController();
  int _counter = 0;
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
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
        backgroundColor: Colors.black,
        title: Text("ثبت نام هنرمند",style: TextStyle(color: Colors.pink,fontSize: 25),),
      ),
      body: Stack(
        
        children: <Widget>[
          new GestureDetector(
                        onTap: () {
                     FocusScope.of(context).requestFocus(new FocusNode());
                      },),
                      imagedeleted == true && _image!=null ? Container(
            alignment: Alignment(-0.05,-0.6),
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
            alignment: Alignment(0,-0.9),
              child: _image==null ? ClipOval(
                child: Material(
                  color: Colors.pink[50],
                  child: InkWell(
                    splashColor: Colors.pink[200],
                    onTap: (){
                      getImageFromGallery();
                    },
                    child: SizedBox(width: 100,height: 100,child: Icon(Icons.add_a_photo,size: 40,color: Colors.black45,)),
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

          ),
          Container(
            child: Align(
              alignment: Alignment(0.85,-0.38),
              child: Text(" : نام کاربری",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.83,-0.145),
              child: Text(" : رمز عبور",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.85,0.1),
              child: Text(" : توضیحات",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          new Container(
                          alignment: Alignment(0, -0.4),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 18),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              cursorColor: Colors.pink,
                              controller: username,
                              onChanged:(_text1) {
                                _text1=username.text;
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
                            hintStyle: TextStyle(color: Colors.pink[50]),
                              hintText:"amin_hm_piano",
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, -0.15),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(fontSize: 18,color: Colors.white),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
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
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            hintStyle: TextStyle(color: Colors.pink[50]),
                              hintText:"djf&^^(*)dljfns342l",
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, 0.45),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextField(
                              style: TextStyle(color: Colors.white,fontSize: 18),
                              maxLines: 9,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
                              controller: about,
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink,)
                              ,borderRadius: BorderRadius.circular(30)
                            ),
                            hintStyle: TextStyle(color: Colors.pink[50]),
                              hintText:" ... پیج شخصی امین حسن زاده",
                            ))
                      ) ,
                    ),
          Container(
            alignment: Alignment(0,0.8),
            child: OutlineButton(
              highlightedBorderColor: Colors.pink,
              splashColor: Colors.pink,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed: _isButtonDisabled_name==false && _isButtonDisabled_password == false ?
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
              var artist_adding;
              try{
              if (_image==null){
                if(about.text.isNotEmpty){
                artist_adding=await _database.rawInsert('INSERT INTO Artist(id,username,hashed_password,about,is_verified,image_reference) VALUES($id,"${username.text}","$hashed_password","${about.text}","FALSE",NULL)');}
                artist_adding=await _database.rawInsert('INSERT INTO Artist(id,username,hashed_password,about,is_verified,image_reference) VALUES($id,"${username.text}","$hashed_password",NULL,"FALSE",NULL)');
              }
              else {
                if(about.text.isNotEmpty){
                artist_adding=await _database.rawInsert('INSERT INTO Artist(id,username,hashed_password,about,is_verified,image_reference) VALUES($id,"${username.text}","$hashed_password","${about.text}","FALSE","${_image.path}")');}
                else{artist_adding=await _database.rawInsert('INSERT INTO Artist(id,username,hashed_password,about,is_verified,image_reference) VALUES($id,"${username.text}","$hashed_password",NULL,"FALSE","${_image.path}")');}
              }
              var artists=await _database.rawQuery("SELECT * FROM Artist");
              is_artist=true;
              artist_ID=artists[artists.length-1]['id'];
              artist_Username=username.text;
              print(artist_ID);
              print(artist_Username);
              var list=await _database.rawQuery('SELECT * FROM Artist WHERE Artist.id="$artist_ID" and Artist.username="$artist_Username"');
              Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: ArtistDashboard(artistDetail: list[0],database: _database,)));
              }
              on Exception catch(_){
                 showDialog(barrierDismissible: false,context: context,builder: (BuildContext context){return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                  title: Stack(children: <Widget>[
                    Align(alignment:Alignment.centerRight,child:
                    Text('خطا',textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.w900),)),
                    Icon(Icons.error_outline,color: Colors.red,size: 30),
                  ],),
                  content: Text('یک حساب کاربری با این نام کاربری به ثبت رسیده است.  لطفا یک نام کاربری دیگر وارد کنید',textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                  actions: <Widget>[FlatButton(child: Text('باشه',style: TextStyle(color: Colors.blue,fontSize: 17)),onPressed: (){Navigator.of(context).pop();},),],
                );});
              }
        }
        :null,
        child: Text("ثبت اطلاعات",style: TextStyle(fontSize: 25,color: Colors.pink),),
      ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
