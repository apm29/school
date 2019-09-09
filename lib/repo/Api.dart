import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:school/Configs.dart';
import 'package:school/repo/AlertMessageListPageData.dart';
import 'package:school/repo/ApplyListPageData.dart';
import 'package:school/repo/BlackListPageData.dart';

///
/// author : ciih
/// date : 2019-08-27 14:01
/// description :
///
///

class Api {
  static Future<BaseResponse<UserInfoWrapper>> login(
      String userName, String password,
      {CancelToken cancelToken}) async {
    return DioUtil().post<UserInfoWrapper>("/permission/login",
        processor: (json) => UserInfoWrapper.fromJson(json),
        formData: {
          "userName": userName,
          "password": password,
        },
        cancelToken: cancelToken);
  }

  static Future<BaseResponse<UserInfoWrapper>> fastLogin(
      String mobile, String verifyCode,
      {CancelToken cancelToken}) async {
    return DioUtil().post<UserInfoWrapper>("/permission/fastLogin",
        processor: (json) => UserInfoWrapper.fromJson(json),
        formData: {
          "mobile": mobile,
          "verifyCode": verifyCode,
        },
        cancelToken: cancelToken);
  }

  static Future<BaseResponse<UserInfo>> getUserInfo(
      {CancelToken cancelToken}) async {
    return DioUtil().post<UserInfo>("/permission/user/getUserInfo",
        processor: (json) => UserInfo.fromJson(json), cancelToken: cancelToken);
  }

  ///type  0 注册 ,其他登录
  static Future<BaseResponse<Object>> sendSms(String mobile, int type,
      {CancelToken cancelToken}) async {
    return DioUtil().post<Object>("/permission/user/getVerifyCode",
        processor: (dynamic json) => null,
        formData: {"mobile": mobile, "type": type},
        cancelToken: cancelToken);
  }

  ///
  ///@param type 1学校安保，2民警
  ///
  static Future<BaseResponse> register(
      {String userName,
      String password,
      String mobile,
      String code,
      int districtId,
      int type,
      CancelToken cancelToken}) async {
    return DioUtil().post(
      "/permission/user/register",
      processor: (dynamic json) => null,
      formData: {
        "userName": userName,
        "password": password,
        "mobile": mobile,
        "code": code,
        "districtId": districtId,
        "type": type,
      },
      cancelToken: cancelToken,
    );
  }

  ///结果（1通过，2拒绝）
  static Future<BaseResponse> applyApprove(
      {int id, int result, CancelToken cancelToken}) async {
    return DioUtil().post(
      "/business/districtApprove/apply",
      processor: (dynamic json) => null,
      formData: {
        "id": id,
        "result": result,
      },
      cancelToken: cancelToken,
    );
  }

  static Future<BaseResponse> replyAlert(
      {int id, String content, CancelToken cancelToken}) async {
    return DioUtil().post(
      "/business/alarmLog/replyAlarm",
      processor: (dynamic json) => null,
      formData: {
        "id": id,
        "content": content,
      },
      cancelToken: cancelToken,
    );
  }

  static Future<BaseResponse<List<DistrictInfo>>> getAllDistrictInfo(
      {CancelToken cancelToken}) {
    return DioUtil().post(
      "/business/district/getAllDistrictInfo",
      processor: (dynamic json) {
        if (json is List) {
          return json.map((src) => DistrictInfo.fromJson(src)).toList();
        }
        return [];
      },
      cancelToken: cancelToken,
    );
  }

  static Future<BaseResponse<BlackListPageData>> getBlackListPageData(
      int page, int rows) {
    return DioUtil().post(
      "/business//blacklist/getBlackList",
      formData: {
        "page": page,
        "rows": rows,
      },
      processor: (s) {
        return BlackListPageData.fromJsonMap(s);
      },
    );
  }

  static Future<BaseResponse<AlertMessageListPageData>>
      getAlertMessageListPageData(
    int page,
    int rows,
  ) {
    return DioUtil().post(
      "/business/MessageCenter/getMyMessage",
      formData: {
        "page": page,
        "rows": rows,
      },
      processor: (s) {
        return AlertMessageListPageData.fromJsonMap(s);
      },
    );
  }

  static Future<BaseResponse<AlertMessageListPageData>>
      getPoliceAlertMessageListPageData(
    int page,
    int rows,
  ) {
    return DioUtil().post(
      "/business/alarmLog/getAlarmLog",
      formData: {
        "page": page,
        "rows": rows,
      },
      processor: (s) {
        return AlertMessageListPageData.fromJsonMap(s);
      },
    );
  }

  static Future<BaseResponse<ApplyListPageData>> getApplyListPageData(
      int page, int rows,
      {int status}) {
    var data = {
      "page": page,
      "rows": rows,
    };
    if (status != null) {
      data['status'] = status;
    }
    return DioUtil().post(
      "/business/districtApprove/getApplyList",
      formData: data,
      processor: (s) {
        return ApplyListPageData.fromJsonMap(s);
      },
    );
  }
}

