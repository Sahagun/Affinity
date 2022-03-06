import 'package:flutter/material.dart';

class CheckLists extends StatefulWidget {

  ListView listView;
  List<CheckListOption> checkListOption = [];

  List<String> optionsList = ["Stress", "Anxiety", "Family Problems",];
  List<String> selectedOptions = [];

  CheckLists();

  CheckLists.withSelections(this.selectedOptions){
    this.selectedOptions = selectedOptions;
  }


  List<String> getSelectedOptions(){
    List<String> selectedOptions = [];
    for(var option in checkListOption){
      if(option.isChecked){
        selectedOptions.add(option.value);
      }
    }
    return selectedOptions;
  }

  @override
  _CheckListsState createState() => _CheckListsState();
}

class _CheckListsState extends State<CheckLists> {

  @override
  Widget build(BuildContext context) {
    for(var option in widget.optionsList){
      if(widget.selectedOptions.contains(option)){
        widget.checkListOption.add(CheckListOption(value: option, isChecked: true,));
      }
      else{
        widget.checkListOption.add(CheckListOption(value: option, isChecked: false,));
      }
    }

    widget.listView = ListView(
      children: widget.checkListOption,
    );

    return
      Expanded(
        child: widget.listView,
    );
  }
}

class CheckListOption extends StatefulWidget {
  final String value;
  bool isChecked = false;

  CheckListOption ({ Key key, this.value, this.isChecked }): super(key: key);

  @override
  _CheckListOptionState createState() => _CheckListOptionState();
}

class _CheckListOptionState extends State<CheckListOption> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: widget.isChecked,
          onChanged: (value) {
            setState(() {
              widget.isChecked = value;
            });
          },
        ),
        Text(widget.value),
      ]
    );
  }
}