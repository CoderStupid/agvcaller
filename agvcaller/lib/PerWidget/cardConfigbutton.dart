import 'package:agvcaller/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> buttonName =[];
final List<String> buttonApi =[];

class Configbutton extends StatefulWidget {
  Configbutton({
    Key? key,
    required this.configButton,
    required this.buttonname,
    required this.buttonapi,
    required this.buttonid
  }) : super(key: key);

  late String buttonname;
  late String buttonapi;
  late String buttonid;
  final Function configButton;

  @override
  State<Configbutton> createState() => _ConfigbuttonState();
}

// void getOldDataButton(String name, String api)
// {
//   buttonName.add(name);
//   buttonApi.add(api);
// }

class _ConfigbuttonState extends State<Configbutton> {
  String txtBtnName = '';
  String txtApicode = '';

  TextEditingController controllerButtonName = TextEditingController();
  TextEditingController controllerApicode = TextEditingController();

  void _handleOnclick(String id, String name, String api) async
  {
    // final addButtonNametoStorage = await SharedPreferences.getInstance();
    // final addButtonApitoStorage = await SharedPreferences.getInstance();
    // if (controllerButtonName.text.isEmpty || controllerApicode.text.isEmpty)
    // {
    //   return;
    // }
    widget.configButton(id, name, api);
    // buttonName.add(controllerButtonName.text);
    // buttonApi.add(controllerApicode.text);

    setState(() {
      // addButtonNametoStorage.setStringList('buttonName', buttonName);
      // addButtonApitoStorage.setStringList('buttonApi', buttonApi);
      // print('-------------------------------------------------------$buttonName');
      // print(addButtonNametoStorage);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Button Name',
                  fillColor: Colors.white,
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            const TextField(
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: 'Mission Name',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      _handleOnclick(widget.buttonid, widget.buttonname, widget.buttonapi);
                    },
                    child: const Text('Delete', style: TextStyle(fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
                    )
                    ),
                  ),
                const SizedBox(width: 50,),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){},
                    child: const Text('Config', style: TextStyle(fontSize: 20))
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
