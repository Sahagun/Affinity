import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steven_app/chat/chatroomlistpage.dart';
import 'package:steven_app/checklistwidget.dart';
import 'package:steven_app/newuserpage.dart';
import 'package:steven_app/settingsPage.dart';
import 'package:steven_app/userinfo.dart';

import 'globals.dart';
import 'loginform.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void onpressLogout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => LoginForm() ));
  }

  Widget newUser(){
    return Center(
      child: Column(
        children: <Widget>[
          Text('Hello New User'),
          ElevatedButton(
              onPressed: (){ Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => NewUserPage())); },
              child: Text('Complete Profile')
          ),
        ],
      ),
    );
  }

  Future<bool> checkIfUserExist() async{
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child('profiles').child(FirebaseAuth.instance.currentUser.uid).once();
    print(snapshot.value);
    if (snapshot.value != null) {
      String birthday = snapshot.value['birthday'];
      print(birthday);
      String bio = snapshot.value['bio'];
      print(bio);
      String tagString = snapshot.value['tags'];
      print(tagString);
      List<String> tagsList = tagString.split(',');
      print(tagsList);
      String username = "username1";
      print(username);
      String gender = "male";
      print(gender);

      UserInfomation user = new UserInfomation(username, bio, gender, birthday, tagsList);
      Global.user = user;
      print(Global.user);


      return true;
    }
    return false;
  }

  Widget returningUser(){

    String name = FirebaseAuth.instance.currentUser.displayName;

    return Center(
      child: Column(
        children: <Widget>[
          Text('Welcome back, $name'),


          ElevatedButton(
              onPressed: (){Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => ChatRoomListPage()));},
              child: Text('Chats')
          ),


          ElevatedButton(
              onPressed: checkIfUserExist,
              child: Text('Test if user exist')
          ),

          ElevatedButton(
              onPressed: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => SettingsPage() ));
              },
              child: Text('Go to Settings Page')
          ),

        ],
      )
    );
  }

  Widget buildHomePage() {
    // bool isNewUser = await checkIfUserExist();
    // if(isNewUser){
    //   return newUser();
    // }
    // else{
    //   return returningUser();
    // }



    return FutureBuilder(
        future: checkIfUserExist(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            print(snapshot.data);
            if(snapshot.data == true){
              return returningUser();
            }
            else{
              return newUser();
            }
          }
          else if (snapshot.hasError){
            return Text('An error has occurred');
          }
          return Text('Loading');
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomePage')),
      body: buildHomePage(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: onpressLogout,
      ),
    );
  }
}