import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../app_state.dart';

class ZoneC extends StatefulWidget{
  const ZoneC({Key? key}) : super(key: key);

  @override
  _ZoneCState createState() => _ZoneCState();
}

class _ZoneCState extends State<ZoneC>{
  String pickUpZone = '';
  late int pickUpPoint;
  late Timer syncTimer;

  void _showPopupMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                message,
                style: const TextStyle(fontSize: 22.0),
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  Future<void> _postMission(String map, int startPoint, String startZone, int endPoint, String endZone) async {
    final String apiUrl = FFAppState().createTask;
    Map<String, dynamic> requestBody = {
      "name": "pickup_${startPoint}_drop_$endPoint",
      "map": map,
      "start": startPoint,
      "end": endPoint,
      "start_zone": startZone,
      "end_zone": endZone
    };
    String jsonBody = json.encode(requestBody);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonBody,
      );
      if (response.statusCode == 200) {
        _showPopupMessage(context, AppLocalizations.of(context)!.success);
        pickUpPoint = 0;
      } else {
        _showPopupMessage(context, AppLocalizations.of(context)!.fail + response.statusCode.toString());
      }

    } catch (error) {
      _showPopupMessage(context, AppLocalizations.of(context)!.fail + error.toString());
    }
  }

  @override
  void initState(){
    super.initState();
    syncTimer = Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
      setState(() {

      });
    });
  }

  @override
  void dispose(){
    syncTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.2,
              child: Align(
                alignment: const AlignmentDirectional(1.5, -0.8),
                child: Lottie.asset(
                  'assets/lottie_animations/IcBGmfCvRf.json',
                  width: 492.0,
                  height: 343.0,
                  fit: BoxFit.fill,
                  animate: true,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(AppLocalizations.of(context)!.transferFrom, style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightBlueAccent),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  width: 190,
                                  height: 100,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      pickUpZone = 'zonea';
                                      pickUpPoint = 0;
                                      setState(() {
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: pickUpZone=='zonea'?Colors.green:pickUpZone=='zoneb'?Colors.blueGrey:Colors.blue
                                    ),
                                    child: Text(AppLocalizations.of(context)!.zonea, style: const TextStyle(fontSize: 20)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  width: 190,
                                  height: 100,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      pickUpZone='zoneb';
                                      pickUpPoint = 0;
                                      setState(() {
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: pickUpZone=='zoneb'?Colors.green:pickUpZone=='zonea'?Colors.blueGrey:Colors.blue
                                    ),
                                    child: Text(AppLocalizations.of(context)!.zoneb, style: const TextStyle(fontSize: 20)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (pickUpZone == 'zonea')
                          for (int i = 0; i < FFAppState().zoneAWorkingPoint.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: SizedBox(
                                width: 190,
                                height: 100,
                                child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      // _showConfirmationDialog(i);
                                      if (FFAppState().zoneAPointState[i])
                                      {
                                        if (pickUpPoint == 0)
                                        {
                                          pickUpPoint = FFAppState().zoneAWorkingPoint[i];
                                        }
                                        else if (pickUpPoint == FFAppState().zoneAWorkingPoint[i])
                                        {
                                          pickUpPoint = 0;
                                        }
                                        else
                                        {
                                          pickUpPoint = FFAppState().zoneAWorkingPoint[i];
                                        }
                                        // print('zone A pickup point $pickUpPoint');
                                      }
                                      else
                                      {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                              return AlertDialog(
                                                title: Text(AppLocalizations.of(context)!.warning, style: const TextStyle(fontSize: 28),),
                                                content: Text(AppLocalizations.of(context)!.noTrolley, style: const TextStyle(fontSize: 24)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() { });
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: const Text('OK', style: TextStyle(fontSize: 24)),
                                                  ),
                                                ],
                                              );
                                            }
                                        );
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: (FFAppState().zoneAWorkingPoint[i]==pickUpPoint)?Colors.lime:FFAppState().zoneAPointState[i]?Colors.green:Colors.red
                                  ),
                                  child: Text('${FFAppState().zoneAWorkingPoint[i]}', style: const TextStyle(fontSize: 20), ),
                                ),
                              ),
                            ),
                        if (pickUpZone == 'zoneb')
                          for (int i = 0; i < FFAppState().zoneBWorkingPoint.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: SizedBox(
                                width: 190,
                                height: 100,
                                child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      // _showConfirmationDialog(i);
                                      if (FFAppState().zoneBPointState[i])
                                      {
                                        if (pickUpPoint == 0)
                                        {
                                          pickUpPoint = FFAppState().zoneBWorkingPoint[i];
                                        }
                                        else if (pickUpPoint == FFAppState().zoneBWorkingPoint[i])
                                        {
                                          pickUpPoint = 0;
                                        }
                                        else
                                        {
                                          pickUpPoint = FFAppState().zoneBWorkingPoint[i];
                                        }
                                        // print('zone B pickup point $pickUpPoint');
                                      }
                                      else
                                      {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                              return AlertDialog(
                                                title: Text(AppLocalizations.of(context)!.warning, style: const TextStyle(fontSize: 28)),
                                                content: Text(AppLocalizations.of(context)!.noTrolley, style: const TextStyle(fontSize: 24)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() { });
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: const Text('OK', style: TextStyle(fontSize: 24)),
                                                  ),
                                                ],
                                              );
                                            }
                                        );
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: (FFAppState().zoneBWorkingPoint[i]==pickUpPoint)?Colors.lime:FFAppState().zoneBPointState[i]?Colors.green:Colors.red
                                  ),
                                  child: Text('${FFAppState().zoneBWorkingPoint[i]}', style: const TextStyle(fontSize: 20), ),
                                ),
                              ),
                            ),
                      ],
                    ))
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(AppLocalizations.of(context)!.transferTo, style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2.0,           // Border width
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)), // Optional: border radius
                  ),
                  child: Row(
                    children: [
                      for(int i = 0; i < FFAppState().zoneCWorkingPoint.length; i++)
                        Expanded(child:
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: 190,
                            height: 100,
                            child: ElevatedButton(
                              onPressed: (){
                                if (pickUpPoint == 0)
                                {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(AppLocalizations.of(context)!.warning, style: const TextStyle(fontSize: 28)),
                                          content: Text(AppLocalizations.of(context)!.noStartPoint, style: const TextStyle(fontSize: 24)),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                setState(() { });
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('OK', style: TextStyle(fontSize: 24)),
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }
                                else
                                {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(AppLocalizations.of(context)!.confirm),
                                          // content: Text('Transfer Trolley From ${pickUpZone == 'zonea'?'Zone A':'Zone B'} - $pickUpPoint To Zone C - ${FFAppState().zoneCWorkingPoint[i]}',
                                          content: Text(AppLocalizations.of(context)!.confirmTransfer(FFAppState().zoneCWorkingPoint[i], pickUpPoint.toString(), AppLocalizations.of(context)!.zonec, (pickUpZone == 'zonea')?AppLocalizations.of(context)!.zonea:AppLocalizations.of(context)!.zoneb),
                                              style: const TextStyle(fontSize: 28)
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(fontSize: 24)),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await _postMission(FFAppState().mapName, pickUpPoint, pickUpZone, FFAppState().zoneCWorkingPoint[i], 'zonec');
                                              },
                                              child: Text(AppLocalizations.of(context)!.confirm, style: const TextStyle(fontSize: 24)),
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }
                              },
                              child: Text('${FFAppState().zoneCWorkingPoint[i]}', style: const TextStyle(fontSize: 20), ),
                            ),
                          ),
                        )
                        )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}