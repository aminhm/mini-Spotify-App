import 'dart:io';
import 'package:db_project/Playlist.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/musicDetail.dart';
import 'package:db_project/musicDetail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';
class PlaylistDetail extends StatefulWidget{
  final bool followIcon;
  final String type;
  final int id;
  final String name;
  final String about;
  final String imageReference;
  final Database database;
  final int numberOfSongs;
  final int duration;
  PlaylistDetail({Key key,this.duration,this.numberOfSongs,this.followIcon,this.type,this.about,this.name,this.imageReference,this.id,this.database});
  @override
  _PlaylistDetail createState()=>_PlaylistDetail();

}

class _PlaylistDetail extends State<PlaylistDetail>{
  bool follow_icon=false;
  File _image;
  Database _database;
  bool _isButtonDisabled_description=true;
  bool _isButtonDisabled_name=true;
  bool _isButtonDisabled_image=true;
  bool _isImageDeleted=true;
  TextEditingController name=TextEditingController();
  TextEditingController description=TextEditingController();

  String duration(){
  int hour=(widget.duration~/3600);
  int min=(widget.duration~/60);
  int seconds=widget.duration-(widget.duration~/60)*60;
  if (seconds<10){
    if(hour<10){
      if(min<10){
        return "0$hour : 0$min : 0$seconds";
      }
      return "0$hour : $min : 0$seconds";
    }
    return "$hour : $min : 0$seconds";
  }
  else{
    if(hour<10){
      if(min<10){
        return "0$hour : 0$min : $seconds";
      }
      return "0$hour : $min : $seconds";
    }
    return "$hour : $min : $seconds";
  }
}

  void initState(){
    super.initState();
    name=new TextEditingController(text: widget.name);
    description=new TextEditingController(text: widget.about);
    follow_icon=widget.followIcon;
  }
  Widget playlist_pic(List<Map<String, dynamic>> _pl,int index){
    if (_pl[index]['cover_reference']!=null){
    return CircleAvatar(
          backgroundColor: Colors.pink[50],
          backgroundImage: AssetImage(_pl[index]['cover_reference'])
          );
          }
    else{
        return CircleAvatar(
          backgroundColor: Colors.pink[50],
          child: Container(
            alignment: Alignment.center,
            child: Icon(Icons.photo,color: Colors.pink,),
          ),

        );}
  }

