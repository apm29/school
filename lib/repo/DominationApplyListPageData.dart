import 'package:school/repo/DominationApplyDetail.dart';

class DominationApplyListPageData {

  final int total;
  final List<DominationApplyDetail> rows;

	DominationApplyListPageData.fromJsonMap(Map<String, dynamic> map): 
		total = map["total"],
		rows = List<DominationApplyDetail>.from(map["rows"].map((it) => DominationApplyDetail.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['total'] = total;
		data['rows'] = rows != null ? 
			this.rows.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
