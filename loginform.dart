import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steven_app/chat/chatroompage.dart';
import 'package:steven_app/homepage.dart';
import 'package:steven_app/registerpage.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // j@example.com
  // abc123
  String _email = '';
  String _password = '';

  bool hiddenText = true;

  Future<String> login() async {
    String outcome = 'Unknown Error';
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      outcome = 'Successfully signed in ' + _email;
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        outcome = 'Error: No user found for that email.';
      }
      else if(e.code == 'wrong-password') {
        outcome = 'Error: Wrong password provided for that user.';
      }
      else{
        outcome = 'Unknown Error.';
      }
    }
    return outcome;
  }

  Future<String> register() async{
    String outcome = 'Unknown Error';
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      outcome = 'Successfully registered ' + _email;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        outcome = 'Error: The password provided is too weak.';
      }
      else if (e.code == 'email-already-in-use') {
        outcome = 'Error: The account already exists for that email';
      }
      else{
        outcome = 'Unknown Error.';
      }
    }
    return outcome;
  }

  void toggleHiddenText() {
    setState(() {
      hiddenText = !hiddenText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Steven's app"),),
      body: Builder(
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email *',
                  ),
                  onChanged: (String value) { _email = value; },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password *',
                        ),
                        obscureText: hiddenText,
                        onChanged: (String value) { _password = value; }
                      ),
                    ),

                    ElevatedButton(onPressed: toggleHiddenText, child: Text(hiddenText ? "Show" : "Hide")),

                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    // Register Button
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => RegisterPage() ));
                        // FutureBuilder futureBuilder = FutureBuilder(
                        //   future: register(),
                        //   builder: (context, snapshot){
                        //     if(snapshot.hasError){
                        //       return Text(snapshot.data);
                        //     }
                        //     else if(snapshot.hasData){
                        //       return Text(snapshot.data);
                        //     }
                        //     else{
                        //       return Text('Loading...');
                        //     }
                        //   },
                        // );
                        //
                        // Scaffold.of(context).showSnackBar(SnackBar(content: futureBuilder,));
                        //
                        // futureBuilder.future.then((value){
                        //   // Go to the next page
                        //   if(FirebaseAuth.instance.currentUser != null){
                        //     Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => HomePage() ));
                        //   }
                        // });
                      },
                      child: Text("Register")
                    ),
                    // Login Button
                    ElevatedButton(
                      onPressed: (){
                        FutureBuilder futureBuilder = FutureBuilder(
                          future: login(),
                          builder: (context, snapshot){
                            if(snapshot.hasError){
                              return Text(snapshot.data);
                            }
                            else if(snapshot.hasData){
                              return Text(snapshot.data);
                            }
                            else{
                              return Text('Loading...');
                            }
                          },
                        );

                        Scaffold.of(context).showSnackBar(SnackBar(content: futureBuilder,));

                        futureBuilder.future.then((value){
                          // Go to the next page
                        if(FirebaseAuth.instance.currentUser != null){
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => HomePage() ));
                        }
                        });
                      },
                      child: Text("Login")
                    ),

                    // Testing a chat room
                    ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => ChatRoomPage("test") ));
                        },
                        child: Text('Test chat ui')
                    ),


                  ]
                ),
                Text(FirebaseAuth.instance.currentUser.toString()),
              ],
        ),
      ),
    );
  }
}
