
class BlackListsDetail {

  final int id;
  final String name;
  final String sex;
  final String photo;
  final String time;
  final int type;
  final String userId;
  final String userName;
  final int status;
  final String approveId;
  final String approveName;
  final int result;
  final String approveTime;

	BlackListsDetail.fromJsonMap(Map<String, dynamic> map):
		id = map["id"],
		name = map["name"],
		sex = map["sex"],
		photo = map["photo"],
		time = map["time"],
		type = map["type"],
		userId = map["userId"],
		userName = map["userName"],
		status = map["status"],
		approveId = map["approveId"],
		approveName = map["approveName"],
		result = map["result"],
		approveTime = map["approveTime"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		data['sex'] = sex;
		data['photo'] = photo;
		data['time'] = time;
		data['type'] = type;
		data['userId'] = userId;
		data['userName'] = userName;
		data['status'] = status;
		data['approveId'] = approveId;
		data['approveName'] = approveName;
		data['result'] = result;
		data['approveTime'] = approveTime;
		return data;
	}
}
