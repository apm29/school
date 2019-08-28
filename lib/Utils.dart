import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intl/intl.dart';

///
/// author : ciih
/// date : 2019-08-27 14:04
/// description :
///
Widget buildLoading(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 123,
            child: FlutterLogo(
              size: 84,
            ),
          ),
          SizedBox(
            height: 22,
          ),
          CircularProgressIndicator()
        ],
      ),
    ),
  );
}

final classicalFooter = ClassicalFooter(
  loadedText: "加载完成,下拉加载更多",
  loadFailedText: "加载失败",
  noMoreText: "没有更多了",
  infoText: "更新于 %T",
  loadText: "下拉加载更多",
  loadingText: "加载中",
  loadReadyText: "释放加载",
);

String getTimeString(String time, {String onNull}) {
  return time == null
      ? "${onNull ?? "无数据"}"
      : "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(time).toLocal())}";
}