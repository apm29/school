import 'package:school/repo/reply.dart';

class AlertMessage {
  final int id;
  final String faceinfoname;
  final String faceinfosex;
  final String facegroupname;
  final String agegroup;
  final String faceurl;
  final int glass;
  final String sendtime;
  final int districtId;
  final String districtName;
  final List<Reply> reply;

  AlertMessage.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        faceinfoname = map["faceinfoname"],
        faceinfosex = map["faceinfosex"],
        facegroupname = map["facegroupname"],
        agegroup = map["agegroup"],
        faceurl = map["faceurl"],
        glass = map["glass"],
        sendtime = map["sendtime"],
        districtId = map["districtId"],
        districtName = map["districtName"],
        reply =
            List<Reply>.from(map["reply"].map((it) => Reply.fromJsonMap(it)));

  get glassString => glass == 1 ? "佩戴眼镜" : "未佩戴";

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
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['reply'] =
        reply != null ? this.reply.map((v) => v.toJson()).toList() : null;
    return data;
  }
}
