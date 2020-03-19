import 'dart:async';
import 'package:fake_push/fake_push.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/repo/Api.dart';

import '../Configs.dart';

class NotificationProvider extends ChangeNotifier {
  StreamSubscription<String> _receiveDeviceToken;
  StreamSubscription<Message> _receiveMessage;
  StreamSubscription<Message> _receiveNotification;
  StreamSubscription<String> _launchNotification;
  StreamSubscription<String> _resumeNotification;

  int _unreadNotificationCount = 1;

  set unreadNotificationCount(int count) {
    if (_unreadNotificationCount == count) {
      return;
    }
    _unreadNotificationCount = count;
    notifyListeners();
  }

  int get unreadNotificationCount => _unreadNotificationCount;

  String get unreadNotificationCountText {
    return _unreadNotificationCount == 0
        ? ""
        : _unreadNotificationCount.toString();
  }

  NotificationProvider(BuildContext context) {
    checkNotification(context);

    startListen(context);
  }

  var toastFuture;

  void checkNotification(BuildContext context) async {
    bool notificationEnabled = await _push.areNotificationsEnabled();
    if (!notificationEnabled) {
      toastFuture = showToastWidget(
          Container(
            margin: EdgeInsets.symmetric(vertical: 32, horizontal: 40),
            child: Material(
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '提示',
                      style: Theme.of(context).textTheme.title.copyWith(color: Colors.blue),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(),
                    Text(
                      '请到系统设置页面开启通知权限,否则无法收到告警消息!',
                      style: Theme.of(context).textTheme.body1,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: const Text('取消'),
                          onPressed: () {
                            toastFuture?.dismiss();
                          },
                        ),
                        FlatButton(
                          child: const Text('设置',style: TextStyle(color: Colors.blue),),
                          onPressed: () {
                            toastFuture?.dismiss();
                            _push.openNotificationsSettings();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          duration: Duration(hours: 1),
          dismissOtherToast: true,
          handleTouch: true);
    }
  }

  static NotificationProvider of(BuildContext context) {
    return Provider.of<NotificationProvider>(context, listen: false);
  }

  Push _push = Push();

  void startListen(BuildContext context) async {
    print(">>>>>>>>>>>>>>>>>>>>start receive notification");

    _receiveDeviceToken = _push.receiveDeviceToken().listen((String data) {
      print('>>>>>>>>>>>>>>>>>>>>deviceToken:$data');
      userSp.setString(KEY_XG_PUSH_DEVICE_TOKEN, data);
      Api.getUserInfo();
    });
    _receiveMessage = _push.receiveMessage().listen((Message msg) {
      print('>>>>>>>>>>>>>>>>>>>>Message:$msg');
//      AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
//      AudioPlayer.logEnabled = true;
//      audioPlayer.setReleaseMode(ReleaseMode.STOP);
//      audioPlayer.play("audio.mp3", isLocal: true);
//      FlutterRingtonePlayer.playRingtone(volume: 1,looping: false);
    });
    _receiveNotification = _push.receiveNotification().listen((Message msg) {
      print('>>>>>>>>>>>>>>>>>>>>Notification:$msg');
    });
    _launchNotification = _push.launchNotification().listen((String msg) {
      print('>>>>>>>>>>>>>>>>>>>>launchNotification:$msg');
    });
    _resumeNotification = _push.resumeNotification().listen((String msg) {
      print('>>>>>>>>>>>>>>>>>>>>resumeNotification:$msg');
    });
    _push.startWork();
  }

  @override
  void dispose() {
    _receiveDeviceToken?.cancel();
    _receiveMessage?.cancel();
    _receiveNotification?.cancel();
    _launchNotification?.cancel();
    _resumeNotification?.cancel();
    super.dispose();
  }
}
