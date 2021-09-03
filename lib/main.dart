import 'dart:io';
import 'package:db_project/ArtistLogIn.dart';
import 'package:db_project/PlaylistDetail.dart';
import 'package:db_project/UserSignUp.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'menu.dart';

Database database;

 void on_config(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

    void create_tables(Database db,int newVersion) async {
      
      await db.execute(
            '''CREATE TABLE Music (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,duration INTEGER DEFAULT 0,album_id INTEGER NOT NULL
           ,number_of_plays INTEGER NOT NULL,file_reference TEXT NOT NULL , is_active NUMERIC DEFAULT FALSE , is_explicit NUMERIC DEFAULT FALSE,cover_reference TEXT DEFAULT NULL
           ,FOREIGN KEY (album_id) REFERENCES Album(id))''');

      await db.execute(
            '''CREATE TABLE Playlist (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL,user_email TEXT NOT NULL,name TEXT NOT NULL,description TEXT DEFAULT NULL
           ,image_reference TEXT DEFAULT NULL,FOREIGN KEY (user_id) REFERENCES User(id),FOREIGN KEY (user_email) REFERENCES User(email))''');
      
      await db.execute(
            '''CREATE TABLE Album (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,image_reference TEXT DEFAULT NULL
           , release_year INTEGER DEFAULT 0, copy_right TEXT DEFAULT NULL, is_single_or_ep TEXT NOT NULL)''');
      await db.execute(
            '''CREATE TABLE Artist (id INTEGER NOT NULL UNIQUE,username TEXT NOT NULL UNIQUE, about TEXT DEFAULT NULL,is_verified NUMERIC DEFAULT FALSE,
            hashed_password TEXT NOT NULL,image_reference TEXT DEFAULT NULL, PRIMARY KEY (id,username))''');
      await db.execute(
            '''CREATE TABLE User (id INTEGER NOT NULL UNIQUE,email TEXT NOT NULL UNIQUE,name TEXT NOT NULL, image_reference TEXT DEFAULT NULL,
            hashed_password TEXT NOT NULL,land TEXT NOT NULL,PRIMARY KEY (id,email))''');
      await db.execute(
            '''CREATE TABLE User_Follow (follower_id INTEGER NOT NULL,follower_email TEXT NOT NULL,followed_id INTEGER NOT NULL,followed_email TEXT NOT NULL,FOREIGN KEY (follower_id) REFERENCES User(id) ON UPDATE CASCADE,FOREIGN KEY (follower_email) REFERENCES User(email) ON UPDATE CASCADE,
            FOREIGN KEY (followed_email) REFERENCES User(email) ON UPDATE CASCADE,FOREIGN KEY (followed_id) REFERENCES User(id) ON UPDATE CASCADE)''');
      await db.execute(
            '''CREATE TABLE Liked (music_id INTEGER NOT NULL,email TEXT NOT NULL,
            user_id INTEGER NOT NULL, date TEXT DEFAULT "0000-00-00 00:00:00",FOREIGN KEY (music_id) REFERENCES Music(id),FOREIGN KEY (user_id) REFERENCES User(id),FOREIGN KEY (email) REFERENCES User(email))''');
      await db.execute(
            '''CREATE TABLE On_Playlist (music_id INTEGER NOT NULL,playlist_id INTEGER NOT NULL,
             date_of_add TEXT DEFAULT "0000-00-00 00:00:00",FOREIGN KEY (music_id) REFERENCES Music(id),FOREIGN KEY (playlist_id) REFERENCES Playlist(id) )''');
      await db.execute(
            '''CREATE TABLE Playlist_Follow (user_id INTEGER NOT NULL,user_email TEXT NOT NULL,
            playlist_id INTEGER NOT NULL,FOREIGN KEY (playlist_id) REFERENCES Playlist(id),FOREIGN KEY (user_id) REFERENCES User(id),FOREIGN KEY (user_email) REFERENCES User(email))''');
      await db.execute(
            '''CREATE TABLE _In (artist_id INTEGER NOT NULL,artist_username TEXT NOT NULL,
            album_id INTEGER NOT NULL,is_owner TEXT DEFAULT NULL,FOREIGN KEY (artist_id) REFERENCES Artist(id),FOREIGN KEY (artist_username) REFERENCES Artist(username)
            ,FOREIGN KEY (album_id) REFERENCES Album(id))''');
      await db.execute(
            '''CREATE TABLE Artist_Follow (artist_id INTEGER NOT NULL,artist_username TEXT NOT NULL,
            user_id INTEGER NOT NULL,user_email TEXT NOT NULL,FOREIGN KEY (artist_id) REFERENCES Artist(id),
            FOREIGN KEY (artist_username) REFERENCES Artist(username),FOREIGN KEY (user_id) REFERENCES User(id),
            FOREIGN KEY (user_email) REFERENCES User(email))''');
      }


  Future<Database> open_db() async {
  Directory dir=await getApplicationDocumentsDirectory();
  //print(dir.path);
  String path = dir.path+"test67.db";
  database = await openDatabase(path, version: 1,onCreate: create_tables,onConfigure: on_config);
  var artistList=await database.rawQuery('SELECT * FROM Artist');
  if(artistList.isEmpty){
    await database.rawInsert('INSERT INTO Artist (id,username,hashed_password,is_verified,image_reference) VALUES (1,"ebi","ebioooo","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/ebiProfile.jpg")');
    await database.rawInsert('INSERT INTO Artist (id,username,about,hashed_password,image_reference) VALUES (2,"shadmehr aghili","hello there welcome to my page!!!!","shadmehrPageOfficial","/Users/aminhasanzadehmoghadam/Desktop/db/shadmehrProfile.jpg")');
    await database.rawInsert('INSERT INTO Artist (id,username,hashed_password,is_verified,image_reference) VALUES (3,"ludovico einaudi","hi ludovico","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/einaudiProfile.jpg")');
    await database.rawInsert('INSERT INTO Artist (id,username,about,hashed_password,image_reference) VALUES (4,"ali sorena","Official page of ali sorena :)","hello there!","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaProfile.jpg")');
    await database.rawInsert('INSERT INTO Artist (id,username,about,hashed_password,is_verified,image_reference) VALUES (5,"shayea","be unique!!!!","shayea.34535","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/shayeaProfile.jpg")');
  }
  var userList=await database.rawQuery('SELECT * FROM User');
  if(userList.isEmpty){
    await database.rawInsert('INSERT INTO User (id,email,name,land,hashed_password,image_reference) VALUES ("1","iqson.amin@gmail.com","amin","iran","aminhm1377","/Users/aminhasanzadehmoghadam/Desktop/db/aminProfile.jpg")');
    await database.rawInsert('INSERT INTO User (id,email,name,land,hashed_password,image_reference) VALUES ("2","kimiyakazemi@gmail.com","kimiya","germany","kimiyakazemi","/Users/aminhasanzadehmoghadam/Desktop/db/kimiyaProfile.jpg")');
    await database.rawInsert('INSERT INTO User (id,email,name,land,hashed_password,image_reference) VALUES ("3","hasanabasi@yahoo.com","hasan","us","hasanabasi","/Users/aminhasanzadehmoghadam/Desktop/db/hasanProfile.jpg")');
    await database.rawInsert('INSERT INTO User (id,email,name,land,hashed_password,image_reference) VALUES ("4","sepehrjavid@gmail.com","sepehr","england","sepehrjavid","/Users/aminhasanzadehmoghadam/Desktop/db/sepehrProfile.jpg")');
  }
  var albumList=await database.rawQuery('SELECT * FROM Album');
  if(albumList.isEmpty){
    await database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep,image_reference) VALUES ("Kavir","2017","FALSE","album","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaKavir.jpg")');
    await database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep,image_reference) VALUES ("Pare Parvaz","2002","TRUE","ep","/Users/aminhasanzadehmoghadam/Desktop/db/shadmehrPareParvaz.jpg")');
    await database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep,image_reference) VALUES ("Khalij","2006","TRUE","single","/Users/aminhasanzadehmoghadam/Desktop/db/ebiKhalij.jpg")');
    await database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep,image_reference) VALUES ("Jane Javani","2016","FALSE","ep","/Users/aminhasanzadehmoghadam/Desktop/db/ebiJaneJavani.jpg")');
    await database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep,image_reference) VALUES ("Elements","2018","FALSE","single","/Users/aminhasanzadehmoghadam/Desktop/db/einaudiElements.jpg")');
    await database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep,image_reference) VALUES ("Tarafdar","2014","FALSE","ep","/Users/aminhasanzadehmoghadam/Desktop/db/shadmehrTarafdar.jpg")');
    await database.rawInsert('INSERT INTO Album (title,release_year,copy_right,is_single_or_ep,image_reference) VALUES ("Injaneb","2019","FALSE","single","/Users/aminhasanzadehmoghadam/Desktop/db/shayeaInjaneb.jpg")');
  }
  var playList=await database.rawQuery('SELECT * FROM Playlist');
  if(playList.isEmpty){
    await database.rawInsert('INSERT INTO Playlist (user_id,user_email,name,image_reference) VALUES ("1","iqson.amin@gmail.com","piano","/Users/aminhasanzadehmoghadam/Desktop/db/piano.jpg")');
    await database.rawInsert('INSERT INTO Playlist (user_id,user_email,name,image_reference) VALUES ("1","iqson.amin@gmail.com","golchin","/Users/aminhasanzadehmoghadam/Desktop/db/collection.jpg")');
    await database.rawInsert('INSERT INTO Playlist (user_id,user_email,name,image_reference) VALUES ("2","kimiyakazemi@gmail.com","shaaadd","/Users/aminhasanzadehmoghadam/Desktop/db/happy.jpg")');
    await database.rawInsert('INSERT INTO Playlist (user_id,user_email,name,description,image_reference) VALUES ("3","hasanabasi@yahoo.com","rap","sorena,shayea",NULL)');
    await database.rawInsert('INSERT INTO Playlist (user_id,user_email,name,description,image_reference) VALUES ("3","hasanabasi@yahoo.com","ebi","ebiSongs","/Users/aminhasanzadehmoghadam/Desktop/db/ebiPlaylist.jpg")');
    await database.rawInsert('INSERT INTO Playlist (user_id,user_email,name,image_reference) VALUES ("3","hasanabasi@yahoo.com","sad","/Users/aminhasanzadehmoghadam/Desktop/db/sad.jpg")');
    await database.rawInsert('INSERT INTO Playlist (user_id,user_email,name,description,image_reference) VALUES ("4","sepehrjavid@gmail.com","priority","musics which have more priority than others",NULL)');
  }
  var musicList=await database.rawQuery('SELECT * FROM Music');
  if(musicList.isEmpty){
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Kavir","289","1","16000","/Users/aminhasanzadehmoghadam/Desktop/db/Kavir.mp3","TRUE","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaKavir.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Gonjeshgaka","298","1","25300","/Users/aminhasanzadehmoghadam/Desktop/db/Gonjeshkaka.mp3","TRUE","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaKavir.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Teryagh","218","1","20000","/Users/aminhasanzadehmoghadam/Desktop/db/Teryagh.mp3","FALSE","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaKavir.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Teatre Sayeha","249","1","14353","/Users/aminhasanzadehmoghadam/Desktop/db/TatreSayeha.mp3","TRUE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaKavir.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Maryam","200","1","26590","/Users/aminhasanzadehmoghadam/Desktop/db/Maryam.mp3","TRUE","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaKavir.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Poshte In Jangha","380","1","39204","/Users/aminhasanzadehmoghadam/Desktop/db/PoshteInJangHa.mp3","TRUE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaKavir.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Nafir","164","1","13420","/Users/aminhasanzadehmoghadam/Desktop/db/Nafir.mp3","FALSE","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/aliSorenaKavir.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Pare Parvaz","354","2","600340","/Users/aminhasanzadehmoghadam/Desktop/db/PareParvaz.mp3","TRUE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/shadmehrPareParvaz.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Atish Bazi","185","2","453004","/Users/aminhasanzadehmoghadam/Desktop/db/AtishBazi.mp3","TRUE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/shadmehrPareParvaz.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Khalij","264","3","1234394","/Users/aminhasanzadehmoghadam/Desktop/db/Khalij.mp3","TRUE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/ebiKhalij.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Jane Javani","235","4","234234","/Users/aminhasanzadehmoghadam/Desktop/db/JaneJavani.mp3","TRUE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/ebiJaneJavani.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Behet Goftam","221","4","43545","/Users/aminhasanzadehmoghadam/Desktop/db/BehetGoftam.mp3","FALSE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/ebiJaneJavani.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Elements","366","5","34534","/Users/aminhasanzadehmoghadam/Desktop/db/Elements.mp3","TRUE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/einaudiElements.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Entekhab","256","6","43554","/Users/aminhasanzadehmoghadam/Desktop/db/Entekhab.mp3","TRUE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/shadmehrTarafdar.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Tarafdar","250","6","34563","/Users/aminhasanzadehmoghadam/Desktop/db/Tarafdar.mp3","FALSE","FALSE","/Users/aminhasanzadehmoghadam/Desktop/db/shadmehrTarafdar.jpg")');
    await database.rawInsert('INSERT INTO Music (title,duration,album_id,number_of_plays,file_reference,is_active,is_explicit,cover_reference) VALUES ("Injaneb","265","7","2752355","/Users/aminhasanzadehmoghadam/Desktop/db/Injaneb.mp3","TRUE","TRUE","/Users/aminhasanzadehmoghadam/Desktop/db/shayeaInjaneb.jpg")');
  }
  var _inList=await database.rawQuery('SELECT * FROM _In');
  if(_inList.isEmpty){
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("4","ali sorena","1","ali sorena")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("4","ali sorena","7","shayea")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("1","ebi","3","ebi")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("1","ebi","4","ebi")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("2","shadmehr aghili","4","ebi")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("2","shadmehr aghili","2","shadmehr aghili")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("3","ludovico einaudi","5","ludovico einaudi")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("2","shadmehr aghili","6","shadmehr aghili")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("5","shayea","7","shayea")');
    await database.rawInsert('INSERT INTO _In (artist_id,artist_username,album_id,is_owner) VALUES ("5","shayea","1","ali sorena")');
  }
  }

main() => runApp(MaterialApp(home: Start(),debugShowCheckedModeBanner: false,));

class Start extends StatefulWidget{
  @override
  _Start createState() => _Start();
}

class _Start extends State<Start>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment(0,0),
            child: FloatingActionButton.extended(onPressed:() async{await open_db();
            //await add_music();
            Navigator.push(context, PageTransition(child: Menu(database: database,),type: PageTransitionType.fade));
            },
            heroTag: "start",
            label: Text("     کلیک کنید     ",style: TextStyle(fontSize: 25,color: Colors.white),),
            ),
          ),
          Container(
            alignment:Alignment(0,-0.3),
            child: Text("!!!!! مینی اسپاتی فای ",style: TextStyle(fontSize: 25,color: Colors.white),),
          )
        ],
      ),
    ));
  }
}

