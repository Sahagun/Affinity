import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
import 'loginform.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var email = '';
  var password = '';
  var passwordConfirm = '';
  var datepicker = null;
  var username = '';


  void onPressRegisterButton(BuildContext context) async{

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Started'),));


    print('email: ' + email);
    print('password: ' + password);
    print('passwordConfirm: ' + passwordConfirm);
    print('username: ' + username);

    // Validate info before Firebase Auth part
    if(password != passwordConfirm){
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Passwords don\'t match'),));
      print('Passwords don\'t match');
      return;
    }

    // Make sure user is 13 yrs old using the datepicker

    // Validate info from Firebase database or Firebase Auth
    // check if username is not unique
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('write 4 into firebase'),));

    // await FirebaseDatabase.instance.reference().child('b').set({"${DateTime.now().millisecondsSinceEpoch}":'4'});

    // return;


    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("usernames").once();

        print(snapshot);

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Once'),));

          bool uniqueName = false;
          if(snapshot == null) {
            uniqueName=true;
          }
          else if (snapshot.value == null) {
            uniqueName=true;
          }
          else{
            var usernames = Map<dynamic, dynamic>.from(snapshot.value).keys;
            uniqueName = !usernames.contains(username);
          }

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('unique $uniqueName'),));


    if(uniqueName){
            // Try to register user using Firebase Auth
            // and add the the database the new username with the uid
            print('The username is unique');

            String outcome = 'Unknown Error';
            try{
              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

              DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("usernames/$username");

              Map<String, String> userData = {};
              userData['uid'] = userCredential.user.uid;

              await databaseReference.set(userData);

              // FirebaseDatabase.instance.reference().child('useremails/$username').set(userCredential.user.uid);
              await userCredential.user.updateDisplayName(username);

              outcome = 'Successfully registered ' + email;
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => HomePage() ));
            } on FirebaseAuthException catch(e) {
              if (e.code == 'weak-password') {
                outcome = 'Error: The password provided is too weak.';
              }
              else if (e.code == 'email-already-in-use') {
                outcome = 'Error: The account already exists for that email';
              }
              else if (e.code == 'invalidEmail') {
                outcome = 'Error: The email provided is too invalid.';
              }
              else{
                outcome = 'Unknown Error.';
              }
            }
            print(outcome);
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(outcome),));

            // return outcome;
          }
          else{
            // Message the user that the name has been taken
            print('username is not unique');
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Your username is taken'),));

          }

          print("end");

        }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // Email
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email *',
                ),
                onChanged: (value) { email = value; },
              ),

              // Password
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password *',
                ),
                obscureText: true,
                onChanged: (value) { password = value; },
              ),

              // Password Confirmation
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  labelText: 'Password *',
                ),
                obscureText: true,
                onChanged: (value) { passwordConfirm = value; },
              ),

              // Username (Unique)
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Username',
                  labelText: 'Username *',
                ),
                onChanged: (value) { username = value; },
              ),

              // Datepicker for Birthday (Unique)

              // Register Button
              ElevatedButton(
                  onPressed: (){onPressRegisterButton(context);},
                  child: Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}