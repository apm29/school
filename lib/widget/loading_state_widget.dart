import 'package:flutter/material.dart';

class LoadingStateWidget extends StatefulWidget {
  final Key key;
  final Widget child;

  LoadingStateWidget({this.key, this.child}) : super(key: key);

  @override
  LoadingStateWidgetState createState() => LoadingStateWidgetState();
}

class LoadingStateWidgetState extends State<LoadingStateWidget> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            IgnorePointer(
              ignoring: _loading,
              child: Opacity(
                child: widget.child,
                opacity: _loading?0:1,
              ),
            ),
            IntrinsicHeight(
              child: Container(
                alignment: Alignment.center,
                child: Visibility(
                  visible: _loading,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        );
  }

  void startLoading() {
    if(mounted)
    setState(() {
      _loading = true;
    });
  }

  void stopLoading() {
    if(mounted)
    setState(() {
      _loading = false;
    });
  }
}
