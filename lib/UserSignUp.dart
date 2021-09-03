import 'dart:io';
import 'package:db_project/Playlist.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:password/password.dart';
import 'package:sqflite/sqflite.dart';

import 'UserDashboard.dart';

class UserSignUp extends StatefulWidget {
  final Database database;
  UserSignUp({Key key,this.database});
  @override
  _UserSignUp createState() => _UserSignUp();
}

class _UserSignUp extends State<UserSignUp> {
  File _image;
  Database _database;
  bool imagedeleted=false;
  bool _isButtonDisabled_land=true;
  bool _isButtonDisabled_email=true;
  bool _isButtonDisabled_name=true;
  bool _isButtonDisabled_password=true;
  final name=TextEditingController();
  //String _name;
  final email=TextEditingController();
  //String _email;
  final password=TextEditingController();
  //String _password;
  final land=TextEditingController();
  //String _land;
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
        title: Text("ثبت نام کاربر",style: TextStyle(color: Colors.white,fontSize: 25),),
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
            child: Align(
              alignment: Alignment(0.83,-0.35),
              child: Text(" : نام",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.8,-0.06),
              child: Text(" : ایمیل",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.83,0.22),
              child: Text(" : رمز عبور",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.85,0.5),
              child: Text(" : نام منطقه",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          new Container(
                          alignment: Alignment(0, -0.37),
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
                            hintStyle: TextStyle(color: Colors.white60),
                              hintText:"مثال: علی",
                            ))
                      ) ,
                    ),
                     new Container(
                          alignment: Alignment(0, -0.07),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
                              controller: email,
                              onChanged:(_text2) {
                                _text2=email.text;
                                if (_text2.isNotEmpty) {
                                      setState(() => _isButtonDisabled_email = false);                             
                                }
                                else{
                                      setState(() => _isButtonDisabled_email = true);  
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
                              hintText:"example@gmail.com :مثال",
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, 0.23),
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
                            hintStyle: TextStyle(color: Colors.white60),
                              hintText:"djf&^^(*)dljfns342l",
                            ))
                      ) ,
                    ),
                    new Container(
                          alignment: Alignment(0, 0.53),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
                              controller: land,
                              onChanged:(_text4) {
                                _text4=land.text;
                                if (_text4.isNotEmpty) {
                                      setState(() => _isButtonDisabled_land = false);                             
                                }
                                else{
                                      setState(() => _isButtonDisabled_land = true);  
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
                              hintText:"مثال: ایران",
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
        onPressed: _isButtonDisabled_email==false && _isButtonDisabled_name==false &&
        _isButtonDisabled_password == false && _isButtonDisabled_land==false ?
            () async {
              _database=widget.database;
              var user_counts=await _database.rawQuery("SELECT id FROM User");
              var user_id=(user_counts);
              int id=0;
              if (user_id.isEmpty){
                id=1;
              }
              else {
                id=user_id[user_id.length-1]['id']+1;
              }
              var hashed_password=Password.hash(password.text, new PBKDF2());
              try{
              if (_image==null){
                var user_adding=await _database.rawInsert('INSERT INTO User(id,name,email,hashed_password,land,image_reference) VALUES($id,"${name.text}","${email.text}","$hashed_password","${land.text}",NULL)');
              }
              else {
                var user_adding=await _database.rawInsert('INSERT INTO User(id,name,email,hashed_password,land,image_reference) VALUES($id,"${name.text}","${email.text}","$hashed_password","${land.text}","${_image.path}")');
              }
              var userDetail=await _database.rawQuery('SELECT * FROM User WHERE User.id="$id"');
              // print("User Table");
              // print(users);
              // var _users=await _database.rawQuery('SELECT * FROM User WHERE User.id="$id"');
              // var _playlists= await _database.rawQuery('SELECT Playlist.name,Playlist.description,Playlist.image_reference FROM Playlist_Follow,Playlist,User WHERE Playlist_Follow.user_id=User.id and Playlist_Follow.user_email=User.email and Playlist_Follow.playlist_id=Playlist.id');
              // print(_playlists);
              //var _playlists=await widget.database.rawQuery('SELECT Playlist.name,Playlist.description,Playlist.image_reference FROM Playlist,Playlist_Follow WHERE "$id"=Playlist_Follow.user_id and "${email.text}"=Playlist_Follow.user_email and Playlist.id=Playlist_Follow.playlist_id');
              playlists=[];
              user_ID=userDetail[0]['id'];
              user_EMAIL=userDetail[0]['email'];
              Navigator.push(context, PageTransition(child: UserDashboard(userDetail:userDetail[0],database: widget.database),type: PageTransitionType.fade));
              }
              on Exception catch(_){
                 showDialog(barrierDismissible: false,context: context,builder: (BuildContext context){return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                  title: Stack(children: <Widget>[
                    Align(alignment:Alignment.centerRight,child:
                    Text('خطا',textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.w900),)),
                    Icon(Icons.error_outline,color: Colors.red,size: 30),
                  ],),
                  content: Text('یک حساب کاربری با این ایمیل به ثبت رسیده است.  لطفا یک ایمیل دیگر وارد کنید',textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                  actions: <Widget>[FlatButton(child: Text('باشه',style: TextStyle(color: Colors.blue,fontSize: 17)),onPressed: (){Navigator.of(context).pop();},),],
                );});
              }
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
