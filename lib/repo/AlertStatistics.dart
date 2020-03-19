import 'DayStatistics.dart';

class AlertStatistics {
  final int districtId;
  final String districtName;
  final List<DayStatistics> rows;

  AlertStatistics.fromJsonMap(Map<String, dynamic> map)
      : districtId = map["districtId"],
        districtName = map["districtName"],
        rows = List<DayStatistics>.from(
            map["rows"].map((it) => DayStatistics.fromJsonMap(it))
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['rows'] =
        rows != null ? this.rows.map((v) => v.toJson()).toList() : null;
    return data;
  }
}
