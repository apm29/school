import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:school/repo/Api.dart';

///
/// author : ciih
/// date : 2019-08-27 14:04
/// description :
///
Widget buildLoading(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 123,
            child: FlutterLogo(
              size: 84,
            ),
          ),
          SizedBox(
            height: 22,
          ),
          CircularProgressIndicator()
        ],
      ),
    ),
  );
}

final classicalFooter = ClassicalFooter(
  loadedText: "加载完成,下拉加载更多",
  loadFailedText: "加载失败",
  noMoreText: "没有更多了",
  infoText: "更新于 %T",
  loadText: "下拉加载更多",
  loadingText: "加载中",
  loadReadyText: "释放加载",
);

String getTimeString(String time, {String onNull}) {
  return time == null
      ? "${onNull ?? "无数据"}"
      : "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(time).toLocal())}";
}

Future _requestPermission(PermissionGroup group) async {
  var status = await PermissionHandler().checkPermissionStatus(group);
  if (status == PermissionStatus.granted) {
    return null;
  }
  return PermissionHandler().requestPermissions([group]);
}

Future requestPermission() async {
  await _requestPermission(PermissionGroup.storage);
  await _requestPermission(PermissionGroup.camera);
  return null;
}

Future<File> showImageSourceDialog(BuildContext context,
    {VoidCallback onValue}) async {
  FocusScope.of(context).requestFocus(FocusNode());
  await requestPermission();
  return showModalBottomSheet<File>(
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return LayoutBuilder(
                builder: (context, constraint) {
                  return IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showPicker().then((f) {
                              Navigator.of(context).pop(f);
                            });
                            SystemSound.play(SystemSoundType.click);
                          },
                          child: Container(
                            width: constraint.biggest.width,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(18.0),
                            child: Text("相册"),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              showCameraPicker().then((f) {
                                Navigator.of(context).pop(f);
                              });
                              SystemSound.play(SystemSoundType.click);
                            },
                            child: Container(
                              width: constraint.biggest.width,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(18.0),
                              child: Text("拍照"),
                            )),
                      ],
                    ),
                  );
                },
              );
            });
      }).then((v) {
    if (onValue != null) onValue.call();
    return v;
  });
}

Future<File> showPicker() {
  return ImagePicker.pickImage(source: ImageSource.gallery);
}

Future<File> showCameraPicker() {
  return ImagePicker.pickImage(source: ImageSource.camera);
}

///只能作用于带exif的image
///旋转Android图片并压缩
Future<File> rotateWithExifAndCompress(File file) async {
  if (!Platform.isWindows) {
    if (file == null) {
      return null;
    }
    return FlutterImageCompress.compressAndGetFile(file.path, file.path,
        quality: 70);
//    return FlutterImageCompress.compressWithFile(file.path,quality: 30,minHeight: 768,minWidth: 1080).then((listInt) {
//      if (listInt == null) {
//        return null;
//      }
//      file.writeAsBytesSync(listInt, flush: true, mode: FileMode.write);
//      return file;
//    });
  }
  return Future.value(file).then((file) {
    if (file == null) {
      return null;
    }
    //通过exif旋转图片
    //return FlutterExifRotation.rotateImage(path: file.path);
    return file;
  }).then((f) {
    if (f == null) {
      return null;
    }
    //压缩图片
    return FlutterImageCompress.compressWithFile(
      f.path,
      quality: 80,
    );
  }).then((listInt) {
    if (listInt == null) {
      return null;
    }
    file.writeAsBytesSync(listInt, flush: true, mode: FileMode.write);
    return file;
  });
}

Future<DistrictInfo> showDistrictSelect(BuildContext context) async {
  var future = Api.getAllDistrictInfo();
  return showModalBottomSheet<DistrictInfo>(
    context: context,
    builder: (context) => BottomSheet(
      onClosing: () {},
      builder: (context) {
        return FutureBuilder<BaseResponse<List<DistrictInfo>>>(
          builder: (context, snapshot) {
            if (snapshot?.data?.success == true) {
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => FlatButton(
                  child: Text("${snapshot.data.data[index].districtName}"),
                  onPressed: () {
                    Navigator.of(context)
                        .pop<DistrictInfo>(snapshot.data.data[index]);
                  },
                ),
                itemCount: snapshot.data.data.length,
              );
            } else if (snapshot?.data?.success == false) {
              return Container(
                height: 180,
                child: Center(child: Text(
                  "${snapshot?.data?.text}"
                )),
              );
            } else {
              return Container(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
          future: future,
        );
      },
    ),
  );
}
