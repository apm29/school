import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef PressCallback = Future<void> Function();

class GradientButton extends StatefulWidget {
  final Widget child;
  final Gradient gradient;
  final PressCallback onPressed;
  final bool unconstrained;

  final double borderRadius;

  final EdgeInsetsGeometry padding;

  GradientButton(
    this.child, {
    this.gradient,
    @required this.onPressed,
    this.unconstrained = true,
    this.borderRadius = 3,
    this.padding,
  }) : assert(onPressed != null);

  @override
  GradientButtonState createState() => GradientButtonState();
}

class GradientButtonState extends State<GradientButton> {
  bool _loading = false;
  final int _kDelayMilli = 600;
  Timer delayCancelTimer;

  @override
  void dispose() {
    super.dispose();
    delayCancelTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Gradient _kDefaultGradient = LinearGradient(
      colors: [
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.primary,
      ],
    );
    var child = Container(
        decoration: BoxDecoration(
            gradient: widget.gradient ?? _kDefaultGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500],
                offset: Offset(0.0, 1.5),
                blurRadius: 1.5,
              ),
            ],
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius))),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: _loading
                  ? null
                  : () async {
                      if (_loading) {
                        return null;
                      }
                      startLoading();
                      SystemSound.play(SystemSoundType.click);
                      return widget.onPressed.call().then((_) {
                        delayCancelTimer =
                            Timer(Duration(milliseconds: _kDelayMilli), () {
                          stopLoading();
                        });
                      }).catchError((e) {
                        stopLoading();
                      });
                    },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  IgnorePointer(
                    ignoring: _loading,
                    child: Opacity(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        child: Container(
                          child: widget.child,
                          constraints:
                              BoxConstraints(minHeight: 32.0, minWidth: 72.0),
                          padding: widget.padding ??
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                      ),
                      opacity: _loading ? 0 : 1,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 16.0,
                      maxWidth: 16.0,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: _loading,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ));
    return widget.unconstrained == true
        ? UnconstrainedBox(
            child: child,
          )
        : child;
  }

  void stopLoading() {
    if (mounted)
      setState(() {
        _loading = false;
      });
  }

  void startLoading() {
    if (mounted)
      setState(() {
        _loading = true;
      });
  }
}
