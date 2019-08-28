///
/// author : ciih
/// date : 2019-08-12 10:40
/// description :
///
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PicturePage extends StatefulWidget {
  final String url;

  final String tag;

  PicturePage(this.url, {this.tag});

  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("照片查看"),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.url),
        backgroundDecoration: BoxDecoration(color: Colors.transparent),
        gaplessPlayback: true,
        heroTag: widget.tag ?? widget.url,
      ),
    );
  }
}
