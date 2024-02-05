import 'dart:async';
import 'dart:convert';
import 'package:agvcaller/Modal/buttons.dart';
import 'package:agvcaller/PerWidget/cardAddnewbutton.dart';
import 'package:agvcaller/PerWidget/cardcreatebutton.dart';
import 'package:agvcaller/app_state.dart';
import 'package:agvcaller/pages/zonea.dart';
import 'package:agvcaller/pages/zoneb.dart';
import 'package:agvcaller/pages/zonec.dart';
import 'package:agvcaller/pages/zoned.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/languages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main(List<String> args)
{
  runApp(
      MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: Locale(FFAppState().selectedLocale),
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
        // Locale('zh'),
      ],
    )
  );
}

class MyApp extends StatefulWidget
{
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  void handleRemoveButton(String id, String name, String api) {}
}

class _MyAppState extends State<MyApp> {
  final List<DataButton> buttons = [];
  late List<String>? buttonName = [];
  late List<String>? buttonApi = [];
  String currentZone = 'Zone A';
  Map<String, dynamic>? data;
  Map<String, dynamic>? responseData;

  late Locale _locale;

  void changeLocale(String languageCode) {
    final newLocale = Locale(languageCode);
    FFAppState().selectedLocale = languageCode; // Update the selectedLocale in your app state
    AppLocalizations.delegate.load(newLocale); // Load the new locale for the app
    setLocale(newLocale);
  }

