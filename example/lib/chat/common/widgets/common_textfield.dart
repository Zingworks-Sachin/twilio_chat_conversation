import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twilio_chat_conversation_example/chat/common/widgets/textfield_container.dart';

const border = OutlineInputBorder(
    borderRadius: BorderRadius.horizontal(left: Radius.circular(10.0)));

class TextInputField extends StatefulWidget {
  final bool? isPaddingBig;
  final String hintText;
  final Widget? icon;
  final Widget? suffixIcon;
  final Color? color;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final double? width;
  final String? errorText;
  final int? maxLength;
  final String? cursorText = "";
  final bool readOnly;
  final Color borderColor;
  final List<BoxShadow>? boxShadow;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? textInputFormatter;
  final Function? onchange;
  final TextStyle textStyle;
  final TextStyle? hintStyle;
  const TextInputField(
      {Key? key,
      this.isPaddingBig = true,
      required this.hintText,
      this.color = Colors.white,
      this.icon,
      this.suffixIcon,
      required this.borderColor,
      this.width,
      this.boxShadow,
      this.onchange,
      required this.keyboardType,
      required this.controller,
      this.errorText,
      this.maxLength,
      cursorText,
      this.textCapitalization,
      this.readOnly = false,
      this.textInputFormatter,
      required this.textStyle,
      this.hintStyle})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool validEmail = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      isPaddingBig: widget.isPaddingBig,
      width: widget.width,
      color: widget.color,
      boxShadow: widget.boxShadow != null ? widget.boxShadow! : null,
      border: validEmail
          ? Border.all(color: widget.borderColor)
          : Border.all(color: Colors.red),
      child: TextField(
        style: widget.textStyle,
        inputFormatters: widget.textInputFormatter,
        textCapitalization: widget.textCapitalization!,
        maxLength: widget.maxLength,
        onTap: () {},
        onChanged: (e) {
          try {
            widget.onchange!(e);
            // ignore: empty_catches
          } catch (e) {}
        },
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
            contentPadding: (widget.isPaddingBig!)
                ? null
                : const EdgeInsets.fromLTRB(10, 12, 10, 12),
            prefixIcon: widget.icon,
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            errorText: widget.errorText,
            border: InputBorder.none,
            counterText: widget.cursorText),
      ),
    );
  }
}
