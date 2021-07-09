


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInputFormBorder extends StatefulWidget {

  final Function(String) onSaved;
  final String label;
  final String hint;
  final String initialValue;
  final TextInputType inputType;
  String suffix = "";


  TextInputFormBorder({
    this.onSaved,
    this.label,
    this.hint,
    this.suffix,
    this.inputType,
    this.initialValue
  });


  @override
  _TextInputFormBorderState createState() => _TextInputFormBorderState(onSaved: onSaved, );
}

class _TextInputFormBorderState extends State<TextInputFormBorder> {

  FocusNode focusNode;
  TextEditingController _controller;

  final Function(String) onSaved;
  _TextInputFormBorderState({
    this.onSaved,
  });
  void _requestFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void initState() {
    _controller = TextEditingController();
    focusNode = new FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color colorSelected = focusNode.hasFocus || _controller?.value.text.isNotEmpty ? Colors.teal : Colors.grey;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        focusNode: focusNode,
        initialValue: widget.initialValue,
        onTap: _requestFocus,
        controller: _controller,
        keyboardType: widget.inputType != null ? widget.inputType : TextInputType.text ,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          fillColor: Colors.transparent,
          labelText: widget.label,
          hintText: widget.hint,
          suffix: Text("${widget.suffix}"),
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: colorSelected
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorSelected)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.zero,),
            borderSide: BorderSide(color: colorSelected)
          )
        ),
        onSaved: onSaved,
        onChanged: onSaved,
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
  }
}