  Future getImageFromGallery() async {// for gallery
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _isButtonDisabled_image=false;
    });
  }
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex: 1,
      length: 2,child:MaterialApp(debugShowCheckedModeBanner: false,
        home:
      Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(
        actions: widget.type!="own" ? <Widget>[
          follow_icon==false ?
          FlatButton(
            onPressed: () async {
              var artist_follow=await widget.database.rawInsert('INSERT INTO Playlist_Follow (playlist_id,user_id,user_email) VALUES ("${widget.id}","$user_ID","$user_EMAIL")');
              setState(() {
                follow_icon=true;
              });

            },
            child: Text("Follow",style: TextStyle(fontSize: 20,color: Colors.blue),),
          ):FlatButton(
            onPressed: () async {
              var artist_follow_delete=await widget.database.rawDelete('DELETE FROM Playlist_Follow WHERE user_id = "$user_ID" and user_email="$user_EMAIL" and playlist_id="${widget.id}"');
              setState(() {
                follow_icon=false;
              });
            },
            child: Text("Unfollow",style: TextStyle(fontSize: 20,color: Colors.red),),)
        ]:[],
        title: Text(widget.name),
        bottom: TabBar(
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          tabs: [
          new Tab(child: widget.type=="own" ? Text("ویرایش",style: TextStyle(fontSize: 22,color: Colors.indigoAccent),):Text("اطلاعات",style: TextStyle(fontSize: 22,color: Colors.indigoAccent),),),
          new Tab(child: Text("موزیک ها",style: TextStyle(fontSize: 22,color: Colors.indigoAccent),),),
        ],),  
        //: controller,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        //title: Text(widget.name)
      ),
      body: Stack(
        children: <Widget>[
          new GestureDetector(
                        onTap: () {
                     FocusScope.of(context).requestFocus(new FocusNode());
                      },),
          TabBarView(children: [
            Stack(children:[
              widget.type!="own" ? Container(
            child: Align(
              alignment: Alignment(0.82,0.46),
              child: Text(" : زمان کل",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ):Container(),
          widget.type!="own" ? Container(
            child: Align(
              alignment: Alignment(0,0.46),
              child: Text(duration(),style: TextStyle(fontSize: 20,color: Colors.pink[200]),),
            ),
          ):Container(),
              widget.type!="own" ? Container(
            child: Align(
              alignment: Alignment(0.82,0.23),
              child: Text(" : تعداد موزیک",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ):Container(),
          widget.type!="own" ? Container(
            child: Align(
              alignment: Alignment(0,0.23),
              child: Text("${widget.numberOfSongs}",style: TextStyle(fontSize: 20,color: Colors.pink[200]),),
            ),
          ):Container(),
            Container(
            alignment: Alignment(0,-0.9),
              child: _image==null && widget.imageReference==null? ClipOval(
                child: Material(
                  color: Colors.pink[50],
                  child: InkWell(
                    splashColor: Colors.pink[200],
                    onTap: widget.type=="own" ? (){
                      getImageFromGallery();
                    }:null,
                    child: SizedBox(width: widget.type=="own" ? 120 : 160,height: widget.type=="own" ? 120 : 160,child: Icon(Icons.add_a_photo,size: 50,color: Colors.black45,)),
                  ),
                ),
              ): _image==null && widget.imageReference.isNotEmpty ?
              
              CircleAvatar(
              backgroundImage:AssetImage(widget.imageReference) ,
              radius: widget.type=="own" ? 50 : 85 ,
              backgroundColor: Colors.pink[50],
              child: Container(
            height: 102,
            width: 102,
            child: widget.type=="own" ? OutlineButton(
              
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
                onPressed: (){
                  getImageFromGallery();
                }): Container(),
          ),
            //),
          ): 
           CircleAvatar(
              backgroundImage:AssetImage(_image.path) ,
              radius: 50,
              backgroundColor: Colors.pink[50],
              child: Container(
            height: 102,
            width: 102,
            child: widget.type=="own" ? OutlineButton(
              
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
                onPressed: (){
                  getImageFromGallery();
                }):Container(),
          ),
            //),
          )
          )
          ,
          widget.type=="own" ? Container(
            alignment: Alignment(-0.05,-0.5),
            child: FlatButton(onPressed:(){
              setState(() {
                _image=null;
                _isImageDeleted=false;
                _isButtonDisabled_image=false;
              });
            } , child: Text("حذف عکس",style: TextStyle(fontSize: 23,color: Colors.pink),)),
          ): Container(),
          Container(
            child: Align(
              alignment: Alignment(0.85,-0.23),
              child: Text(" : نام",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment(0.83,0),
              child: Text(" : توضیحات ",style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
          ),
          widget.type=="own" ? new Container(
                          alignment: Alignment(0, -0.25),
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
                    ): Container(
                      alignment: Alignment(0,-0.24),
                      child: Text(widget.name,style: TextStyle(color: Colors.pink[200],fontSize: 25),),
                    ),
                    widget.type=="own" ? new Container(
                          alignment: Alignment(0, 0.5),
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 35,right:120,top: 5,bottom: 5,),
                            child:
                            new TextFormField(
                              style: TextStyle(fontSize: 18,color: Colors.white),
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 10,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.pink,
                              controller: description,
                              onChanged:(_text1) {
                                _text1=description.text;
                                      setState(() => _isButtonDisabled_description = false); 
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
                    ):Container(
                      alignment: Alignment.center,
                      child: widget.about!=null ? Text(widget.about,style: TextStyle(color: Colors.white,fontSize: 30),):Text("ندارد",style: TextStyle(fontSize: 25,color: Colors.pink[200]),),
                    ),
          widget.type=="own" ? Container(
            alignment: Alignment(0,0.9),
            child: OutlineButton(
              highlightedBorderColor: Colors.pink,
              splashColor: Colors.pink,
        padding: EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100)),
        onPressed: _isButtonDisabled_name==false || _isButtonDisabled_image==false || _isButtonDisabled_description==false ?
            () async {
              var _newPlaylist;
              if(_image!=null){
                _newPlaylist=await widget.database.rawUpdate('UPDATE Playlist SET name=?,description=?,image_reference=? WHERE Playlist.id=?',[name.text,description.text,_image.path,"${widget.id}"]);}
              else if (_isImageDeleted==false && _image==null){
                _newPlaylist=await widget.database.rawUpdate('UPDATE Playlist SET name=?,description=?,image_reference=? WHERE Playlist.id=?',[name.text,description.text,null,"${widget.id}"]);
              }
              else{
                _newPlaylist=await widget.database.rawUpdate('UPDATE Playlist SET name=?,description=? WHERE Playlist.id=?',[name.text,description.text,"${widget.id}"]);}
              
                 var _playlists=await widget.database.rawQuery('SELECT * FROM Playlist WHERE "$user_ID"=Playlist.user_id and "$user_EMAIL"=Playlist.user_email ');
                 //var _playlists=await widget.database.rawQuery('SELECT * FROM Playlist');
                 playlists=_playlists;
                Navigator.pop(context);
              }
        
        :null,
        child: Text("ثبت",style: TextStyle(fontSize: 25,color: Colors.pink),),
      ),
            ) : Container()
        ]
        ),
          ListView.builder(
      itemExtent: 115,
      itemCount: on_playlists.length,
      itemBuilder: (BuildContext context,int index){
        return Container(
          padding: EdgeInsets.only(top:15,left: 15,right: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.indigo[800],width: 3))
          ),
          child:
        ListTile(subtitle:on_playlists[index]['date_of_add'] !=null ? Text('''
        
                     ${on_playlists[index]['date_of_add']}''',style: TextStyle(color: Colors.white),):null ,
          leading:
        Container(
          height: 60,
          width: 60,
          child: playlist_pic(on_playlists,index)
        )
        ,
          trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,)
          ,
          title: Text(on_playlists[index]['title'],textAlign: TextAlign.center,style: TextStyle(fontSize: 25,
          color: Colors.white
          )),
          onLongPress: (){
            if(widget.type=="own"){
            showDialog(barrierDismissible: false,context: context,builder: (BuildContext context){return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                  title: Stack(children: <Widget>[
                    Align(alignment:Alignment.centerRight,child:
                    Text('حذف',textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.w900),)),
                    Icon(Icons.delete,color: Colors.red,size: 30),
                  ],),
                  content: Text('این موزیک از پلی لیست حذف شود؟',textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                  actions: <Widget>[FlatButton(child: Text('بله',style: TextStyle(color: Colors.blue,fontSize: 20)),onPressed: () async {
                    await widget.database.rawDelete('DELETE FROM On_Playlist WHERE On_Playlist.music_id="${on_playlists[index]['id']}" AND On_Playlist.playlist_id="${widget.id}"');
                    var _on_playlist=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${widget.id}" AND Music.id=On_Playlist.music_id');
                    setState(() {
                      on_playlists=_on_playlist;
                    });
                    Navigator.of(context).pop();
                  },),
                  FlatButton(child: Text('خیر',style: TextStyle(color: Colors.blue,fontSize: 20)),onPressed: (){Navigator.of(context).pop();},)],
                );});}},
          onTap: () async {
            var album_name=await widget.database.rawQuery('SELECT * FROM Album WHERE Album.id="${on_playlists[index]['album_id']}"');
            var music_detail=await widget.database.rawQuery('SELECT * FROM Music WHERE Music.id="${on_playlists[index]['id']}"');
            var artistsname=await widget.database.rawQuery('SELECT _In.artist_username,_In.is_owner FROM _In,Artist WHERE _In.album_id="${album_name[0]['id']}" and _In.artist_username=Artist.username');
            Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: MusicDetail(artistsNames: artistsname,icons:false,database: widget.database,albumName: album_name[0]['title'],musicDetail: music_detail[0],)));
            },
        ));
      },
    )
       ],
      ),
        ]
        )
        )
        ));
  }
}