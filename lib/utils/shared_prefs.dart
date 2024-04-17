// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends ChangeNotifier {
  SharedPrefs._(this._someVariable);

  int _someVariable = 0;

  static bool _didInit = false;
  // Obtain shared preferences.
  late final SharedPreferences _prefs;

/*
  factory SharedPrefs._read() {
    return SharedPrefs._(_prefs.getInt(Keys.someVariable) ?? 1,);
  }
  */

  factory SharedPrefs() => _instance;
  static late SharedPrefs _instance;

  // Initialize shared preferences.
  Future init() async {
    if (_didInit) return;
    _didInit = true;

    // Initialize shared preferences.
    _prefs = await SharedPreferences.getInstance();

    //WidgetsFlutterBinding.ensureInitialized();
  }

  /*
  Future<int> getDifficulty() {
    return _prefs.getInt(Keys.difficulty) ?? 1;
    // this 1 in the end is a default value
  }

  Future setDifficulty(int difficulty) {
    return _prefs.setInt(Keys.difficulty, difficulty);
  }
  */
}

class Keys {
  static const String someVariable = 'someVariable';
  // add more keys here
}
