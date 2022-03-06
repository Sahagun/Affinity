import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'checklistwidget.dart';
import 'globals.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  String bio = "Bio Place Holder";
  String birthdate = "birthdate Place Holder";
  String userName = "userName Place Holder";
  String tags = "Tags Place Holder";

  CheckLists checkLists = CheckLists.withSelections(Global.user.tags);
  bool uploadLock = false;

  void submitForm() async{
    if(uploadLock == false){
      uploadLock = true;

      List<String> selected = checkLists.getSelectedOptions();
      String selectedString = "";
      for (int i = 0; i < selected.length; i++){
        selectedString += selected[i];
        if(i<selected.length-1){
          selectedString += ",";
        }
      }
       var database = FirebaseDatabase.instance;
      final databaseRef = database.reference().child('profiles').child(FirebaseAuth.instance.currentUser.uid);
      databaseRef.set({'bio':bio, 'birthday':birthdate, 'tags':selectedString});
//      Navigator.of(context).popUntil((route) => route.isFirst);
      uploadLock = false;
    }
  }




  Widget body(){

    bio = Global.user.bio;

    return Column(
      children: <Widget>[
        Text("birthdate: ${Global.user.birthday}"),
        Text("userName: ${Global.user.userID}"),
        // Text("bio: ${Global.user.bio}"),

        TextFormField(
          decoration: const InputDecoration(
              labelText: 'Bio',
          ),
          initialValue: bio,
          onChanged: (String value){bio = value;},
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),

        checkLists,

        ElevatedButton(onPressed: submitForm, child: Text('Update'))
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: body()
    );
  }
}
