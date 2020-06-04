import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Todo: - Change backgroundColor when activated

class TextFieldButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color highlightColor;
  final Widget child;

  TextFieldButton({
    @required this.onPressed,
    highlightColor,
    this.child,
  }) : this.highlightColor = highlightColor ?? Colors.grey.withOpacity(.3);

  @override
  _TextFieldButtonState createState() => _TextFieldButtonState();
}

class _TextFieldButtonState extends State<TextFieldButton> {
  VoidCallback onPressed;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    onPressed = () {
      widget.onPressed();
      setState(() {
        _pressed = false;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails tapUpDetails) {
        setState(() {
          _pressed = !_pressed;
        });
        widget.onPressed();
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AnimatedContainer(
            width: constraints.minHeight,
            height: constraints.minHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _pressed ? widget.highlightColor : Colors.transparent,
            ),
            duration: Duration(milliseconds: 200),
            child: widget.child,
          );
        },
      ),
    );
  }
}
