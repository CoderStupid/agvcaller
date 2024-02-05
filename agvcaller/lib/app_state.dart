import 'package:flutter/material.dart';

import 'main.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String getMapData = 'http://10.20.28.123:5000/api/point/available';
  String setMapData = 'http://10.20.28.123:5000/api/point/working/set';
  String getProductPosition = 'http://10.20.28.123:5000/api/point/working/info';
  String createTask = 'http://10.20.28.123:5000/api/mission/add';
  String mapName = '';
  List<int> zoneAWorkingPoint = [];
  List<int> zoneBWorkingPoint = [];
  List<int> zoneCWorkingPoint = [];
  List<int> zoneDWorkingPoint = [];
  List<bool> zoneAPointState =[];
  List<bool> zoneBPointState =[];
  List<bool> zoneCPointState =[];
  List<bool> zoneDPointState =[];
  List<int> zoneAHavingProduct = [];
  List<int> zoneBHavingProduct = [];
  List<int> zoneCHavingProduct = [];
  List<int> zoneDHavingProduct = [];
  String selectedLocale = 'vi';
}
