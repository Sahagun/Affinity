import 'package:flutter/material.dart';
import 'package:steven_app/chat/message.dart';
import 'chat.dart';

class ChatRoomPage extends StatefulWidget {

  // Using the ChatID, we will get the chat info from firebase
  final String chatID;

  ChatRoomPage(this.chatID);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  // we will manually create a chat to test
  void testing(){
    String user1 = "aaa";
    String user2 = "bbb";

    String activeUser = user2;

    Chat chat = Chat();
    chat.userIDList = [user1, user2];
    Message message1 = Message();
    message1.userID = user1;
    message1.message = "Hello b";
    message1.userName = "a";
    message1.messageSentTime = DateTime.fromMillisecondsSinceEpoch(1000000);

    Message message2 = Message();
    message2.userID = user2;
    message2.message = "Hello a";
    message2.userName = "b";
    message2.messageSentTime = DateTime.fromMillisecondsSinceEpoch(2000000);

    Message message3 = Message();
    message3.userID = user1;
    message3.message = "How you doing?";
    message3.userName = "a";
    message3.messageSentTime = DateTime.fromMillisecondsSinceEpoch(3000000);

    chat.messages = [message1, message2, message3];

    // create a print all messages in the chat class.
    for (Message m in chat.messages){
      if(activeUser == m.userID){
        print('YOU - ${m.userID} - ${m.messageSentTime} - ${m.message}');
      }
      else{
        print('${m.userID} - ${m.messageSentTime} - ${m.message}');
      }
    }
  }


  Widget buildChatBubble(Message message, bool isUser, BuildContext context){
    return Align(
      alignment: (isUser) ? Alignment.centerRight : Alignment.centerLeft,
      child:ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
        child: Container(
          margin: const EdgeInsets.all(3.0),
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              color: (isUser) ? Colors.blue : Colors.lightBlueAccent,
              borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(message.message)
        ),
      )
    );
  }


  Widget buildChatUI(Chat chat, String UserID, BuildContext context){
    ListView listView = ListView.builder(
      itemCount: chat.messages.length,
      itemBuilder: (BuildContext context, int index){
        Message message = chat.messages[index];
        bool isUser = UserID == message.userID;
        return(buildChatBubble(message, isUser, context));
      }
    );
    return listView;
  }


  @override
  Widget build(BuildContext context) {

    // testing();
    String user1 = "aaa";
    String user2 = "bbb";

    String userID = user2;

    Chat chat = Chat();
    chat.userIDList = [user1, user2];
    Message message1 = Message();
    message1.userID = user1;
    message1.message = "Hello b";
    message1.userName = "a";
    message1.messageSentTime = DateTime.fromMillisecondsSinceEpoch(1000000);

    Message message2 = Message();
    message2.userID = user2;
    message2.message = "Hello a";
    message2.userName = "b";
    message2.messageSentTime = DateTime.fromMillisecondsSinceEpoch(2000000);

    Message message3 = Message();
    message3.userID = user1;
    message3.message = "How you doing? How you doing? How you doing? How you doing? How you doing? How you doing? How you doing? How you doing? How you doing? How you doing? ";
    message3.userName = "a";
    message3.messageSentTime = DateTime.fromMillisecondsSinceEpoch(3000000);

    chat.messages = [message1, message2, message3];

    return Scaffold(
      appBar: AppBar(title: Text("Example Chat Page"),),
      body: Column(
        children: <Widget>[
          Expanded(child:
            Align(
              alignment: Alignment.bottomCenter,
               child:buildChatUI(chat, userID, context)
            )
          ),
          Text("Hello"),

        ]
      ),
    );
  }

 }