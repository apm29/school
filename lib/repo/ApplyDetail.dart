import 'dart:ui';

import 'package:flutter/material.dart';

class ApplyDetail {
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

  ApplyDetail.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
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

  Color get statusColor => status == 0
      ? Colors.amber
      : status == 1 ? Colors.green : Colors.redAccent;

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

  String get typeString => type == 1 ? "学校保安" : type == 2 ? "民警" : "未知身份";

  get statusString => status == 0 ? "未审批" : status == 1 ? "已通过" : "审核被拒";

  @override
  String toString() {
    return 'ApplyDetail{id: $id, userId: $userId, userName: $userName, nickName: $nickName, districtId: $districtId, districtName: $districtName, status: $status, approveUid: $approveUid, result: $result, createTime: $createTime, approveTime: $approveTime, type: $type}';
  }
}
