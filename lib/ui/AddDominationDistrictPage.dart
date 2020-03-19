import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/Utils.dart';
import 'package:school/providers/MultiDistrictSelectorProvider.dart';
import 'package:school/providers/UserInfoProvider.dart';
import 'package:school/repo/Api.dart';
import 'package:school/repo/ApplyDetail.dart';

///
/// author : ciih
/// date : 2019-09-12 09:57
/// description :
///
class AddDominationDistrictPage extends StatefulWidget {
  @override
  _AddDominationDistrictPageState createState() =>
      _AddDominationDistrictPageState();
}

class _AddDominationDistrictPageState extends State<AddDominationDistrictPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("管辖区域申请"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          submitApply(context);
        },
        label: Text("提交"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "相关说明:",
                style: Theme.of(context).textTheme.subhead,
              ),
              Text(
                "   民警可以通过此页面添加管辖的学校(多个),通过民警管理员审核后可以收到管辖学校的告警信息",
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                "   学校保安可以通过此页面添加管辖的学校(单个),通过学校管理员审核后可以收到该学校的告警信息",
                style: Theme.of(context).textTheme.caption,
              ),
              Divider(),
              Text(
                "已选学校:",
                style: Theme.of(context).textTheme.subhead,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      padding: EdgeInsets.all(6),
                      constraints: BoxConstraints(minHeight: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        color: Colors.lightBlueAccent[100].withAlpha(0x33),
                      ),
                      child: Consumer<MultiDistrictSelectorProvider>(
                        builder: (context, districtModel, child) {
                          return Wrap(
                              children: districtModel.currentSelect
                                  .toList()
                                  .map((district) {
                            return ChoiceChip(
                              label: Text(district.districtName),
                              selected: district.selected,
                              avatar: Icon(Icons.done),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.black),
                            );
                          }).toList());
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDistrictSelect(context).then((district) {
                        var infoProvider = Provider.of<UserInfoProvider>(
                            context,
                            listen: false);
                        var districtSelectorProvider =
                            Provider.of<MultiDistrictSelectorProvider>(context,
                                listen: false);
                        if (infoProvider.isSecurity) {
                          districtSelectorProvider.single(district);
                        } else if (infoProvider.isPoliceRole &&
                            !infoProvider.isAdmin) {
                          districtSelectorProvider.add(district);
                        }
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitApply(BuildContext context) async {

    var infoProvider = Provider.of<UserInfoProvider>(context, listen: false);

//    //判断是否在审核中 或者已经 有学校
//    BaseResponse<ApplyDetail> resp = await Api.getUserApplyState();
//    if (!resp.success) {
//      showToast(resp.text);
//      return;
//    }
//    if (infoProvider.isSecurity && resp.success && resp.data.status == 0) {
//      showToast("已经在审核中,不能提交新的申请");
//      return;
//    }


    var districtSelectorProvider =
        Provider.of<MultiDistrictSelectorProvider>(context, listen: false);
//    if (infoProvider.isSecurity && infoProvider.userInfo.district.isNotEmpty) {
//      showToast("已在一个学校中,不能提交新的申请");
//      return;
//    }

    if (districtSelectorProvider.currentSelect.isEmpty) {
      showToast("请选择至少一个学校");
      return;
    }
    var ids = districtSelectorProvider.currentSelect
        .map((d) => d.districtId)
        .join(",");
    var type = infoProvider.isSecurity ? 1 : 2;
    var response = await Api.dominationDistrictApply(ids, type);
    showToast(response.text);
    if (response.success) {
      Navigator.of(context).pop();
    }
  }
}
