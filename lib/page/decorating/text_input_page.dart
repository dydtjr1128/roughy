import 'package:Roughy/component/roughy_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextInputPage extends StatefulWidget {
  @override
  _TextInputPageState createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  setThisText() {
    final form = _formKey.currentState;
    print("@@@@${form!.validate()} ${_textController.text}!@@");
    if (form.validate()) {
      print("@@@ ${_textController.text}");
      Navigator.pop(context, _textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoughyAppBar(
          titleText: "Text",
          isCenterTitle: true,
          iconWidget: IconButton(
            icon: SvgPicture.asset('assets/icons/text_check_icon.svg'),
            tooltip: 'Save text',
            onPressed: setThisText,
          )),
      body: Form(
          key: _formKey,
          child: TextFormField(
              autofocus: true,
              maxLines: 100,
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 27, fontFamily: 'SimplicityRegular',color: Colors.black),
              controller: _textController,
              decoration: const InputDecoration(
                  hintText: 'Please enter text',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0)),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter text";
                }
                return null;
              })),
    );
  }
}
