import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cardConfigbutton.dart';

// ignore: camel_case_types
class createbutton extends StatefulWidget {
  createbutton({
    Key? key,
    required this.button,
    required this.removeButton
  }) : super(key: key);

  var button;
  final Function removeButton;

  @override
  State<createbutton> createState() => _createbuttonState();
}

class _createbuttonState extends State<createbutton> {
  List<dynamic> users = [];

  void _handleConfigButton(String id, String name, String api)
  {
    widget.removeButton(id, name, api);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: 160,
      height: 160,
      child: ElevatedButton(
        onPressed: (){
          createTask(widget.button);
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 100),
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: (){
                  showModalBottomSheet(
                  backgroundColor: const Color(0xFFE1F5FE),
                  isScrollControlled: true,
                  context: context,
                  shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))) ,
                  builder: (BuildContext content){
                    return Configbutton(configButton: _handleConfigButton, buttonid: widget.button.btnid, buttonname: widget.button.btnname, buttonapi: widget.button.btnapi,);
                  },);
                },
                icon: const Icon(Icons.more_vert),
                alignment: Alignment.topRight,
                iconSize: 30,
              ),
            ),
            Text(widget.button.btnname, style: const TextStyle(fontSize: 24),)
          ],
        ),
      ),
    );
  }

  void createTask(var buttonInfor) async {
    String url = 'http://172.16.64.62:8080/robot/task/start';
    print(buttonInfor.btnname);
    print(buttonInfor.btnapi);

    final uri = Uri.parse(url);
    String api = buttonInfor.btnapi;

    final jsonData = <String, dynamic>{
      'from': 'carly',
      'task_list': [{'poseid': 0, 'action': 'simplemove'}]
    };
    final encodedJson = jsonEncode(jsonData);
    print('Encoded JSON: $encodedJson'); // Print the encoded JSON

    try
    {
      final response = await http.post(uri,
          body: encodedJson,
      );
      print(response.body);
      if (response.statusCode == 201)
        {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create Mission Success'), backgroundColor: Colors.lightBlueAccent, duration: Duration(milliseconds: 1000),));
        }
      else
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create Mission \"' + buttonInfor.btnname + '\" Fail'), backgroundColor: Colors.red,));
        }
    }
    catch (e)
    {
      print(e);
    }
  }
}