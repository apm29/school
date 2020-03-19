import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:school/Utils.dart';
import 'package:school/providers/GenderSelectorProvider.dart';
import 'package:school/providers/RuleAddProvider.dart';
import 'package:school/providers/TypeSelectProvider.dart';
import 'package:school/repo/Api.dart';
import 'package:school/widget/gradient_button.dart';

///
/// author : ciih
/// date : 2019-09-11 15:10
/// description :
///
class RuleAddPage extends StatefulWidget {
  @override
  _RuleAddPageState createState() => _RuleAddPageState();
}

class _RuleAddPageState extends State<RuleAddPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加告警人员"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _submit(context);
        },
        label: Text("提交"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("人员照片:"),
              ImagePickerWidget(),
              Divider(),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "姓名",
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .caption,
                ),
              ),
              Divider(),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Consumer<GenderSelectProvider>(
                  builder: (context, genderModel, child) {
                    return DropdownButton<String>(
                      isExpanded: true,
                      underline: Container(),
                      items: [
                        DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("男"),
                          ),
                          value: "男",
                        ),
                        DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("女"),
                          ),
                          value: "女",
                        ),
                      ],
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "选择性别",
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption,
                        ),
                      ),
                      value: genderModel.gender,
                      onChanged: (value) {
                        genderModel.gender = value;
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Consumer<TypeSelectProvider>(
                  builder: (context, typeModel, child) {
                    return DropdownButton<int>(
                      isExpanded: true,
                      underline: Container(),
                      items: [
                        DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("白名单"),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("红名单"),
                          ),
                          value: 2,
                        ),
                      ],
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "选择类型",
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption,
                        ),
                      ),
                      value: typeModel.type,
                      onChanged: (value) {
                        typeModel.type = value;
                      },
                    );
                  },
                ),
              ),
              Divider(),
              TextField(
                controller: _descController,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "添加理由",
                  isDense: true,
                  alignLabelWithHint: true,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .caption,
                ),
                maxLength: 140,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    var ruleAddProvider = Provider.of<RuleAddProvider>(context, listen: false);
    var genderProvider = Provider.of<GenderSelectProvider>(
        context, listen: false);
    var typeProvider = Provider.of<TypeSelectProvider>(context, listen: false);
    if (ruleAddProvider.image == null) {
      showToast("请选择一张人脸照片");
      return;
    }
    if (genderProvider.gender == null) {
      showToast("请选择性别");
      return;
    }
    if (typeProvider.type == null) {
      showToast("请选择类型");
      return;
    }

    if (_nameController.text.isEmpty) {
      showToast("请填写姓名");
      return;
    }
    if (_descController.text.isEmpty) {
      showToast("请填写申请描述");
      return;
    }

    print('submit');

    var uploadResp = await Api.uploadPic(ruleAddProvider.image.path);
    if (uploadResp.success) {
      var blackListResp = await Api.addBlackList(uploadResp.data.orginPicPath, _nameController.text,
          genderProvider.gender, _descController.text, typeProvider.type);
      showToast(blackListResp.text);
      if(blackListResp.success){
        Navigator.of(context).pop();
      }
    } else {
      showToast("图片上传失败");
    }
  }
}

class ImagePickerWidget extends StatefulWidget {
  final BoxConstraints constraint;

  const ImagePickerWidget({Key key, this.constraint}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RuleAddProvider>(
      builder: (context, ruleModel, child) {
        final image = ruleModel.image;
        return Container(
          constraints: widget.constraint ??
              BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 3,
                maxHeight: MediaQuery
                    .of(context)
                    .size
                    .width / 3,
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 3,
                minHeight: MediaQuery
                    .of(context)
                    .size
                    .width / 3,
              ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: image != null
                ? null
                : Border.all(
              color: Colors.green,
            ),
          ),
          child: InkWell(
            child: image == null
                ? Container(
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 36,
                  ),
                  Text("点击加号添加图片")
                ],
              ),
            )
                : Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    elevation: 5,
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.done,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            onTap: () {
              showImageSourceDialog(context).then((file) {
                if (file == null) {
                  return null;
                }
                return rotateWithExifAndCompress(file);
              }).then((file) {
                if (file != null) {
                  ruleModel.image = file;
                }
              });
            },
          ),
        );
      },
    );
  }
}
