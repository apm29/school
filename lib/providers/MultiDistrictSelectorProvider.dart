import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:school/repo/Api.dart';

///
/// author : ciih
/// date : 2019-09-12 10:16
/// description : 
///

class MultiDistrictSelectorProvider extends ChangeNotifier{
  HashSet<DistrictInfo> _currentSelect = HashSet();

  HashSet<DistrictInfo> get currentSelect => _currentSelect??HashSet();


  void add(DistrictInfo district) {
    if(district!=null) {
      district.selected = true;
      _currentSelect.add(district);
      notifyListeners();
    }
  }

  void single(DistrictInfo district) {
    if(district!=null) {
      district.selected = true;
      _currentSelect.clear();
      _currentSelect.add(district);
      notifyListeners();
    }
  }

}