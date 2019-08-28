import 'package:school/repo/BlackLstDetail.dart';

class BlackListPageData {

  final int total;
  final List<BlackListsDetail> blackLists;

	BlackListPageData.fromJsonMap(Map<String, dynamic> map): 
		total = map["total"],
		blackLists = List<BlackListsDetail>.from(map["blackLists"].map((it) => BlackListsDetail.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['total'] = total;
		data['blackLists'] = blackLists != null ? 
			this.blackLists.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
