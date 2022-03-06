import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:steven_app/chat/chatroompage.dart';
import 'package:steven_app/chat/message.dart';
import 'package:steven_app/chat/newchatpage.dart';

class ChatRoomListPage extends StatelessWidget {

  Future<List<String>> GetChatListIDs() async{
    List<String> chatIDList = [];

    var chatIDs = await FirebaseDatabase.instance.reference().child("userChats/${FirebaseAuth.instance.currentUser.uid}").orderByKey();
    print(chatIDs);

    // Map<dynamic, dynamic> values = chatIDs;
    //
    // values.forEach((key, values) {
    //   chatIDList.add(Need.fromSnapshot(values));
    // });


    return chatIDList;
  }


  Widget NoChats(BuildContext context){
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text('No Chats'),
          )
        ),
        ElevatedButton(
            onPressed: (){Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => NewChatPage()));},
            child: Text('Start New Chat')
        ),

        ElevatedButton(
            onPressed: (){TestChat(context);},
            child: Text('Test Chat ')
        )

      ],
    );
  }

  void TestChat(BuildContext context){
    String chatID = "0";
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatRoomPage(chatID)));
  }




  Widget ChatList(BuildContext context){
    return FutureBuilder(builder: (context, snapshot){
      print(snapshot);

      if(snapshot.hasData == null){
        return Container(child:Text("Loading"));
      }

      else if(snapshot.data.length == 0){
        return NoChats(context);
      }
      else{
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index){
            return Text(snapshot.data[index]);
          },
        );
      }
    },
    future: GetChatListIDs(),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats"),),
      body: ChatList(context),
    );
  }

}
