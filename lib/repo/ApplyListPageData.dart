import 'package:school/repo/ApplyDetail.dart';

class ApplyListPageData {

  final int total;
  final List<ApplyDetail> rows;

	ApplyListPageData.fromJsonMap(Map<String, dynamic> map): 
		total = map["total"],
		rows = List<ApplyDetail>.from(map["rows"].map((it) => ApplyDetail.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['total'] = total;
		data['rows'] = rows != null ? 
			this.rows.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
