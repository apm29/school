import 'package:school/repo/AlertMessage.dart';

class AlertMessageListPageData {
  final int total;
  final List<AlertMessage> rows;

  AlertMessageListPageData.fromJsonMap(Map<String, dynamic> map)
      : total = map["total"],
        rows = List<AlertMessage>.from(
            map["rows"].map((it) => AlertMessage.fromJsonMap(it)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = total;
    data['rows'] = rows != null
        ? this.rows.map((v) => v.toJson()).toList()
        : null;
    return data;
  }
}
