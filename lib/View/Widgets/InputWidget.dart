import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType keyBoardType;
  final TextEditingController controller;
  final String validationText;
  final Function(dynamic) onSubmit;
  var maxLength;
  int maxLines = 1;
  final Function(dynamic) onSaved;
  InputWidget({@required this.labelText,@required this.hintText, @required this.keyBoardType, @required this.obscureText,@required this.controller,this.onSubmit,@required this.onSaved,@required this.validationText,this.maxLines,this.maxLength,});
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Text(widget.labelText , style: TextStyle(fontSize:Common.getSPfont(17)))),
          _textField(),
        ],
      ),
    );
  }

  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyBoardType,
        cursorColor: mosqueColor1,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        style: TextStyle(fontSize: Common.getSPfont(15)),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: Common.getSPfont(15)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: mosqueColor1)
          )
        ),
        validator: (value) =>
            value.isEmpty ? widget.validationText : null,
        onSaved: (value)=>widget.onSaved(value),
        onFieldSubmitted: (value)=>widget.onSubmit(value),
      ),
    );
  }
}
