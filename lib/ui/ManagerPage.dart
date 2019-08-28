import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/providers/ApplyListProvider.dart';
import 'package:school/providers/BlackListProvider.dart';
import 'package:school/repo/Api.dart';
import 'package:school/repo/ApplyDetail.dart';
import 'package:school/widget/gradient_button.dart';

///
/// author : ciih
/// date : 2019-08-28 09:09
/// description :
///
class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("申请列表"),
      ),
      body: Consumer<ApplyListProvider>(
        builder: (context, model, child) {
          final list = model.message;
          return EasyRefresh(
            controller: _controller,
            header: BezierCircleHeader(),
            footer: ClassicalFooter(
              loadedText: "加载完成,下拉加载更多",
              loadFailedText: "加载失败",
              noMoreText: "没有更多了",
              infoText: "更新于 %T",
              loadText: "下拉加载更多",
              loadingText: "加载中",
              loadReadyText: "释放加载",
            ),
            firstRefreshWidget: Center(
              child: CircularProgressIndicator(),
            ),
            firstRefresh: true,
            child: ListView.builder(
              itemBuilder: (context, index) {
                var detail = list[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Material(
                    elevation: 1,
                    color: Colors.white,
                    child: ListTile(
                      isThreeLine: true,
                      title: Text.rich(
                        TextSpan(
                          text: "${detail.nickName}",
                          children: [
                            TextSpan(
                              text: "(${detail.statusString})",
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        color: detail.statusColor,
                                      ),
                            ),
                            TextSpan(
                                text:
                                    "\n(${detail.typeString} - ${detail.districtName})",
                                style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "审批时间:${getTimeString(detail.approveTime, onNull: "")}",
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        color: detail.statusColor,
                                      ),
                            )
                          ],
                        ),
                      ),
                      trailing: Text.rich(
                        TextSpan(
                          text: "申请时间:${getTimeString(detail.createTime)}",
                          children: [],
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      onTap: () {
                        if (detail.status == 0)
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("审核"),
                                  content: Text("$detail"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("取消"),
                                    ),
                                    GradientButton(
                                      Text("通过"),
                                      onPressed: () async {
                                        var baseResponse =
                                            await Api.applyApprove(
                                                id: detail.id, result: 1);
                                        showToast(baseResponse.text);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    GradientButton(
                                      Text("拒绝"),
                                      gradient: LinearGradient(
                                          colors: [Colors.red, Colors.red]),
                                      onPressed: () async {
                                        var baseResponse =
                                            await Api.applyApprove(
                                                id: detail.id, result: 2);
                                        showToast(baseResponse.text);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                      },
                    ),
                  ),
                );
              },
              itemCount: list.length,
            ),
            onRefresh: () async {
              var loadStateData =
                  await Provider.of<ApplyListProvider>(context, listen: false)
                      .getApplyListData(refresh: true);
              _controller.finishRefresh();
              _controller.resetLoadState();
            },
            onLoad: () async {
              var loadStateData =
                  await Provider.of<ApplyListProvider>(context, listen: false)
                      .getApplyListData(refresh: false);
              _controller.finishLoad(noMore: loadStateData.noMore);
            },
          );
        },
      ),
    );
  }

  String getTimeString(String time, {String onNull}) {
    return time == null
        ? "${onNull ?? "无数据"}"
        : "${DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.parse(time))}";
  }
}
