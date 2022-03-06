import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'chatroompage.dart';

class NewChatPage extends StatelessWidget {

  BuildContext _context;
  bool submitLock = false;

  void CreateNewChat(String otherUserID) async{
    if(submitLock){
      return;
    }

    submitLock = true;

    var uuid = Uuid();
    String chatID = uuid.v4();

    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("chatIDs").once();

    bool uniqueID = false;
    while (!uniqueID) {
      if(snapshot == null) {
        uniqueID = true;
      }
      else if (snapshot.value == null) {
        uniqueID = true;
      }
      else{
        var chatIDs = Map<dynamic, dynamic>.from(snapshot.value).keys;
        uniqueID = !chatIDs.contains(chatID);
      }
      if(!uniqueID){
        chatID = uuid.v4();
      }
    }

    DatabaseReference databaseRef = FirebaseDatabase.instance.reference().child("chatIDs/$chatID");
    databaseRef.set({ 'user1': FirebaseAuth.instance.currentUser.uid, 'user2': otherUserID });

    databaseRef = FirebaseDatabase.instance.reference().child("userChats/${FirebaseAuth.instance.currentUser.uid}/$chatID");
    databaseRef.set({ 'otherUser': otherUserID });

    databaseRef = FirebaseDatabase.instance.reference().child("userChats/$otherUserID/$chatID");
    databaseRef.set({ 'otherUser': FirebaseAuth.instance.currentUser.uid });

    Navigator.pushReplacement(_context, new MaterialPageRoute(builder: (BuildContext context) => ChatRoomPage(chatID) ));


  }



  Future<Map<String, String>> GetUserProfiles() async{
    Map<String, String> userProfilesList = {};

    var userProfiles = await FirebaseDatabase.instance.reference().child("profiles").orderByKey().once();

    if(userProfiles.value != null) {
      var datapoints = Map<String, dynamic>.from(userProfiles.value);
      List<String> userTags = datapoints[FirebaseAuth.instance.currentUser.uid]['tags'].toString().split(',');
      print('UserSEDFSFJEOWJDLS');
      print(userTags);

      for (var entry in datapoints.entries) {
        print(entry.key);
        print(entry.value);
        if(entry.key == FirebaseAuth.instance.currentUser.uid){
          print('pass');
        }
        else{
          var userData  =  Map<String, dynamic>.from(entry.value);
          // print("Other user tags");
          List<String> tags = userData["tags"].toString().split(',');
          // print("Other user tags");
          // print(tags);

          List<String> usertagsClone = List.from(userTags);
          // print("User user tags copy");
          // print(usertagsClone);

          usertagsClone.removeWhere((element) => !tags.contains(element));
          // print("In common tags");
          // print(usertagsClone);

          if(usertagsClone.length > 0){
            // userProfilesList.add(userData['username'].toString());
            userProfilesList[entry.key] = userData['username'].toString();
          }
        }
      }
    }
    // print(userProfiles);
    return userProfilesList;
  }


  Widget UserProfileList(BuildContext context){
    return FutureBuilder(builder: (context, snapshot){
      print(snapshot);

      List<String> userID = snapshot.data.keys.toList();

      if(snapshot.hasData){
        if(snapshot.data.length == 0){
          return Text('No users found');
        }
        else{
          return ListView.separated(
            itemCount: userID.length,
            itemBuilder: (context, index){

              return ListTile(
                title: Text(snapshot.data[userID[index]]),
                subtitle: Text(userID[index]),
                trailing: Icon(Icons.keyboard_arrow_right_rounded),
                onTap:() { CreateNewChat(userID[index]); } ,
              );

              // return Text(snapshot.data[index]);

            },

            separatorBuilder: (context, index) {
              return Divider();
            },

          );
        }
      }
      else if(snapshot.hasError){
        return Container(child:Text("Error"));
      }
      else{
        return Container(child:Text("Loading"));
      }
    },
      future: GetUserProfiles(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(title: Text('New Chat'),),
      body: UserProfileList(context),
    );
  }

}
