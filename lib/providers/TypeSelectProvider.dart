import 'package:flutter/material.dart';

///
/// author : ciih
/// date : 2019-09-11 16:20
/// description : 
///
class TypeSelectProvider extends ChangeNotifier {
  int _type;

  int get type => _type;

  set type(int value) {
    _type = value;
    notifyListeners();
  }


}