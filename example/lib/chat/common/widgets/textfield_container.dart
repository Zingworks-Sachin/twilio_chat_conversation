import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final bool? isPaddingBig;
  final Widget child;
  final Border? border;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final double? width;
  const TextFieldContainer({
    this.isPaddingBig = true,
    this.border,
    this.boxShadow,
    this.color = Colors.white,
    this.width,
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.width * 0.02),
      padding: (isPaddingBig!)
          ? EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: size.width * 0.01)
          : EdgeInsets.zero,
      width: (width == null) ? size.width : width,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        border: border,
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
