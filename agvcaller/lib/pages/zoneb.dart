import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '../app_state.dart';

class ZoneB extends StatefulWidget{
  const ZoneB({Key? key}) : super(key: key);

  @override
  _ZoneBState createState() => _ZoneBState();
}

class _ZoneBState extends State<ZoneB>{

  Future<void> _showConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmTilte, style: const TextStyle(fontSize: 24),),
          content: Text(FFAppState().zoneBPointState[index]?AppLocalizations.of(context)!.posEmpty(FFAppState().zoneBWorkingPoint[index]):AppLocalizations.of(context)!.posHaveTrolley(FFAppState().zoneBWorkingPoint[index]),
            style: const TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(fontSize: 20),),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  FFAppState().zoneBPointState[index] = !FFAppState().zoneBPointState[index];
                });
                Navigator.of(context).pop();
                await _postButtonStateToApi(FFAppState().mapName, FFAppState().zoneBWorkingPoint[index], FFAppState().zoneBPointState[index]?1:0);
              },
              child: Text(AppLocalizations.of(context)!.confirm, style: const TextStyle(fontSize: 20),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _postButtonStateToApi(String map, int position, int status) async {
    final String apiUrl = FFAppState().setMapData;
    Map<String, dynamic> requestBody = {
      "map": map,
      "zone": "zoneb",
      "position": position,
      "status": status
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
      } else {
        _showPopupMessage(context, AppLocalizations.of(context)!.fail + response.statusCode.toString());
      }
    } catch (error) {
      _showPopupMessage(context, AppLocalizations.of(context)!.fail + error.toString());
    }
  }

  void _showPopupMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
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

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  late Timer syncTimer;

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
      body: Container(
        alignment: Alignment.center,
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
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  for (int i = 0; i < FFAppState().zoneBWorkingPoint.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 190,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: (){
                            setState(() {
                              _showConfirmationDialog(i);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: FFAppState().zoneBPointState[i]?Colors.green:Colors.red
                            // backgroundColor: Colors.red
                          ),
                          child: Text('${FFAppState().zoneBWorkingPoint[i]}', style: const TextStyle(fontSize: 20), ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          ],
        )
      ),
    );
  }
}