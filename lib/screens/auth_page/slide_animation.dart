import 'package:flutter/material.dart';

import 'auth_widget.dart';

class SlideAnimationWidget extends StatefulWidget {
  @override
  _SlideAnimationWidgetState createState() => _SlideAnimationWidgetState();
}

class _SlideAnimationWidgetState extends State<SlideAnimationWidget> {
  bool _isContainerVisible = true;

  void _toggle() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 32,
                left: _isContainerVisible
                    ? 0
                    : -MediaQuery.of(context).size.width,
                child: AuthWidget(false, _toggle),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 32,
                left:
                    _isContainerVisible ? MediaQuery.of(context).size.width : 0,
                child: AuthWidget(true, _toggle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}