
class ApplyDetail {

  final int id;
  final String userId;
  final int districtId;
  final int status;
  final String approveUid;
  final String result;
  final String createTime;
  final String approveTime;
  final int type;

	ApplyDetail.fromJsonMap(Map<String, dynamic> map):
		id = map["id"],
		userId = map["userId"],
		districtId = map["districtId"],
		status = map["status"],
		approveUid = map["approveUid"],
		result = map["result"],
		createTime = map["createTime"],
		approveTime = map["approveTime"],
		type = map["type"];

  get typeString => type == 1?"学校保安":type==2?"民警":"未知身份";

  get statusString => status == 0?"未审批":status==1?"已通过":"审核被拒";

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['userId'] = userId;
		data['districtId'] = districtId;
		data['status'] = status;
		data['approveUid'] = approveUid;
		data['result'] = result;
		data['createTime'] = createTime;
		data['approveTime'] = approveTime;
		data['type'] = type;
		return data;
	}

	@override
	String toString() {
		return 'ApplyDetail{id: $id, userId: $userId, districtId: $districtId, status: $status, approveUid: $approveUid, result: $result, createTime: $createTime, approveTime: $approveTime, type: $type}';
	}


}
