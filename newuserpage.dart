import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:steven_app/checklistwidget.dart';
import 'package:steven_app/homepage.dart';

enum Gender { male, female, noanswer }

class NewUserPage extends StatefulWidget {
  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {

  final _formKey = GlobalKey<FormState>();


  TextEditingController dateField = TextEditingController();

  DateTime birthday = DateTime.now();
  String bioDescription = "";
  Gender _gender = Gender.noanswer;
  CheckLists checkList = CheckLists();

  void _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null){
      setState(() {
        birthday = picked;
      });
    }
  }

  String prettyDate(){
    String year = birthday.year.toString();
    String month = birthday.month.toString();
    String day = birthday.day.toString();
    return year + "-" + month + "-" + day;
  }

  // is lock is so the user can only submit the form once
  bool uploadLock = false;

  // Submit button function
  void submitForm() async{
    print(bioDescription);
    print(prettyDate());

    // This is to make sure it only is only happening one at a time.
    if(uploadLock == false){
      uploadLock = true;

      List<String> selected = checkList.getSelectedOptions();
      String selectedString = "";
      for (int i = 0; i < selected.length; i++){
        selectedString += selected[i];
        if(i<selected.length-1){
          selectedString += ",";
        }
      }
//      print(selectedString);

      String username = FirebaseAuth.instance.currentUser.displayName;

      var database = FirebaseDatabase.instance;
      final databaseRef = database.reference().child('profiles').child(FirebaseAuth.instance.currentUser.uid);
      databaseRef.set({'username': username, 'bio':bioDescription, 'birthday':prettyDate(), 'tags':selectedString, 'username':FirebaseAuth.instance.currentUser.displayName});
      //
      // Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => HomePage() ));

      uploadLock = false;
    }

  }

  Widget body(){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // TextFormField fo the Date
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Birthdate',
                hintText: 'Please enter your birthday.'
            ),
            controller: dateField,
            // initialValue: birthday.toString(),
            readOnly: true,
            onTap:(){
              FocusScope.of(context).requestFocus(new FocusNode());
              _selectDate(context);
              dateField.text = prettyDate();
            },
          ),

          // TextFormField fo the Bio
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Bio',
              hintText: 'Please write a bit about yourself.'
            ),
            onChanged: (String value){bioDescription = value;},
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),


          Text("Gender:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // Gender options
          Column(
            children: <Widget>[
              // Male option
              ListTile(
                  title: const Text("Male"),
                  leading: Radio<Gender>(
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (Gender value){
                      setState(() {
                        _gender = value;
                      });
                    },
                  )
              ),

              // Female option
              ListTile(
                  title: const Text("Female"),
                  leading: Radio<Gender>(
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (Gender value){
                      setState(() {
                        _gender = value;
                      });
                    },
                  )
              ),


              // No Answer option
              ListTile(
                  title: const Text("Prefer not to answer"),
                  leading: Radio<Gender>(
                    value: Gender.noanswer,
                    groupValue: _gender,
                    onChanged: (Gender value){
                      setState(() {
                        _gender = value;
                      });
                    },
                  )
              ),



            ],
          ),


          // Tags check options
          SizedBox(height: 20,),
          Text("Please select the issues you are facing",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          checkList,

          // submit button
          ElevatedButton(
              onPressed: submitForm,
              child: Text('Submit')
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete new user form')),
      body: body()
    );
  }
}