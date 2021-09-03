import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/Playlist.dart';
import 'package:db_project/PlaylistDetail.dart';
import 'package:db_project/UserLogIn.dart';
import 'package:db_project/UserSignUp.dart';
import 'package:db_project/albumPage.dart';
import 'package:db_project/artistDetail.dart';
import 'package:db_project/createAlbum.dart';
import 'package:db_project/main.dart';
import 'package:db_project/musicDetail.dart';
import 'package:db_project/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqlite_api.dart';

import 'ArtistSignUp.dart';

class SearchPage extends StatefulWidget {
  final Database database;
  final String type;
  final List<Map<String, dynamic>> list;
  SearchPage({Key key,this.type,this.list,this.database,});
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  List<Map<String, dynamic>> querylist;
  bool _isButtonDisabled_search=true;
  bool _searchIconDisable=false;
  Widget appBartitle;
  final search=TextEditingController();
  void initState(){
    super.initState();
    if(widget.type=="Artist" || widget.type=="ArtistFollow"){
      setState(() => appBartitle=Text("...جست و جو هنرمند",style: TextStyle(fontSize: 20,color: Colors.white60),));
    }
    else if(widget.type=="Album"){
      setState(() => appBartitle=Text("...جست و جو آلبوم",style: TextStyle(fontSize: 20,color: Colors.white60),));
    }
    else if(widget.type=="Playlist"){
      setState(()=>appBartitle=Text("...جست و جو پلی لیست",style: TextStyle(fontSize: 20,color: Colors.white60),));
    }
    else if(widget.type=="Music" || widget.type=="MusicArtist"){
      setState(()=>appBartitle=Text("...جست و جو موزیک",style: TextStyle(fontSize: 20,color: Colors.white60),));
    }
    else if(widget.type=="User"){
      setState(()=>appBartitle=Text("...جست و جو کاربر",style: TextStyle(fontSize: 20,color: Colors.white60),));
    }
  }
  String backgroundimage(int index){
    if(_isButtonDisabled_search==true){
    if(widget.type=="Music" || widget.type=="MusicArtist"){
      return widget.list[index]['cover_reference'];
    }
    return widget.list[index]['image_reference'];
  }
  else{
    if(widget.type=="Music" || widget.type=="MusicArtist"){
      return querylist[index]['cover_reference'];
    }
    return querylist[index]['image_reference'];
  }
  }
  String appBaarTitleText(){
    if(widget.type=="Artist" || widget.type=="ArtistFollow"){
      setState(() => appBartitle=Text("...جست و جو هنرمند",style: TextStyle(fontSize: 20,color: Colors.white60),));
      return "...جست و جو هنرمند";
    }
    else if(widget.type=="Album"){
      setState(() => appBartitle=Text("...جست و جو آلبوم",style: TextStyle(fontSize: 20,color: Colors.white60),));
      return "...جست و جو آلبوم";
    }
    else if(widget.type=="Playlist"){
      appBartitle=Text("...جست و جو پلی لیست",style: TextStyle(fontSize: 20,color: Colors.white60),);
      return "...جست و جو پلی لیست";
    }
    else if(widget.type=="Music" || widget.type=="MusicArtist"){
      appBartitle=Text("...جست و جو موزیک",style: TextStyle(fontSize: 20,color: Colors.white60),);
      return "...جست و جو موزیک";
    }
    else if(widget.type=="User"){
      appBartitle=Text("...جست و جو کاربر",style: TextStyle(fontSize: 20,color: Colors.white60),);
      return "...جست و جو کاربر";
    }
  }
  String titleType(int index){
    if(_isButtonDisabled_search==true){
    if (widget.type=="Artist" || widget.type=="ArtistFollow"){
      return widget.list[index]['username'];
    }
    else if(widget.type=="Music" || widget.type=="Album" || widget.type=="MusicArtist"){
      return widget.list[index]['title'];
    }
    else{
      return widget.list[index]['name'];
    }
  }
  else{
    if (widget.type=="Artist" || widget.type=="ArtistFollow"){
      return querylist[index]['username'];
    }
    else if(widget.type=="Music" || widget.type=="Album" || widget.type=="MusicArtist"){
      return querylist[index]['title'];
    }
    else{
      return querylist[index]['name'];
    }
  }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back_ios),),
        backgroundColor: Colors.black45,
        title: appBartitle,
        actions: <Widget>[
          IconButton(icon: _searchIconDisable ==false ? Icon(Icons.search) : Icon(Icons.close) , 
          onPressed: _searchIconDisable==false ? (){
            setState(() {
              _searchIconDisable=true;
             appBartitle=
                            new TextFormField(
                              onChanged:(_searchText) async {
                                _searchText=search.text;
                                if (_searchText.isNotEmpty) {
                                  String searchWhat;
                                  List<Map<String, dynamic>> _querylist=List<Map<String, dynamic>>();
                                    String type=widget.type;
                                    if(widget.type=="ArtistFollow" || widget.type=="Artist"){type="Artist";searchWhat="username";}
                                    else if(widget.type=="MusicArtist" || widget.type=="Music"){type="Music";searchWhat="title";}
                                    else if(widget.type=="Playlist" || widget.type=="User"){searchWhat="name";}
                                    else if(widget.type=="Album"){searchWhat="title";}
                                      querylist=await widget.database.rawQuery('SELECT * FROM "$type" WHERE "$searchWhat" LIKE "%${search.text}%"');
                                      for (int i=0;i < querylist.length;i++){
                                        for (int j=0; j < widget.list.length; j++){
                                            if(querylist[i]['id']==widget.list[j]['id']){
                                              _querylist.add(widget.list[j]);
                                            }
                                        }
                                      }
                                      querylist=_querylist;
                                      setState(() {
                                         _isButtonDisabled_search = false;
                                         });

                                }
                                else{
                                      setState(() => _isButtonDisabled_search = true);  
                                      querylist=[];
                                }
                              },
                              style: TextStyle(color: Colors.white,fontSize: 20),
                              maxLines: 1,
                              autofocus: true,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              cursorColor: Colors.white,
                              controller: search,
                              decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,)
                            ),
                              enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,)
                            ),
                            )
                            );
            });
          } : (){
            setState(() {
              _searchIconDisable=false;
              if (search.text.isEmpty){
               appBartitle=Text(appBaarTitleText(),style: TextStyle(fontSize: 20,color: Colors.white70),);
            }
            else{
               appBartitle=Text(search.text,style: TextStyle(fontSize: 20,color: Colors.white70),);
            }
            });
                     
          })
        ],
      ),
      body:  ListView.builder(
      itemExtent: 115,
      itemCount: _isButtonDisabled_search==true ? widget.list.length : querylist.length,
      itemBuilder: (BuildContext context,int index){
        return Container(
          padding: EdgeInsets.only(top:15,left: 15,right: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.indigo[800],width: 3))
          ),
          child:
        ListTile(leading:
        Container(
          height: 60,
          width: 60,
          child :  backgroundimage(index)!=null ? CircleAvatar(
            backgroundImage:  AssetImage(backgroundimage(index))
          ):
          CircleAvatar(
          backgroundColor: Colors.pink[50],
          child: Container(
            alignment: Alignment.center,
            child: Icon(Icons.photo,color: Colors.pink,),
          ),

        )
        )
        ,
          trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,)
          ,
          title: Text(titleType(index),textAlign: TextAlign.center,style: TextStyle(fontSize: 25,
          color: Colors.white
          )),
          onTap: () async {
            if(_isButtonDisabled_search==true){
            if(widget.type=="Music" || widget.type=="MusicArtist"){
              var album_name=await widget.database.rawQuery('SELECT * FROM Album WHERE Album.id="${widget.list[index]['album_id']}"');
              var artists_names=await widget.database.rawQuery('SELECT _In.artist_username,_In.is_owner FROM _In,Artist WHERE _In.artist_id=Artist.id and _In.album_id="${album_name[0]['id']}" and Artist.username=_In.artist_username');
              var likedcheck=await widget.database.rawQuery('SELECT * FROM Liked WHERE Liked.user_id="$user_ID" and Liked.music_id="${widget.list[index]['id']}"');
              bool check;
              bool icons=true;
              if(widget.type=="MusicArtist" || is_artist==true){icons=false;}
              if (likedcheck.isEmpty){
                check=false;
              }
              else{
                check=true;
              }
              Navigator.push(context, PageTransition(child: MusicDetail(artistsNames:artists_names,fulllike: check,icons: icons,database: widget.database,albumName:album_name[0]['title'],musicDetail:widget.list[index] ,),type: PageTransitionType.fade));
            }
            else if(widget.type=="Album"){
              var duration=await widget.database.rawQuery('SELECT SUM(duration) FROM Music WHERE Music.album_id="${widget.list[index]['id']}"');
              var isOwner=await widget.database.rawQuery('SELECT _In.is_owner FROM _In,Artist WHERE _In.album_id="${widget.list[index]['id']}" and _In.artist_id=Artist.id and _In.artist_username=Artist.username');
              var musicCounts=await widget.database.rawQuery('SELECT COUNT(*) FROM Music WHERE Music.album_id="${widget.list[index]['id']}"');
              //var musicLists=await widget.database.rawQuerty('SELECT * FROM Music WHERE Music.album_id="${widget.list[index]['id']}"');
              //Navigator.push(context, PageTransition(child: SearchPage(list: musicLists,type: "Music",userID: widget.userID,database: widget.database,),type: PageTransitionType.fade));
              Navigator.push(context, PageTransition(child: AlbumDetail(duration:duration[0]['SUM(duration)'],count:musicCounts[0]['COUNT(*)'],isOwner:isOwner[0]['is_owner'],albumDetail: widget.list[index],database: widget.database,),type: PageTransitionType.fade));
            }
            else if(widget.type=="Artist" || widget.type=="ArtistFollow"){
              var add_artist_follow=await widget.database.rawQuery('SELECT * FROM Artist_Follow WHERE artist_id="${widget.list[index]['id']}" and artist_username="${widget.list[index]['username']}" and user_id="$user_ID" and user_email="$user_EMAIL"');
              bool follow_icon;
              follow_icon=false;
              if(is_artist==true){
                for (int i =0 ; i < addArtist.length; i++){
                  if(widget.list[index]['id']==addArtist[i]['artist_id']){
                    follow_icon=true;
                  }
                }
              }
              else if (add_artist_follow.isEmpty){
                follow_icon=false;
              }
              else{
                follow_icon=true;
              }
              Navigator.push(context, PageTransition(child: ArtistDetail(type: widget.type,followIcon:follow_icon,database: widget.database,artistDetail: widget.list[index],),type: PageTransitionType.fade));
            
            }
            else if(widget.type=="Playlist"){
              var _on_playlist=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${widget.list[index]['id']}" AND Music.id=On_Playlist.music_id');
              var _duration=await widget.database.rawQuery('SELECT SUM(Music.duration),Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${widget.list[index]['id']}" AND Music.id=On_Playlist.music_id');
            var _count=await widget.database.rawQuery('SELECT COUNT(*),Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${widget.list[index]['id']}" AND Music.id=On_Playlist.music_id');
            int duration=_duration[0]['SUM(Music.duration)'];
            if (duration==null){duration=0;}
            int count=_count[0]['COUNT(*)'];
              on_playlists=_on_playlist;
              var playlistDetail=await widget.database.rawQuery('SELECT * FROM Playlist WHERE Playlist.id="${widget.list[index]['id']}"');
              var add_playlist_follow=await widget.database.rawQuery('SELECT * FROM Playlist_Follow WHERE Playlist_Follow.playlist_id="${widget.list[index]['id']}" and Playlist_Follow.user_id="$user_ID" and Playlist_Follow.user_email="$user_EMAIL"');
              bool follow_icon;
              if (add_playlist_follow.isEmpty){
                follow_icon=false;
              }
              else{
                follow_icon=true;
              }
              Navigator.push(context, PageTransition(child: PlaylistDetail(duration:duration,numberOfSongs: count,followIcon: follow_icon,type:"other",about: playlistDetail[0]['about'],name: playlistDetail[0]['name'],id: playlistDetail[0]['id'],imageReference: playlistDetail[0]['image_reference'],database: widget.database,),type: PageTransitionType.fade));
            }
            else if(widget.type=="User"){
              String type;
              var follow_icon;
              if(is_artist==false){type="other";}else{type="own";}
              follow_icon=await widget.database.rawQuery('SELECT * FROM User_Follow WHERE User_Follow.follower_id="$user_ID" and User_Follow.follower_email="$user_EMAIL" and User_Follow.followed_id="${widget.list[index]['id']}" and User_Follow.followed_email="${widget.list[index]['email']}"');
              if(follow_icon.isEmpty){Navigator.push(context, PageTransition(child: UserProfile(followIcon: false,type: type,userDetail: widget.list[index],database: widget.database,),type: PageTransitionType.fade));}
              else{Navigator.push(context, PageTransition(child: UserProfile(followIcon: true,type: type,userDetail: widget.list[index],database: widget.database,),type: PageTransitionType.fade));}
            }
            }
            else{
              if(widget.type=="Music" || widget.type=="MusicArtist"){
                var album_name=await widget.database.rawQuery('SELECT * FROM Album WHERE Album.id="${querylist[index]['album_id']}"');
                var artists_names=await widget.database.rawQuery('SELECT _In.artist_username,_In.is_owner FROM _In,Artist WHERE _In.artist_id=Artist.id and _In.album_id="${album_name[0]['id']}" and Artist.username=_In.artist_username');
                var likedcheck=await widget.database.rawQuery('SELECT * FROM Liked WHERE Liked.user_id="$user_ID" and Liked.music_id="${querylist[index]['id']}"');
                bool check;
                bool icons=true;
              if(widget.type=="MusicArtist" || is_artist==true){icons=false;}
              if (likedcheck.isEmpty){
                check=false;
              }
              else{
                check=true;
              }
              Navigator.push(context, PageTransition(child: MusicDetail(artistsNames: artists_names,fulllike: check,icons: icons,database: widget.database,albumName:album_name[0]['title'],musicDetail:querylist[index] ,),type: PageTransitionType.fade));
            }
            else if(widget.type=="Album"){
              var duration=await widget.database.rawQuery('SELECT SUM(duration) FROM Music WHERE Music.album_id="${querylist[index]['id']}"');
              var musicCounts=await widget.database.rawQuery('SELECT COUNT(*) FROM Music WHERE Music.album_id="${querylist[index]['id']}"');
              var isOwner=await widget.database.rawQuery('SELECT _In.is_owner FROM _In,Artist WHERE _In.album_id="${querylist[index]['id']}" and _In.artist_id=Artist.id and _In.artist_username=Artist.username');
               Navigator.push(context, PageTransition(child: AlbumDetail(duration:duration[0]['SUM(duration)'],count:musicCounts[0]['COUNT(*)'],isOwner:isOwner[0]['is_owner'],albumDetail: querylist[index],database: widget.database,),type: PageTransitionType.fade));
            }
            else if(widget.type=="Artist" || widget.type=="ArtistFollow"){
              var add_artist_follow=await widget.database.rawQuery('SELECT * FROM Artist_Follow WHERE artist_id="${querylist[index]['id']}" and artist_username="${querylist[index]['username']}" and user_id="$user_ID" and user_email="$user_EMAIL"');
              bool follow_icon;
              if (add_artist_follow.isEmpty){
                follow_icon=false;
              }
              else{
                follow_icon=true;
              }
              print(follow_icon);
              Navigator.push(context, PageTransition(child: ArtistDetail(type: widget.type,followIcon:follow_icon,database: widget.database,artistDetail: querylist[index],),type: PageTransitionType.fade));
            
            }
            else if(widget.type=="Playlist"){
              var _on_playlist=await widget.database.rawQuery('SELECT Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${querylist[index]['id']}" AND Music.id=On_Playlist.music_id');
              var _duration=await widget.database.rawQuery('SELECT SUM(Music.duration),Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${querylist[index]['id']}" AND Music.id=On_Playlist.music_id');
            var _count=await widget.database.rawQuery('SELECT COUNT(*),Music.title,Music.duration,Music.number_of_plays,Music.file_reference,Music.is_active,Music.is_explicit,Music.id,Music.cover_reference,On_Playlist.date_of_add,Music.album_id FROM On_Playlist,Music WHERE On_Playlist.playlist_id="${querylist[index]['id']}" AND Music.id=On_Playlist.music_id');
            int duration=_duration[0]['SUM(Music.duration)'];
            if(duration==null){duration=0;}
            int count=_count[0]['COUNT(*)'];
              on_playlists=_on_playlist;
              var playlistDetail=await widget.database.rawQuery('SELECT * FROM Playlist WHERE Playlist.id="${querylist[index]['id']}"');
              var add_playlist_follow=await widget.database.rawQuery('SELECT * FROM Playlist_Follow WHERE Playlist_Follow.playlist_id="${querylist[index]['id']}" and Playlist_Follow.user_id="$user_ID" and Playlist_Follow.user_email="$user_EMAIL"');
              bool follow_icon;
              if (add_playlist_follow.isEmpty){
                follow_icon=false;
              }
              else{
                follow_icon=true;
              }
              Navigator.push(context, PageTransition(child: PlaylistDetail(duration:duration,numberOfSongs:count,followIcon: follow_icon,type:"other",about: playlistDetail[0]['about'],name: playlistDetail[0]['name'],id: playlistDetail[0]['id'],imageReference: playlistDetail[0]['image_reference'],database: widget.database,),type: PageTransitionType.fade));
            }
            else if(widget.type=="User"){
              String type;
              if(is_artist==false){type="other";}else{type="own";}
              var follow_icon=await widget.database.rawQuery('SELECT * FROM User_Follow WHERE follower_id="$user_ID" and follower_email="$user_EMAIL" and followed_id="${querylist[index]['id']}" and followed_email="${querylist[index]['email']}"');
              if(follow_icon.isEmpty || is_artist==true){Navigator.push(context, PageTransition(child: UserProfile(followIcon: false,type: type,userDetail: querylist[index],database: widget.database,),type: PageTransitionType.fade));}
              else{Navigator.push(context, PageTransition(child: UserProfile(followIcon: true,type: type,userDetail: querylist[index],database: widget.database,),type: PageTransitionType.fade));}
            }
            //print(widget.list[index]);
           // Navigator.push(context,PageTransition(type: PageTransitionType.fade,child: PlaylistDetail(userId: widget.id,userEmail: widget.email,database: widget.database,name: playlists[index]['name'],id:playlists[index]['id'],about: playlists[index]['description'],imageReference: playlists[index]['image_reference'],)));         
             }},
        ));
      },
    )
    ));
}}