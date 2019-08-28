import 'package:flutter/foundation.dart';

///
/// author : ciih
/// date : 2019-08-27 14:11
/// description : 
///
///
class LoadingProvider extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }
}