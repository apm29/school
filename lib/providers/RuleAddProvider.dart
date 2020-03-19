import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

///
/// author : ciih
/// date : 2019-09-11 15:57
/// description :
///
class RuleAddProvider extends ChangeNotifier {
  File _image;

  File get image => _image;

  set image(File value) {
    _image = value;
    notifyListeners();
  }

  RuleAddProvider();
}
