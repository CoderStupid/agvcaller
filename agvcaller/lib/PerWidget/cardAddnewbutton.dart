import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> buttonName =[];
final List<String> buttonApi =[];

class Addnewbutton extends StatefulWidget {
  Addnewbutton({
    Key? key,
    required this.addButton
  }) : super(key: key);

  final Function addButton;

  @override
  State<Addnewbutton> createState() => _AddnewbuttonState();
}

void getOldDataButton(String name, String api)
{
  buttonName.add(name);
  buttonApi.add(api);
}

void removeDataButton(String name, String api)
{
  buttonName.removeWhere((element) => element == name);
  buttonApi.removeWhere((element) => element == api);
  createStorage();
}

void createStorage() async
{
  final addButtonNametoStorage = await SharedPreferences.getInstance();
  final addButtonApitoStorage = await SharedPreferences.getInstance();
  addButtonNametoStorage.setStringList('buttonName', buttonName);
  addButtonApitoStorage.setStringList('buttonApi', buttonApi);
}

class _AddnewbuttonState extends State<Addnewbutton> {
  String txtBtnName = '';
  String txtApicode = '';

  TextEditingController controllerButtonName = TextEditingController();
  TextEditingController controllerApicode = TextEditingController();

  void _handleOnclick(BuildContext context) async
  {
    // final addButtonNametoStorage = await SharedPreferences.getInstance();
    // final addButtonApitoStorage = await SharedPreferences.getInstance();
    if (controllerButtonName.text.isEmpty || controllerApicode.text.isEmpty)
      {
        return;
      }
    widget.addButton(controllerButtonName.text, controllerApicode.text);
    buttonName.add(controllerButtonName.text);
    buttonApi.add(controllerApicode.text);

    setState(() {
      createStorage();
      // addButtonNametoStorage.setStringList('buttonName', buttonName);
      // addButtonApitoStorage.setStringList('buttonApi', buttonApi);
      print('-------------------------------------------------------$buttonName');
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
            TextField(
              controller: controllerButtonName,
              decoration: const InputDecoration(
                  labelText: 'Button Name',
                  fillColor: Colors.white,
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: controllerApicode,
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  labelText: 'Mission Name',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: ()=> _handleOnclick(context),
                    child: const Text('Add Button')))
          ],
        ),
      ),
    );
  }
}
