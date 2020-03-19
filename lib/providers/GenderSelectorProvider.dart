import 'package:flutter/material.dart';

///
/// author : ciih
/// date : 2019-09-11 16:20
/// description : 
///
class GenderSelectProvider extends ChangeNotifier {
  String _gender;

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
    notifyListeners();
  }


}