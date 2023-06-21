import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonTextButtonWidget extends StatefulWidget {
  final double height;
  final double width;
  final String title;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final Color? bgColor;
  final Color? borderColor;
  final Color? titleTextColor;
  final Function onPressed;
  final bool? isUnderLine;
  final bool? isIcon;
  final String? icon;
  final bool? isBoxShadow;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;

  const CommonTextButtonWidget(
      {Key? key,
      required this.height,
      required this.width,
      required this.title,
      required this.titleFontSize,
      this.bgColor = Colors.blue,
      this.borderColor = Colors.blue,
      this.titleTextColor = Colors.white,
      required this.titleFontWeight,
      required this.onPressed,
      this.isIcon = false,
      this.icon,
      this.isUnderLine = false,
      this.isBoxShadow = false,
      this.boxShadow,
      this.borderRadius})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CommonTextButtonWidgetState createState() => _CommonTextButtonWidgetState();
}

class _CommonTextButtonWidgetState extends State<CommonTextButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isBoxShadow != null
          ? BoxDecoration(
              boxShadow: widget.boxShadow,
            )
          : null,
      height: widget.height,
      width: widget.width, // <-- Your height

      child: TextButton(
          onPressed: () => widget.onPressed(),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(widget.bgColor!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: widget.borderRadius != null
                    ? widget.borderRadius!
                    : BorderRadius.circular(8.0),
                side: BorderSide(color: widget.borderColor!),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isIcon! ? SvgPicture.asset(widget.icon!) : Container(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.007,
              ),
              Center(
                child: Text(widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.visible,
                      decoration: TextDecoration.none,
                    )),
              ),
            ],
          )),
    );
  }
}
