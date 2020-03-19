
class DayStatistics {

  final String date;
  final int replytotal;
  final int total;

	DayStatistics.fromJsonMap(Map<String, dynamic> map): 
		date = map["date"],
		replytotal = map["replytotal"],
		total = map["total"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['date'] = date;
		data['replytotal'] = replytotal;
		data['total'] = total;
		return data;
	}
}
