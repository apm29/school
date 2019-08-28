import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/providers/DistrictSelectorProvider.dart';
import 'package:school/providers/RegisterTypeSelectorProvider.dart';
import 'package:school/repo/Api.dart';
import 'package:school/widget/gradient_button.dart';
import 'package:school/widget/loading_state_widget.dart';
import 'package:school/widget/ticker_widget.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = "/register";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<TickerWidgetState> ticker = GlobalKey();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  GlobalKey<LoadingStateWidgetState> register = GlobalKey();
  static const double kInputHeight = 158;
  static const double kMarginHorizontal = 18;
  static const double kInputContentPadding = 8;
  var districtInfo = Api.getAllDistrictInfo();

  @override
  Widget build(BuildContext context) {
    TextStyle kInputLabelTheme = Theme.of(context)
        .textTheme
        .caption
        .copyWith(fontSize: 15, color: Colors.blueGrey[800]);

    TextStyle kInputHintTheme =
        Theme.of(context).textTheme.caption.copyWith(fontSize: 15);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(100),
                  vertical: MediaQuery.of(context).padding.top + 32),
              elevation: 12,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.transparent,
                        ),
                        onPressed: null,
                      ),
                      Expanded(
                        child: Text(
                          "新用户注册",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: ScreenUtil().setHeight(kInputHeight) + 32),
                    margin: EdgeInsets.only(
                        left: kMarginHorizontal,
                        top: 32,
                        right: kMarginHorizontal),
                    child: TextField(
                      key: ValueKey("USER_MOBILE"),
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
                      maxLengthEnforced: true,
                      maxLength: 11,
                      decoration: InputDecoration(
                        hintText: "输入手机号",
                        labelText: "手机号",
                        contentPadding: EdgeInsets.all(kInputContentPadding),
                        labelStyle: kInputLabelTheme,
                        hintStyle: kInputHintTheme,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Divider(
                    indent: 16,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: ScreenUtil().setHeight(kInputHeight)),
                    margin: EdgeInsets.only(
                        left: kMarginHorizontal,
                        top: 12,
                        right: kMarginHorizontal),
                    child: TextField(
                      key: ValueKey("USER_NAME"),
                      controller: _userNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "输入用户名",
                        labelText: "用户名",
                        contentPadding: EdgeInsets.all(kInputContentPadding),
                        labelStyle: kInputLabelTheme,
                        hintStyle: kInputHintTheme,
                        border: OutlineInputBorder(),
                        isDense: true,
                        suffixIcon: InkWell(
                          onTap: () {
                            _userNameController.clear();
                            SystemSound.play(SystemSoundType.click);
                          },
                          child: Icon(
                            Icons.close,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: ScreenUtil().setHeight(kInputHeight)),
                    margin: EdgeInsets.only(
                        left: kMarginHorizontal,
                        top: 12,
                        right: kMarginHorizontal),
                    child: TextField(
                      key: ValueKey("pass"),
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "输入密码",
                        labelText: "输入密码",
                        contentPadding: EdgeInsets.all(kInputContentPadding),
                        labelStyle: kInputLabelTheme,
                        hintStyle: kInputHintTheme,
                        border: OutlineInputBorder(),
                        suffixIcon: InkWell(
                          onTap: () {
                            _passwordController.clear();
                            SystemSound.play(SystemSoundType.click);
                          },
                          child: Icon(
                            Icons.close,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: ScreenUtil().setHeight(kInputHeight)),
                    margin: EdgeInsets.only(
                        left: kMarginHorizontal,
                        top: 12,
                        right: kMarginHorizontal),
                    child: TextField(
                      key: ValueKey("PASS_CONFIRM"),
                      obscureText: true,
                      controller: _confirmController,
                      decoration: InputDecoration(
                        hintText: "重复密码",
                        labelText: "重复密码",
                        contentPadding: EdgeInsets.all(kInputContentPadding),
                        labelStyle: kInputLabelTheme,
                        hintStyle: kInputHintTheme,
                        border: OutlineInputBorder(),
                        suffixIcon: InkWell(
                          onTap: () {
                            _confirmController.clear();
                            SystemSound.play(SystemSoundType.click);
                          },
                          child: Icon(
                            Icons.close,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: ScreenUtil().setHeight(kInputHeight)),
                    margin: EdgeInsets.only(
                      left: kMarginHorizontal,
                      top: 12,
                      right: kMarginHorizontal,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    child: FutureBuilder<BaseResponse<List<DistrictInfo>>>(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Consumer<DistrictSelectorProvider>(
                            builder: (context, model, child) {
                              return DropdownButton<DistrictInfo>(
                                items: snapshot.data.data
                                    .map(
                                      (info) => DropdownMenuItem(
                                        value: info,
                                        child:
                                            Text("注册学校-${info.districtName}"),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  model.currentSelect = value;
                                },
                                value: model.currentSelect,
                                isDense: true,
                                isExpanded: true,
                                hint: Text("选择注册学校"),
                                underline: Container(),
                              );
                            },
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                      future: districtInfo,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: ScreenUtil().setHeight(kInputHeight)),
                    margin: EdgeInsets.only(
                      left: kMarginHorizontal,
                      top: 12,
                      right: kMarginHorizontal,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    child: Consumer<RegisterTypeSelectorProvider>(
                      builder: (context, model, child) {
                        return DropdownButton<TypeData>(
                          items: RegisterTypeSelectorProvider.typeMap
                              .map(
                                (entry) => DropdownMenuItem(
                                  child: Text("注册身份-${entry.info}"),
                                  value: entry,
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            model.currentSelect = value;
                          },
                          value: model.currentSelect,
                          isDense: true,
                          isExpanded: true,
                          hint: Text("选择注册身份"),
                          underline: Container(),
                        );
                      },
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: ScreenUtil().setHeight(kInputHeight)),
                    margin: EdgeInsets.only(
                        left: kMarginHorizontal,
                        top: 12,
                        right: kMarginHorizontal,
                        bottom: 32),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            key: ValueKey("sms"),
                            controller: _smsCodeController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: "输入验证码",
                              labelText: "验证码",
                              contentPadding:
                                  EdgeInsets.all(kInputContentPadding),
                              labelStyle: kInputLabelTheme,
                              hintStyle: kInputHintTheme,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              minWidth: ScreenUtil().setWidth(300)),
                          child: TickerWidget(
                              key: ticker,
                              textInitial: "发送验证码",
                              onPressed: () {
                                sendSms();
                              }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GradientButton(
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kInputContentPadding),
                            child: Text(
                              "注册",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          unconstrained: false,
                          borderRadius: 0,
                          onPressed: () async {
                            await doRegister(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              "注册即视为同意用户协议",
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }

  void sendSms() async {
    if (_mobileController.text.isEmpty) {
      showToast("请填写电话");
      return;
    }
    ticker.currentState?.startLoading();
    BaseResponse baseResp = await Api.sendSms(_mobileController.text, 0);
    showToast(baseResp.text);
    ticker.currentState?.stopLoading();
    if (baseResp.success) {
      //发送短信成功
      ticker.currentState.startTick();
    }
  }

  Future doRegister(BuildContext context) async {
    if (_mobileController.text.isEmpty) {
      showToast("请填写电话");
      return;
    }
    if (_smsCodeController.text.isEmpty) {
      showToast("请填写验证码");
      return;
    }

    if (_userNameController.text.isEmpty) {
      showToast("请填写用户名");
      return;
    }

    if (_passwordController.text.isEmpty) {
      showToast("请填写密码");
      return;
    }
    if (_confirmController.text.isEmpty) {
      showToast("请确认密码");
      return;
    }

    if (_confirmController.text != _passwordController.text) {
      showToast("两次密码不一致");
      return;
    }

    var districtInfo =
        Provider.of<DistrictSelectorProvider>(context, listen: false)
            .currentSelect;
    if (districtInfo == null) {
      showToast("请选择注册学校");
      return;
    }

    var typeData =
        Provider.of<RegisterTypeSelectorProvider>(context, listen: false)
            .currentSelect;
    if (typeData == null) {
      showToast("请选择注册身份");
      return;
    }

    register.currentState?.startLoading();
    BaseResponse baseResp = await Api.register(
      userName: _userNameController.text,
      password: _passwordController.text,
      code: _smsCodeController.text,
      mobile: _mobileController.text,
      districtId: districtInfo.districtId,
      type: typeData.type,
    );
    showToast(baseResp.text);
    register.currentState?.stopLoading();
    if (baseResp.success) {
      //注册成功
      Navigator.of(context).pop();
    }
  }
}
