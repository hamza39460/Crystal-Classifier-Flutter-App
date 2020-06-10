import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType keyBoardType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String validationText;
  final Function(dynamic) onSubmit;
  var maxLength;
  int maxLines = 1;
  final FocusNode myNode;
  final FocusNode nextNode;

  final Function(dynamic) onSaved;
  InputWidget({@required this.labelText,@required this.hintText, @required this.keyBoardType, @required this.obscureText,@required this.controller,this.onSubmit,@required this.onSaved,@required this.validationText,@required this.textInputAction, this.maxLines,this.maxLength,this.myNode,this.nextNode});
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
        focusNode: widget.myNode,
        textInputAction: widget.textInputAction,
        style: TextStyle(fontSize: Common.getSPfont(15)),
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: Common.getSPfont(12)),
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
        onFieldSubmitted: (value){
          if(widget.myNode!=null && widget.nextNode!=null){
            print('submit00');
            widget.myNode.unfocus();
            FocusScope.of(context).requestFocus(widget.nextNode);
          }
          widget.onSubmit(value);
          }
        
      ),
    );
  }
}
