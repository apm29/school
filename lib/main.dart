import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/Configs.dart';
import 'package:school/providers/NotificationProvider.dart';
import 'package:school/repo/AlertMessage.dart';
import 'package:school/repo/Api.dart';
import 'package:school/ui/ManagerPage.dart';
import 'package:school/providers/ApplyListProvider.dart';
import 'package:school/providers/SchoolAlertListProvider.dart';
import 'package:school/providers/UserInfoProvider.dart';
import 'package:school/providers/LoadingProvider.dart';
import 'package:school/ui/picture_page.dart';
import 'package:school/widget/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Utils.dart';
import 'ui/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  userSp = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: LoadingProvider(),
          ),
          ChangeNotifierProvider(
            builder: (context) => UserInfoProvider(),
          ),
          ChangeNotifierProvider(
            builder: (context) => PoliceAlertListProvider(),
          ),
          ChangeNotifierProvider(
            builder: (context) => ApplyListProvider(),
          ),
          ChangeNotifierProvider(
            builder: (context) => NotificationProvider(context),
          )
        ],
        child: MaterialApp(
          title: '智安校园',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blue,
            primaryColorBrightness: Brightness.light,
            platform: TargetPlatform.iOS,
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              color: Colors.white,
              elevation: 8,
              iconTheme: IconThemeData(color: Colors.blue, size: 12),
              textTheme: TextTheme(
                body1: TextStyle(fontSize: 11, color: Colors.grey),
                body2: TextStyle(fontSize: 11),
                subtitle: TextStyle(
                  color: Colors.grey[200],
                ),
              ),
            ),
            iconTheme: IconThemeData(color: Colors.blue),
          ),