typedef processor<T> = T Function(dynamic json);

const KEY_HEADER_TOKEN = "Authorization";
const KEY_DEVICE_TOKEN = "DeviceToken";

class DioUtil {
  DioUtil._() {
    init();
  }

  static bool proxyHttp = false;
  static bool printLog = true;
  static DioUtil _instance;

  static DioUtil getInstance() {
    if (_instance == null) {
      _instance = DioUtil._();
    }
    return _instance;
  }

  factory DioUtil() {
    return getInstance();
  }

  Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(
      method: "POST",
      connectTimeout: 10000,
      receiveTimeout: 20000,
      baseUrl: BASE_URL,
    ));
    //设置代理
    if (proxyHttp)
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // config the http client
        client.findProxy = (uri) {
          //proxy all request to localhost:8888
          return "PROXY 192.168.1.181:8888";
        };
        // you can also create a new HttpClient to dio
        // return new HttpClient();
      };
    if (printLog)
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (req) {
            debugPrint("REQUEST:");
            debugPrint("===========================================");
            debugPrint("  Method:${req.method},Url:${req.baseUrl + req.path}");
            debugPrint("  Headers:${req.headers}");
            debugPrint("  QueryParams:${req.queryParameters}");
            print('=======>${req.data.runtimeType}');
            if (req.data.runtimeType != FormData) {
              debugPrint("    Data:${req.data}");
            } else {
              debugPrint("  Data:${req.data}");
            }

            debugPrint("===========================================");
          },
          onResponse: (resp) {
            debugPrint("REQUEST:");
            debugPrint("===========================================");
            debugPrint(
                "  Method:${resp.request.method},Url:${resp.request.baseUrl + resp.request.path}");
            debugPrint("  Headers:${resp.request.headers}");
            debugPrint("  QueryParams:${resp.request.queryParameters}");
            if (resp.request.data.runtimeType != FormData) {
              debugPrint("  Data:${resp.request.data}");
            } else {
              debugPrint("  Data:${resp.request.data}");
            }
            debugPrint("  -------------------------");
            debugPrint("  RESULT:");
            debugPrint("    Headers:${resp.headers}");
            debugPrint("  Data:${resp.data}");
            debugPrint("    Redirect:${resp.redirects}");
            debugPrint("    StatusCode:${resp.statusCode}");
            debugPrint("    Extras:${resp.extra}");
            debugPrint(" ===========================================");
          },
          onError: (err) {
            debugPrint("ERROR:");
            debugPrint("===========================================");
            debugPrint("Message:${err.message}");
            debugPrint("Error:${err.error}");
            debugPrint("Type:${err.type}");
            debugPrint("Trace:${err.stackTrace}");
            debugPrint("===========================================");
          },
        ),
      );
  }

  Future<BaseResponse<T>> post<T>(
    String path, {
    @required processor<T> processor,
    Map<String, dynamic> formData,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress,
    bool showProgress = false,
    String loadingText,
    bool toastMsg = false,
  }) async {
    assert(!showProgress || loadingText != null);
    assert(processor != null);
    processor = processor ?? (dynamic raw) => null;
    formData = formData ?? {};
    toastMsg = toastMsg ?? false;
    cancelToken = cancelToken ?? CancelToken();
    onReceiveProgress = onReceiveProgress ??
        (count, total) {
          ///默认接收进度
        };
    onSendProgress = onSendProgress ??
        (count, total) {
          ///默认发送进度
        };

    print('$BASE_URL$path $formData');
    ToastFuture toastFuture;
    if (showProgress) {
      toastFuture = showLoadingWidget(loadingText);
    }
    return _dio
        .post(
      path,
      data: FormData.from(formData),
      options: RequestOptions(
        responseType: ResponseType.json,
        headers: {
          KEY_HEADER_TOKEN: userSp.getString(KEY_TOKEN),
          KEY_DEVICE_TOKEN: userSp.getString(KEY_XG_PUSH_DEVICE_TOKEN),
        },
        contentType: ContentType.json,
      ),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    )
        .then((resp) {
      return resp.data;
    }).then((map) {
      debugPrint("$BASE_URL$path");
      debugPrint("${map.runtimeType}");
      if (map.runtimeType == String) {
        map = jsonDecode(map);
      }
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String prettyStr = encoder.convert(map);
      debugPrint(prettyStr);
      String status = map["status"];
      String text = map["text"];
      String token = map["token"];
      dynamic _rawData = map["data"];
      try {
        T data = processor(_rawData);
        return BaseResponse<T>(status, data, token, text);
      } catch (e) {
        print(e);
        return BaseResponse<T>(status, null, token, text);
      }
    }).catchError((e, StackTrace s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      if (e is DioError && toastMsg) {
        showToast(e.message);
      }
      return BaseResponse.error(message: e.toString(), data: null);
    }).then((resp) {
      toastFuture?.dismiss();
      //debugPrint(resp.toString());
      if (toastMsg) {
        showToast(resp.text);
      }
      return resp;
    });
  }

  ToastFuture showLoadingWidget(String loadingText) {
    return showToastWidget(
        AbsorbPointer(
          absorbing: true,
          child: Stack(
            children: <Widget>[
              ModalBarrier(
                dismissible: false,
                color: Color(0x33333333),
              ),
              Align(
                alignment: Alignment.center,
                child: Material(
                  type: MaterialType.card,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  elevation: 6,
                  color: Colors.deepPurpleAccent,
                  shadowColor: Colors.black,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          loadingText,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        position: ToastPosition.center,
        textDirection: TextDirection.ltr,
        duration: Duration(seconds: 100));
  }
}

class BaseResponse<T> {
  String status;
  T data;
  String token;
  String text;

  BaseResponse(this.status, this.data, this.token, this.text);

  BaseResponse.error({String message = "失败", T data}) {
    this.status = "0";
    this.data = null;
    this.token = null;
    this.text = message;
  }

  BaseResponse.success({String message = "成功"}) {
    this.status = "1";
    this.data = null;
    this.token = null;
    this.text = message;
  }

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{\r\n');
    sb.write("\"status\":\"$status\"");
    sb.write(",\r\n\"token\":$token");
    sb.write(",\r\n\"text\":\"$text\"");
    sb.write(",\r\n\"data\":\"$data\"");
    sb.write('\r\n}');
    return sb.toString();
  }

  bool get success => status == "1";
}

class UserInfoWrapper {
  UserInfo userInfo;

  UserInfoWrapper(this.userInfo);

  @override
  String toString() {
    return "{\"userInfo\":\"$userInfo\"}";
  }

  UserInfoWrapper.fromJson(Map<String, dynamic> json) {
    userInfo =
        UserInfo.fromJson(json["userInfo"] is Map ? json["userInfo"] : {});
  }
}

class UserInfo {
  String userId;
  String userName;
  String mobile;
  int isCertification;
  List<DistrictInfo> district;
  List<Roles> roles;

  UserInfo({
    this.userId,
    this.userName,
    this.mobile,
    this.isCertification,
    this.district,
    this.roles,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    mobile = json['mobile'];
    isCertification = json['isCertification'];
    if (json['district'] != null) {
      district = new List<DistrictInfo>();
      json['district'].forEach((v) {
        district.add(DistrictInfo.fromJson(v));
      });
    }
    if (json['roles'] != null) {
      roles = new List<Roles>();
      json['roles'].forEach((v) {
        roles.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['mobile'] = this.mobile;
    data['isCertification'] = this.isCertification;
    if (this.district != null) {
      data['district'] = this.district.map((v) => v.toJson()).toList();
    }
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Roles {
  ///
  /// 7 普通用户
  /// 8 保安人员
  /// 9 学校管理员
  /// 10民警
  /// 11民警管理员
  String roleCode;
  String roleName;

  Roles({this.roleCode, this.roleName});

  Roles.fromJson(Map<String, dynamic> json) {
    roleCode = json['roleCode'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleCode'] = this.roleCode;
    data['roleName'] = this.roleName;
    return data;
  }
}

class DistrictInfo {
  int districtId;
  String districtName;
  String districtInfo;
  String districtAddr;
  String districtPic;
  String companyId;
  String orderNo;

  DistrictInfo(
      {this.districtId,
      this.districtName,
      this.districtInfo,
      this.districtAddr,
      this.districtPic,
      this.companyId,
      this.orderNo});

  DistrictInfo.fromJson(Map<String, dynamic> json) {
    districtId = json['districtId'];
    districtName = json['districtName'];
    districtInfo = json['districtInfo'];
    districtAddr = json['districtAddr'];
    districtPic = json['districtPic'];
    companyId = json['companyId'];
    orderNo = json['orderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtId'] = this.districtId;
    data['districtName'] = this.districtName;
    data['districtInfo'] = this.districtInfo;
    data['districtAddr'] = this.districtAddr;
    data['districtPic'] = this.districtPic;
    data['companyId'] = this.companyId;
    data['orderNo'] = this.orderNo;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistrictInfo &&
          runtimeType == other.runtimeType &&
          districtId == other.districtId &&
          districtName == other.districtName &&
          districtInfo == other.districtInfo &&
          districtAddr == other.districtAddr &&
          districtPic == other.districtPic &&
          companyId == other.companyId &&
          orderNo == other.orderNo;

  @override
  int get hashCode =>
      districtId.hashCode ^
      districtName.hashCode ^
      districtInfo.hashCode ^
      districtAddr.hashCode ^
      districtPic.hashCode ^
      companyId.hashCode ^
      orderNo.hashCode;
}
