import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/Utils.dart';
import 'package:school/providers/ApplyListProvider.dart';
import 'package:school/providers/BlackListProvider.dart';
import 'package:school/providers/SchoolAlertListProvider.dart';
import 'package:school/repo/Api.dart';
import 'package:school/repo/ApplyDetail.dart';
import 'package:school/repo/BlackLstDetail.dart';
import 'package:school/widget/gradient_button.dart';

///
/// author : ciih
/// date : 2019-08-28 09:09
/// description :
///
class BlackListManagerPage extends StatefulWidget {
  @override
  _BlackListManagerPageState createState() => _BlackListManagerPageState();
}

class _BlackListManagerPageState extends State<BlackListManagerPage> {
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("红白名单申请列表"),
      ),
      body: Consumer<BlackListProvider>(
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
                      BlackListsDetail detail = list[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        child: Material(
                          elevation: 1,
                          color: Colors.white,
                          child: ListTile(
                            isThreeLine: true,
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 48,
                                maxHeight: 48,
                                minHeight: 48,
                                minWidth: 48,
                              ),
                              child: Image.network(
                                detail.photo,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text.rich(
                              TextSpan(
                                text: "${detail.name}",
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
                                          "\n(${detail.typeString} - 审核人: ${detail.approveName ?? "未审核"})",
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
                                        "审批时间:${getTimeString(detail.approveTime, onNull: "未审核")}",
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
//                            trailing: Text.rich(
//                              TextSpan(
//                                text:
//                                    "通过时间:${getTimeString(detail.approveTime, onNull: "未通过")}",
//                                children: [],
//                              ),
//                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            onTap: () {
                              if (detail.status == 0) {
                                showApproveDialog(context, detail);
                              } else {
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
              await Provider.of<BlackListProvider>(context, listen: false)
                  .getApplyListData(refresh: true);
              _controller.finishRefresh(noMore: false);
              _controller.resetLoadState();
            },
            onLoad: () async {
              var loadStateData =
                  await Provider.of<BlackListProvider>(context, listen: false)
                      .getApplyListData(refresh: false);
              _controller.finishLoad(noMore: loadStateData.noMore);
            },
          );
        },
      ),
    );
  }

  Future showApproveDialog(
      BuildContext context, BlackListsDetail detail) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("审核"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.tightFor(
                    width: 128,height: 128
                  ),
                  child: Image.network(
                    detail.photo,
                    fit: BoxFit.cover,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "姓名：${detail.name}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Text(
                  "性别：${detail.sex}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  "类型：${detail.typeString}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  "申请时间：${getTimeString(detail.time)}",
                ),
                Text(
                  "申请理由：${detail.reason}",
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
                      await Api.blackListApplyApprove(id: detail.id, result: 1);
                  showToast(baseResponse.text);
                  Navigator.of(context).pop();
                },
              ),
              GradientButton(
                Text("拒绝"),
                gradient: LinearGradient(colors: [Colors.red, Colors.red]),
                onPressed: () async {
                  var baseResponse =
                      await Api.blackListApplyApprove(id: detail.id, result: 0);
                  showToast(baseResponse.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }).then((_) {
      _controller.callRefresh();
    });
  }
}
