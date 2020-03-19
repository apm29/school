
import 'package:flutter/material.dart';

class DominationApplyDetail {

  final int id;
  final String userId;
  final String userName;
  final String nickName;
  final int districtId;
  final String districtName;
  final int status;
  final String approveUid;
  final int result;
  final String createTime;
  final String approveTime;
  final int type;

	DominationApplyDetail.fromJsonMap(Map<String, dynamic> map):
		id = map["id"],
		userId = map["userId"],
		userName = map["userName"],
		nickName = map["nickName"],
		districtId = map["districtId"],
		districtName = map["districtName"],
		status = map["status"],
		approveUid = map["approveUid"],
		result = map["result"],
		createTime = map["createTime"],
		approveTime = map["approveTime"],
		type = map["type"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['userId'] = userId;
		data['userName'] = userName;
		data['nickName'] = nickName;
		data['districtId'] = districtId;
		data['districtName'] = districtName;
		data['status'] = status;
		data['approveUid'] = approveUid;
		data['result'] = result;
		data['createTime'] = createTime;
		data['approveTime'] = approveTime;
		data['type'] = type;
		return data;
	}

  String get typeString => type == 1 ? "白名单" : type == 2 ? "红名单" : "未知类型";

  get statusString => status == 0 ? "未审批" : status == 1 ? "已通过" : "审核被拒";

  Color get statusColor => status == 0
      ? Colors.amber
      : status == 1 ? Colors.green : Colors.redAccent;
}
