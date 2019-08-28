import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/Utils.dart';
import 'package:school/providers/ApplyListProvider.dart';
import 'package:school/providers/SchoolAlertListProvider.dart';
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
            footer: classicalFooter,
            firstRefreshWidget: Center(
              child: CircularProgressIndicator(),
            ),
            firstRefresh: true,
            child: list.length == 0
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    child: Text("暂无申请"),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      var detail = list[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: detail.statusColor,
                                        ),
                                  ),
                                  TextSpan(
                                      text:
                                          "\n(${detail.typeString} - ${detail.districtName})",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                ],
                              ),
                            ),
                            subtitle: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "审批时间:${getTimeString(detail.approveTime, onNull: "")}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: detail.statusColor,
                                        ),
                                  )
                                ],
                              ),
                            ),
                            trailing: Text.rich(
                              TextSpan(
                                text:
                                    "申请时间:${getTimeString(detail.createTime)}",
                                children: [],
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            onTap: () {
                              if (detail.status == 0) {
                                showApproveDialog(context, detail);
                              }else{
                                showToast("已审核");
                              }
                            },
                          ),
                        ),
                      );
                    },
                    itemCount: list.length,
                  ),
            onRefresh: () async {
              await Provider.of<ApplyListProvider>(context, listen: false)
                  .getApplyListData(refresh: true);
              _controller.finishRefresh(noMore: false);
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

  Future showApproveDialog(BuildContext context, ApplyDetail detail) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("审核"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Text.rich(TextSpan(
                    text:
                    "姓名：${detail.nickName}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                    children: [
                      TextSpan(
                        text:
                        "(账号：${detail.userName})",
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 13,
                        ),
                      )
                    ])),
                Text(
                  "区域：${detail.districtName}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  "申请时间：${getTimeString(detail.createTime)}",
                ),
              ],
            ),
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
                gradient: LinearGradient(colors: [
                  Colors.red,
                  Colors.red
                ]),
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
        }).then((_){
          _controller.callRefresh();
    });
  }

}
