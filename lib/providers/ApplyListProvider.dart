import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:school/repo/Api.dart';
import 'package:school/repo/black_lists.dart';

///
/// author : ciih
/// date : 2019-08-27 16:08
/// description :
///
class BlackListProvider extends ChangeNotifier {
  List<BlackLists> message = [];

  BlackListProvider() {
    getBlackListData(refresh: true);
  }

  int page = 1;
  final pageSize = 20;
  bool loading = false;
  bool noMore = false;

  Future<LoadStateData> getBlackListData({bool refresh}) async {
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
    var baseResponse = await Api.getBlackListPageData(page, pageSize);
    if (baseResponse.success) {
      final list = baseResponse.data.blackLists ?? [];
      message.addAll(list);
      page += 1;
      noMore = list.length < pageSize;
      notifyListeners();
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
