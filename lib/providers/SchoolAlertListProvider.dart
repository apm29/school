import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:school/repo/AlertMessage.dart';
import 'package:school/repo/Api.dart';
import 'package:school/repo/BlackLstDetail.dart';

///
/// author : ciih
/// date : 2019-08-27 16:08
/// description :
///

class PoliceAlertListProvider extends ChangeNotifier {
  List<AlertMessage> message = [];

  PoliceAlertListProvider() {
    //getBlackListData(refresh: true);
  }

  int page = 1;
  final pageSize = 20;
  bool loading = false;
  bool noMore = false;

  Future<LoadStateData> getPoliceAlertList({bool refresh}) async {
    if (loading) {
      return LoadStateData(true,noMore);
    }
    loading = true;
    if (refresh) {
      page = 1;
      noMore = false;
      message.clear();
    }
    if (noMore) {
      return LoadStateData(true,noMore);
    }
    var baseResponse = await Api.getPoliceAlertMessageListPageData(page, pageSize);
    if (baseResponse.success) {
      final list = baseResponse.data.rows ?? [];
      message.addAll(list);
      page += 1;
      noMore = list.length < pageSize;
      notifyListeners();
    }else{
      showToast(baseResponse.text);
    }
    loading = false;
    return LoadStateData(baseResponse.success,noMore);
  }
}


class LoadStateData{
  final bool success;
  final bool noMore;

  LoadStateData(this.success, this.noMore);

}
