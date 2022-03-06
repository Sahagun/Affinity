import 'package:steven_app/chat/message.dart';

class Chat{
  String chatID;

  List<String> userIDList = [];
  String mainUser;

  List<Message> messages = [];
}

// id
//  -list of users
//    -user1
//    -user2
//    -user3
//  -list of messages
//    - message1
//      - sender
//      - timestamp
//      - message
//    - message2
//      - sender
//      - timestamp
//      - message
//    - message3
//      - sender
//      - timestamp
//      - message

// userChats
//    -user
//      - list of chat id
//        - chatid1
//        - chatid2
