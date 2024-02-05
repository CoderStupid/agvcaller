import 'package:agvcaller/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_state.dart';

const _kLocaleStorageKey = '__locale_key__';

class selectLanguages extends StatefulWidget{
  const selectLanguages({Key? key}) : super(key: key);

  @override
  _selectLanguagesState createState() => _selectLanguagesState();
}

class _selectLanguagesState extends State<selectLanguages>{

  static late SharedPreferences _prefs;
  // static Locale? getStoredLocale() {
  //   final locale = _prefs.getString(_kLocaleStorageKey);
  //   return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  // }

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
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
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 190,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            FFAppState().selectedLocale = 'en';
                            // MyApp.of(context).setLocale(Locale.fromSubtags(languageCode: FFAppState().selectedLocale));
                            MyApp.of(context).changeLocale(FFAppState().selectedLocale);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (FFAppState().selectedLocale == 'en') ? Colors.green : Colors.red,
                          ),
                          child: Text(AppLocalizations.of(context)!.english, style: const TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 190,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            FFAppState().selectedLocale = 'vi';
                            // MyApp.of(context).setLocale(Locale.fromSubtags(languageCode: FFAppState().selectedLocale));
                            MyApp.of(context).changeLocale(FFAppState().selectedLocale);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (FFAppState().selectedLocale == 'vi') ? Colors.green : Colors.red,
                          ),
                          child: Text(AppLocalizations.of(context)!.vietnam, style: const TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(20),
                    //   child: SizedBox(
                    //     width: 190,
                    //     height: 100,
                    //     child: ElevatedButton(
                    //       onPressed: (){
                    //         setState(() {
                    //
                    //         });
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         // backgroundColor: FFAppState().zoneAPointState[i]?Colors.green:Colors.red
                    //         // backgroundColor: Colors.red
                    //       ),
                    //       child: Text('Chinese', style: const TextStyle(fontSize: 20), ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}

// void setAppLanguage(BuildContext context, String language) =>
//     MyApp.of(context).setLocale(language);