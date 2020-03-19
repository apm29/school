import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:school/repo/Api.dart';
import 'package:school/repo/ApplyDetail.dart';
import 'package:school/repo/BlackLstDetail.dart';
import 'package:school/repo/DominationApplyDetail.dart';

import 'SchoolAlertListProvider.dart';

///
/// author : ciih
/// date : 2019-08-27 16:08
/// description :
///
class DominationListProvider extends ChangeNotifier {
  List<DominationApplyDetail> message = [];

  DominationListProvider() {
    //getApplyListData(refresh: true);
  }

  int page = 1;
  final pageSize = 20;
  bool loading = false;
  bool noMore = false;

  Future<LoadStateData> getApplyListData({bool refresh}) async {
    if (loading) {
      return LoadStateData(true, noMore);
    }
    loading = true;
    if (refresh) {
      page = 1;
      noMore = false;
      message.clear();
    }
    if (noMore) {
      loading = false;
      return LoadStateData(true, noMore);
    }
    var baseResponse = await Api.getDominationApplyListPageData(page, pageSize);
    if (baseResponse.success) {
      final list = baseResponse.data.rows ?? [];
      message.addAll(list);
      page += 1;
      noMore = list.length < pageSize;
      notifyListeners();
    } else {
      showToast(baseResponse.text);
    }
    loading = false;
    return LoadStateData(baseResponse.success, noMore);
  }
}
