import 'package:school/repo/AlertStatistics.dart';

class AlertStatisticsListPageData {

  final int total;
  final List<AlertStatistics> rows;

	AlertStatisticsListPageData.fromJsonMap(Map<String, dynamic> map):
		total = map["total"],
		rows = List<AlertStatistics>.from(
				map["rows"].map((it) => AlertStatistics.fromJsonMap(it))
		);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['total'] = total;
		data['rows'] = rows != null ? 
			this.rows.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
