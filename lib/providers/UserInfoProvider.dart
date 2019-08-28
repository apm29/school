import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/Configs.dart';
import 'package:school/repo/Api.dart';

import 'SchoolAlertListProvider.dart';

///
/// author : ciih
/// date : 2019-08-27 16:05
/// description :
///
class UserInfoProvider extends ChangeNotifier {
  UserInfo userInfo;
  String token;

  String get schoolString {
    if ((userInfo?.district?.length ?? 0) == 0) {
      return null;
    } else {
      return userInfo?.district?.first?.districtName;
    }
  }

  String get roleString {
    if ((userInfo?.roles?.length ?? 0) == 0) {
      return null;
    } else {
      return userInfo?.roles?.first?.roleName;
    }
  }

  Future getUserInfoAndLogin(String token) async {
    userSp.setString(KEY_TOKEN, token);
    this.token = token;
    var baseResponse = await Api.getUserInfo();
    if (baseResponse.success) {
      userInfo = baseResponse.data;
    } else {
      showToast(baseResponse.text);
    }

    notifyListeners();
  }

  UserInfoProvider() {
    var token = userSp.getString(KEY_TOKEN);
    if (token != null) {
      getUserInfoAndLogin(token);
    }
  }

  void logout() {
    this.token = null;
    this.userInfo = null;
    notifyListeners();
  }

  ///
  /// 7 普通用户
  /// 8 保安人员
  /// 9 学校管理员
  /// 10民警
  /// 11民警管理员
  bool get isAdmin =>
      userInfo?.roles?.firstWhere(
          (role) => role.roleCode == "9" || role.roleCode == "11",
          orElse: () => null) !=
      null;

  bool get isPoliceRole =>
      userInfo?.roles?.firstWhere(
          (role) => role.roleCode == "10" || role.roleCode == "11",
          orElse: () => null) !=
      null;

  bool get isSecurity =>
      userInfo?.roles
          ?.firstWhere((role) => role.roleCode == "8", orElse: () => null) !=
      null;

  bool get isLogin => userInfo != null && token != null;
}
