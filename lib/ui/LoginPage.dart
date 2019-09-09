import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/providers/DistrictSelectorProvider.dart';
import 'package:school/providers/RegisterTypeSelectorProvider.dart';
import 'package:school/providers/UserInfoProvider.dart';
import 'package:school/providers/LoadingProvider.dart';
import 'package:school/repo/Api.dart';
import 'package:school/ui/RegisterPage.dart';
import 'package:school/widget/gradient_button.dart';
import 'package:school/widget/loading_state_widget.dart';

import '../Utils.dart';

///
/// author : ciih
/// date : 2019-08-27 14:12
/// description :
///

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final TextEditingController controllerMobile = TextEditingController();

  final TextEditingController controllerPassword = TextEditingController();

  bool _nameReady = false;
  bool _passReady = false;
  bool _fastLogin = false;
  bool _protocolChecked = true;
  bool _showPassword = false;
  FocusNode _focusNodePass = FocusNode();
  FocusNode _focusNodeMobile = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, model, child) {
        return AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: model.loading ? buildLoading(context) : buildLogin(context),
          switchInCurve: Curves.fastOutSlowIn,
          switchOutCurve: Curves.fastOutSlowIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );
      },
    );
  }

  loading() {
    Provider.of<LoadingProvider>(context, listen: false).loading = true;
  }

  idle() {
    Provider.of<LoadingProvider>(context, listen: false).loading = false;
  }

  Scaffold buildLogin(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    bottom: 6,
                    top: MediaQuery.of(context).padding.top + 32,
                    left: 12,
                    right: 12),
                child: Material(
                  elevation: 8,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 12,
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
                              _fastLogin ? "短信登录" : "用户名登录",
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
                      SizedBox(
                        height: 12,
                      ),
                      Hero(
                        tag: 123,
                        child: FlutterLogo(
                          size: 36,
                        ),
                      ),
                      Text(
                        "智慧生活，安心陪伴",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6, left: 12, right: 12),
                        padding: EdgeInsets.all(6),
                        child: TextField(
                          key: ValueKey("name_login"),
                          focusNode: _focusNodeMobile,
                          controller: controllerMobile,
                          onChanged: (text) {
                            _nameReady = text.isNotEmpty;
                          },
                          maxLength: _fastLogin ? 11 : 32,
                          maxLengthEnforced: true,
                          buildCounter: (_,
                              {currentLength, maxLength, isFocused}) {
                            return Container();
                          },
                          keyboardType: _fastLogin
                              ? TextInputType.number
                              : TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: _fastLogin ? "手机号" : "用户名",
                            hintText: "输入${_fastLogin ? "手机号" : "用户名"}",
                            suffixIcon: InkWell(
                              onTap: () {
                                controllerMobile.clear();
                                SystemSound.play(SystemSoundType.click);
                              },
                              child: Icon(Icons.clear),
                            ),
                            contentPadding: EdgeInsets.all(6),
                          ),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (s) {
                            _focusNodePass.requestFocus();
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6, left: 12, right: 12),
                        padding: EdgeInsets.all(6),
                        child: TextField(
                          key: ValueKey("password_login"),
                          focusNode: _focusNodePass,
                          obscureText: !_showPassword,
                          onChanged: (text) {
                            _passReady = text.isNotEmpty;
                          },
                          keyboardType:TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "输入${_fastLogin ? "验证码" : "密码"}",
                            labelText: "${_fastLogin ? "验证码" : "密码"}",
                            border: OutlineInputBorder(),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                                SystemSound.play(SystemSoundType.click);
                              },
                              child: Icon(_showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            contentPadding: EdgeInsets.all(6),
                          ),
                          controller: controllerPassword,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (s) {
                            login(context, _fastLogin, showLoading: true);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Text("短信登录"),
                            Switch(
                                value: _fastLogin,
                                onChanged: (value) {
                                  setState(() {
                                    _fastLogin = value;
                                    controllerMobile.clear();
                                    controllerPassword.clear();
                                  });
                                }),
                            buildSmsButton(context, _fastLogin)
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          buildLoginButton(context, _fastLogin),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(providers: [
                          ChangeNotifierProvider(
                              builder: (context) => DistrictSelectorProvider()),
                          ChangeNotifierProvider(
                              builder: (context) =>
                                  RegisterTypeSelectorProvider()),
                        ], child: RegisterPage()),
                      ),
                    );
                  },
                  child: Text(
                    "注册",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                    value: _protocolChecked,
                    onChanged: (value) {
                      setState(() {
                        _protocolChecked = value;
                      });
                    },
                    activeColor: Colors.blueAccent,
                  ),
                  Expanded(
                    child: InkWell(
                      child: IntrinsicWidth(
                        child: Text(
                          "我已阅读并同意服务用户协议",
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _protocolChecked = !_protocolChecked;
                        });
                        SystemSound.play(SystemSoundType.click);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context, bool _fastLogin) {
    return Expanded(
      child: GradientButton(
        Text(
          "登录",
          style: TextStyle(fontSize: 18),
        ),
        unconstrained: false,
        borderRadius: 0,
        gradient: LinearGradient(
          colors: [Colors.blue[500], Colors.blueAccent[700]],
        ),
        onPressed: () async {
          await login(context, _fastLogin);
        },
      ),
    );
  }

  final GlobalKey<LoadingStateWidgetState> smsLoadingKey = GlobalKey();

  Widget buildSmsButton(BuildContext context, bool fastLogin) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: fastLogin
          ? FlatButton(
              onPressed: () {
                sendSms(context, fastLogin);
              },
              child: Text(
                "发送短信",
                style: TextStyle(color: Colors.blue),
              ),
            )
          : Container(),
    );
  }

  void sendSms(BuildContext context, bool fastLogin) async {
    if (!_nameReady) {
      showToast("请填写${fastLogin ? "手机号" : "用户名"}");
      return;
    }
    loading();
    var baseResp = await Api.sendSms(controllerMobile.text, 1);
    idle();
    showToast(baseResp.text);
  }

  Future login(BuildContext context, bool fastLogin,
      {bool showLoading = false}) async {
    if (!_protocolChecked) {
      showToast("请勾选协议");
      return;
    }
    if (!_nameReady) {
      showToast("请填写${_fastLogin ? "电话" : "用户名"}");
      return;
    }
    if (!_passReady) {
      showToast("请输入${_fastLogin ? "验证码" : "密码"}");
      return;
    }
    loading();
    var baseResp = fastLogin
        ? await Api.fastLogin(controllerMobile.text, controllerPassword.text)
        : await Api.login(controllerMobile.text, controllerPassword.text);
    idle();
    if (baseResp.success) {
      Provider.of<UserInfoProvider>(context, listen: false)
          .getUserInfoAndLogin(baseResp.token);
      Navigator.of(context).pop(baseResp.token);
    } else {
      showToast(baseResp.text);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