//          supportedLocales: [
//            const Locale.fromSubtags(languageCode: 'zh'),
//            // generic Chinese 'zh'
//            const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
//            // generic simplified Chinese 'zh_Hans'
//            const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
//            // generic traditional Chinese 'zh_Hant'
//            const Locale.fromSubtags(
//                languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
//            // 'zh_Hans_CN'
//            const Locale.fromSubtags(
//                languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
//            // 'zh_Hant_TW'
//            const Locale.fromSubtags(
//                languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
//            // 'zh_Hant_HK'
//          ],
//          localizationsDelegates: [
//            // ... app-specific localization delegate[s] here
//            GlobalMaterialLocalizations.delegate,
//            GlobalCupertinoLocalizations.delegate,
//
//            GlobalWidgetsLocalizations.delegate,
//          ],
//          locale: const Locale.fromSubtags(languageCode: 'zh'),
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();
  TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil(width: 1080, height: 2160)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('智安校园'),
        actions: <Widget>[
          Consumer<UserInfoProvider>(
            builder: (context, model, child) {
              return PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 0,
                      child: Text("管理审批"),
                    ),
                  ];
                },
                onSelected: (value) {
                  goAdminPage(model, context);
                },
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<UserInfoProvider>(
              builder: (context, model, child) {
                return UserAccountsDrawerHeader(
                  accountName: model.isLogin
                      ? Text(
                          "账户名：${model.userInfo.userName}",
                          style: TextStyle(color: Colors.white),
                        )
                      : Container(),
                  accountEmail: null,
                  currentAccountPicture: FlutterLogo(),
                );
              },
            ),
            Consumer<UserInfoProvider>(
              builder: (context, model, child) {
                return model.schoolString == null
                    ? Container()
                    : Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.school),
                            SizedBox(
                              width: 8,
                            ),
                            Text("${model.schoolString}")
                          ],
                        ),
                      );
              },
            ),
            Consumer<UserInfoProvider>(
              builder: (context, model, child) {
                return model.roleString == null
                    ? Container()
                    : Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.person),
                            SizedBox(
                              width: 8,
                            ),
                            Text("${model.roleString}")
                          ],
                        ),
                      );
              },
            ),
            Divider(),
            Consumer<UserInfoProvider>(
              builder: (context, model, child) => FlatButton.icon(
                onPressed: () {
                  goAdminPage(model, context);
                },
                icon: Icon(
                  Icons.list,
                  color: Colors.blue,
                ),
                label: Text("审核管理"),
              ),
            ),
            Divider(),
            Expanded(child: Container()),
            Consumer<UserInfoProvider>(
              builder: (context, model, child) {
                if (!model.isLogin) {
                  return FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.blue,
                    ),
                    label: Text("登录"),
                  );
                } else {
                  return FlatButton.icon(
                    onPressed: () {
                      Provider.of<UserInfoProvider>(context).logout();
                    },
                    label: Text("登出"),
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      body: Consumer<UserInfoProvider>(
        builder: (context, userModel, child) {
          return Consumer<PoliceAlertListProvider>(
            builder: (context, alertModel, child) {
              final list = alertModel.message;
              return EasyRefresh(
                controller: _controller,
                header: BezierCircleHeader(),
                footer: classicalFooter,
                child: list.length == 0
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        alignment: Alignment.center,
                        child: Text("暂无消息"),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          var alertMessage = list[index];
                          var tag = "${alertMessage.faceurl}${alertMessage.id}";
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            child: Material(
                              elevation: 3,
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              clipBehavior: Clip.antiAlias,
                              child: DefaultTextStyle(
                                style: Theme.of(context).textTheme.caption,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      child: Row(
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PicturePage(
                                                          "${alertMessage.faceurl}",
                                                          tag: tag),
                                                ),
                                              );
                                            },
                                            child: Material(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              clipBehavior: Clip.antiAlias,
                                              child: Hero(
                                                tag: tag,
                                                child: Image.network(
                                                  "${alertMessage.faceurl}",
                                                  height: ScreenUtil()
                                                      .setWidth(360),
                                                  width: ScreenUtil()
                                                      .setWidth(380),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: 16,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text.rich(TextSpan(
                                                  text:
                                                      "姓名：${alertMessage.faceinfoname}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[800],
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "(分组：${alertMessage.facegroupname})",
                                                      style: TextStyle(
                                                        color: Colors.red[400],
                                                        fontSize: 13,
                                                      ),
                                                    )
                                                  ])),
                                              Text(
                                                "区域：${alertMessage.districtName}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Text(
                                                "年龄：${alertMessage.agegroup}",
                                              ),
                                              Text(
                                                "性别：${alertMessage.faceinfosex}",
                                              ),
                                              Text(
                                                "眼镜：${alertMessage.glassString}",
                                              ),
                                              Container(
                                                color: Colors.grey[400],
                                                height: 0.2,
                                                margin: EdgeInsets.symmetric(vertical: 6),
                                                width: ScreenUtil().setWidth(480),
                                              ),
                                              Text(
                                                "回复人：${alertMessage.nickName ?? "--"}(${alertMessage.userName ?? "--"})",
                                              ),
                                              Text(
                                                "告警回复：${alertMessage.replyContent ?? "--"}",
                                              ),
                                              Text(
                                                "回复时间：${getTimeString(alertMessage.replyTime, onNull: "--")}",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      title: Text(
                                        "告警推送时间：\n${getTimeString("${alertMessage.sendtime}")}",
                                        style:
                                            Theme.of(context).textTheme.subtitle.copyWith(
                                              fontWeight: FontWeight.w300
                                            ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 3),
                                      trailing: GradientButton(
                                        Text(alertMessage.isReplied
                                            ? "已回复"
                                            : "回复"),
                                        gradient: alertMessage.isReplied
                                            ? LinearGradient(colors: [
                                                Colors.grey,
                                                Colors.grey
                                              ])
                                            : null,
                                        onPressed: () async {
                                          if (userModel.isSecurity) {
                                            if (alertMessage.isReplied) {
                                              showToast("已回复");
                                              return;
                                            }
                                            await showReplyDialog(
                                                context, alertMessage);
                                          } else {
                                            showToast("非保安角色不可回复告警信息");
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: list.length,
                      ),
                firstRefreshWidget: Center(
                  child: CircularProgressIndicator(),
                ),
                firstRefresh: true,
                onRefresh: () async {
                  await alertModel.getPoliceAlertList(refresh: true);
                  _controller.finishRefresh(noMore: false);
                  _controller.resetLoadState();
                },
                onLoad: () async {
                  var loadStateData =
                      await alertModel.getPoliceAlertList(refresh: false);
                  _controller.finishLoad(noMore: loadStateData.noMore);
                },
              );
            },
          );
        },
      ),
    );
  }

  void goAdminPage(UserInfoProvider model, BuildContext context) {
    if (model.isLogin && model.isAdmin) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ManagerPage(),
        ),
      );
    } else if (model.isLogin && !model.isAdmin) {
      showToast("您还未拥有管理权限");
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future showReplyDialog(
      BuildContext context, AlertMessage alertMessage) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("回复告警"),
            content: TextField(
              maxLines: 8,
              style: Theme.of(context).textTheme.body1,
              key: ValueKey("desc"),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "填写回复告警内容，少于140字"),
              controller: _replyController,
              maxLength: 140,
              enableInteractiveSelection: true,
              textInputAction: TextInputAction.done,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
              ),
              GradientButton(
                Text("回复"),
                onPressed: () async {
                  var baseResponse = await Api.replyAlert(
                      id: alertMessage.id, content: _replyController.text);
                  showToast(baseResponse.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }).then((_) {
      _replyController.clear();
      _controller.callRefresh();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