  Future<void> getMapData() async {
    try {
      final response = await http.get(Uri.parse(FFAppState().getMapData));
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          FFAppState().mapName = data?['map'];
          FFAppState().zoneAWorkingPoint = data?['zonea'].cast<int>();
          FFAppState().zoneBWorkingPoint = data?['zoneb'].cast<int>();
          FFAppState().zoneCWorkingPoint = data?['zonec'].cast<int>();
          FFAppState().zoneDWorkingPoint = data?['zoned'].cast<int>();

          FFAppState().zoneAPointState = List<bool>.generate(FFAppState().zoneAWorkingPoint.length, (index) => false);
          FFAppState().zoneBPointState = List<bool>.generate(FFAppState().zoneBWorkingPoint.length, (index) => false);
          FFAppState().zoneCPointState = List<bool>.generate(FFAppState().zoneCWorkingPoint.length, (index) => false);
          FFAppState().zoneDPointState = List<bool>.generate(FFAppState().zoneDWorkingPoint.length, (index) => false);
        });
      } else {
      }
    }
    catch (exx){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Connect to Server fail!!!', style: TextStyle(fontSize: 28),),
            content: const Text('Please check the Server connection (Wifi, Power,...) and reopen this app', style: TextStyle(fontSize: 24),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() { });
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK', style: TextStyle(fontSize: 24),),
              ),
            ],
          );
        }
      );
    }
  }

  Widget _buildPage() {
    switch (currentZone) {
      case 'Zone A':
        return const ZoneA();
      case 'Zone B':
        return const ZoneB();
      case 'Zone C':
        return const ZoneC();
      case 'Zone D':
        return const ZoneD();
      case 'Languages':
        return const selectLanguages();
      default:
        return Container();
    }
  }

  void _onDrawerItemSelected(String pageName) {
    setState(() {
      currentZone = pageName;
      Navigator.pop(context);
    });
  }

  void _handleAddButton(String name, String api)
  {
    final newButton = DataButton(btnid: DateTime.now().toString(), btnname: name, btnapi: api, btncmdrunning: false, btnenable: true);
    setState(() {
      buttons.add(newButton);
    });
  }

  void _handleRemoveButton(String id, String name, String api)
  {
    setState(() {
      buttons.removeWhere((element) => element.btnid == id);
      removeDataButton(name, api);
    });
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  // void setLocale(String language) {
  //   setState(() => _locale = createLocale(language));
  //   FFLocalizations.storeLocale(language);
  // }
  //
  // String getLocale() {
  //   return _locale!.languageCode;
  // }

  late Timer syncTimer;

  @override
  void initState(){
    super.initState();
    // _loadButton();

    getMapData();
    syncTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      syncData();
      setState(() {

      });
    });
  }

  Future<void> syncData() async {
    try {
      final String apiUrl = FFAppState().getProductPosition;
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        processFetchedData(responseData);
      } else {
        // Handle error
        print('GET Request failed with status: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (error) {
      // Handle other potential errors, e.g., network error
      // print('Error during GET request: $error');
    }
  }

  void processFetchedData(Map<String, dynamic>? data) {
    if (data?['zonea'] == null)
      {
        FFAppState().zoneAPointState = List<bool>.generate(FFAppState().zoneAWorkingPoint.length, (index) => false);
        // print(FFAppState().zoneAPointState);
      }
    else
      {
        FFAppState().zoneAHavingProduct = data?['zonea'].cast<int>();
        for (int i = 0; i < FFAppState().zoneAWorkingPoint.length; i++)
        {
          for (int j = 0; j < FFAppState().zoneAHavingProduct.length; j++)
          {
            if (FFAppState().zoneAWorkingPoint[i] == FFAppState().zoneAHavingProduct[j])
            {
              FFAppState().zoneAPointState[i] = true;
              break;
            }
            else
              {
                FFAppState().zoneAPointState[i] = false;
              }
          }
        }
      }
    if (data?['zoneb'] == null)
    {
      FFAppState().zoneBPointState = List<bool>.generate(FFAppState().zoneBWorkingPoint.length, (index) => false);
    }
    else
    {
      FFAppState().zoneBHavingProduct = data?['zoneb'].cast<int>();

      for (int i = 0; i < FFAppState().zoneBWorkingPoint.length; i++)
      {
        for (int j = 0; j < FFAppState().zoneBHavingProduct.length; j++)
        {
          if (FFAppState().zoneBWorkingPoint[i] == FFAppState().zoneBHavingProduct[j])
          {
            FFAppState().zoneBPointState[i] = true;
            break;
          }
          else
          {
            FFAppState().zoneBPointState[i] = false;
          }
        }
      }
    }
    if (data?['zonec'] == null)
    {
      FFAppState().zoneCPointState = List<bool>.generate(FFAppState().zoneCWorkingPoint.length, (index) => false);
    }
    else
    {
      FFAppState().zoneCHavingProduct = data?['zonec'].cast<int>();
    }
    if (data?['zoned'] == null)
    {
      FFAppState().zoneDPointState = List<bool>.generate(FFAppState().zoneDWorkingPoint.length, (index) => false);
    }
    else
    {
      FFAppState().zoneDHavingProduct = data?['zoned'].cast<int>();
    }
  }

  void _loadButton() async {
    final addButtonNametoStorage = await SharedPreferences.getInstance();
    final addButtonApitoStorage = await SharedPreferences.getInstance();
    setState(() {
      buttonName = addButtonNametoStorage.getStringList('buttonName');
      buttonApi = addButtonApitoStorage.getStringList('buttonApi');
      if (buttonName!.isNotEmpty)
        {
          for (int i = 0; i < buttonName!.length; i++)
            {
              _handleAddButton(buttonName![i], buttonApi![i]);
              getOldDataButton(buttonName![i], buttonApi![i]);
            }
        }
    });
  }

  @override
  void dispose() {
    // Stop the timer when the screen is disposed to avoid memory leaks
    syncTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(FFAppState().mapName, style: const TextStyle(fontSize: 28),),
          actions: [
            Align(
              child: Text((currentZone=='Zone A')?AppLocalizations.of(context)!.zonea:(currentZone=='Zone B')?AppLocalizations.of(context)!.zoneb:(currentZone=='Zone C')?AppLocalizations.of(context)!.zonec:AppLocalizations.of(context)!.zoned, style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
              ),),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                children: buttons.map((buttoninList) => createbutton(button: buttoninList, removeButton: _handleRemoveButton,)).toList(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _buildPage(),
              )
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){
        //     showModalBottomSheet(
        //       backgroundColor: const Color(0xFFE1F5FE),
        //       isScrollControlled: true,
        //       context: context,
        //       shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))) ,
        //       builder: (BuildContext content){
        //           return Addnewbutton(addButton: _handleAddButton);
        //     },);
        //   },
        //   child: const Icon(Icons.add, size: 40,),
        // ),
        drawer: Drawer(
          elevation: 40,
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text('admin',
                  style: TextStyle(
                      fontSize: 24
                  ),), accountEmail: null,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.zonea, style: const TextStyle(
                    fontSize: 24
                ),),
                onTap: (){
                  setState(() {
                    _onDrawerItemSelected('Zone A');
                  });
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.zoneb,
                  style: const TextStyle(
                      fontSize: 24
                  ),),
                onTap: (){
                  setState(() {
                    _onDrawerItemSelected('Zone B');
                  });
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.zonec,
                  style: const TextStyle(
                      fontSize: 24
                  ),),
                onTap: (){
                  setState(() {
                    _onDrawerItemSelected('Zone C');
                  });
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.zoned,
                  style: const TextStyle(
                      fontSize: 24
                  ),),
                onTap: (){
                  setState(() {
                    _onDrawerItemSelected('Zone D');
                  });
                },
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ListTile(
                    hoverColor: Colors.blue,
                    dense: true,
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    title: Text(AppLocalizations.of(context)!.setting, style: const TextStyle(fontSize: 24),),
                    onTap: () {
                      setState(() {
                        _onDrawerItemSelected('Languages');
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}