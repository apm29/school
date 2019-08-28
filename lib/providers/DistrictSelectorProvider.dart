import 'package:flutter/cupertino.dart';
import 'package:school/repo/Api.dart';

///
/// author : ciih
/// date : 2019-08-27 15:09
/// description : 
///
class DistrictSelectorProvider extends ChangeNotifier{
  DistrictInfo _currentSelect;

  DistrictInfo get currentSelect => _currentSelect;

  set currentSelect(DistrictInfo value) {
    _currentSelect = value;
    print('DistrictSelectorProvider.currentSelect');
    notifyListeners();
  }

}