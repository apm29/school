
import 'package:school/Utils.dart';

class Reply {

  final int id;
  final int alarmId;
  final String replyUid;
  final String userName;
  final String nickName;
  final String replyContent;
  final String replyTime;
  final Object memo;

	Reply.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		alarmId = map["alarmId"],
		replyUid = map["replyUid"],
		userName = map["userName"],
		nickName = map["nickName"],
		replyContent = map["replyContent"],
		replyTime = map["replyTime"],
		memo = map["memo"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['alarmId'] = alarmId;
		data['replyUid'] = replyUid;
		data['userName'] = userName;
		data['nickName'] = nickName;
		data['replyContent'] = replyContent;
		data['replyTime'] = replyTime;
		data['memo'] = memo;
		return data;
	}

	@override
  String toString() {
    return '$userName($nickName) ${getTimeString(replyTime,onNull: "--")}  :$replyContent ';
  }
}
