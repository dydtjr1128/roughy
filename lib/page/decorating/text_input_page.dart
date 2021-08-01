import 'package:Roughy/component/roughyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInputPage extends StatefulWidget {
  @override
  _TextInputPageState createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  setThisText() {
    final form = _formKey.currentState;
    print("@@@@" + form!.validate().toString() + " " +  _textController.text.toString() + "!@@");
    if (form.validate()) {
      print("@@@ " + _textController.text);
      Navigator.pop(context, _textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoughyAppBar(
          titleText: "Text",
          isCenterTitle: true,
          iconWidget: new IconButton(
            icon: new Icon(Icons.check),
            tooltip: 'Save text',
            onPressed: setThisText,
          )),
      body: Container(
          child: Form(
              key: _formKey,
              child: new TextFormField(
                  maxLines: 10,
                  autofocus: true,
                  controller: _textController,
                  decoration: new InputDecoration(
                      labelText: '텍스트',
                      hintText: 'Please enter text',

                      //border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16.0)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter text";
                    }
                    return null;
                  }))),
    );
  }
}
