import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:school/providers/AlarmStatisticsListProvider.dart';
import 'package:school/repo/AlertStatistics.dart';

import '../Utils.dart';

///
/// author : ciih
/// date : 2019-10-14 17:33
/// description :
///
class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  EasyRefreshController _controller = EasyRefreshController();
  DateTime pickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("告警统计"),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: pickedDate,
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now(),
              ).then((date) {
                print('$date');
                if (date != null) {
                  pickedDate = date;
                  Provider.of<AlarmStatisticsListProvider>(context).getListData(
                      getTimeString(pickedDate.toString()),
                      refresh: true);
                }
              });
            },
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            label: Text(
              "选择日期",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Consumer<AlarmStatisticsListProvider>(
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
                    child: Text("当前日期暂无数据"),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      AlertStatistics detail = list[index];
                      return buildItem(detail);
                    },
                    itemCount: list.length,
                  ),
            onRefresh: () async {
              await Provider.of<AlarmStatisticsListProvider>(context,
                      listen: false)
                  .getListData(getTimeString(pickedDate.toString()),
                      refresh: true);
              _controller.finishRefresh(noMore: false);
              _controller.resetLoadState();
            },
            onLoad: () async {
              var loadStateData =
                  await Provider.of<AlarmStatisticsListProvider>(context,
                          listen: false)
                      .getListData(getTimeString(pickedDate.toString()),
                          refresh: false);
              _controller.finishLoad(noMore: loadStateData.noMore);
            },
          );
        },
      ),
    );
  }

  Widget buildItem(AlertStatistics detail) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                detail.districtName,
                style: Theme.of(context).textTheme.title,
              ),
              Text(detail.toJson().toString()),
            ],
          ),
        ),
        type: MaterialType.card,
        elevation: 3,
      ),
    );
  }
}
