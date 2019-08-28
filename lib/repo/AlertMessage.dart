
class AlertMessage {

  final int id;
  final String faceinfoname;
  final String faceinfosex;
  final String facegroupname;
  final String agegroup;
  final String faceurl;
  final int glass;
  final String sendtime;
  final String replyUid;
  final String userName;
  final String nickName;
  final String replyContent;
  final int districtId;
  final String districtName;
  final String replyTime;

	AlertMessage.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		faceinfoname = map["faceinfoname"],
		faceinfosex = map["faceinfosex"],
		facegroupname = map["facegroupname"],
		agegroup = map["agegroup"],
		faceurl = map["faceurl"],
		glass = map["glass"],
		sendtime = map["sendtime"],
		replyUid = map["replyUid"],
		userName = map["userName"],
		nickName = map["nickName"],
		replyContent = map["replyContent"],
		districtId = map["districtId"],
		districtName = map["districtName"],
		replyTime = map["replyTime"];

  String get glassString => glass==0?"未佩戴":"戴眼镜";

  get isReplied => replyUid!=null;

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['faceinfoname'] = faceinfoname;
		data['faceinfosex'] = faceinfosex;
		data['facegroupname'] = facegroupname;
		data['agegroup'] = agegroup;
		data['faceurl'] = faceurl;
		data['glass'] = glass;
		data['sendtime'] = sendtime;
		data['replyUid'] = replyUid;
		data['userName'] = userName;
		data['nickName'] = nickName;
		data['replyContent'] = replyContent;
		data['districtId'] = districtId;
		data['districtName'] = districtName;
		data['replyTime'] = replyTime;
		return data;
	}
}
