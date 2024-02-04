import 'package:chatgpt/constants/constant.dart';
import 'package:flutter/material.dart';

class MyDropDownWidget extends StatefulWidget {
  const MyDropDownWidget({ Key? key }) : super(key: key);

  @override
  State<MyDropDownWidget> createState() => _MyDropDownWidgetState();
}

class _MyDropDownWidgetState extends State<MyDropDownWidget> {

  String currentModel = "Model1";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: scaffoldBackgroundColor,
      iconEnabledColor: Colors.white,
      items:  getModelsItem,
      value: currentModel,
      onChanged: (value) {
        setState(() {
          currentModel = value.toString();
        });
      },
    );
  }
}