import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatTextWidget extends StatefulWidget {
  final String hintText;
  final Function(String text) onSend;
  final bool haveValidation;
  final TextEditingController msgController;
  const ChatTextWidget(
      {Key? key,
      required this.onSend,
      required this.hintText,
      required this.haveValidation,
      required this.msgController})
      : super(key: key);

  @override
  State<ChatTextWidget> createState() => _ChatTextWidgetState();
}

class _ChatTextWidgetState extends State<ChatTextWidget> {
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .74,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width,
                minHeight: 25.0,
                maxHeight: 135.0,
              ),
              child: Scrollbar(
                child: TextFormField(
                  controller: widget.msgController,
                  cursorColor: Colors.blueAccent,
                  minLines: 1,
                  maxLines: 5,
                  cursorHeight: 25,
                  inputFormatters: widget.haveValidation
                      ? [
                          FilteringTextInputFormatter.deny(RegExp(
                              r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                        ]
                      : [],
                  style: const TextStyle(height: 1.4, decorationThickness: 0),
                  onChanged: (val) {
                    if (!mounted) return;
                    setState(() {
                      if (widget.msgController.text.trim() != "") {
                        isButtonEnabled = true;
                      } else {
                        isButtonEnabled = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                      hintText: widget.hintText.toString(),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(15),
                      hintStyle: const TextStyle(
                          fontSize: 16.0, color: Color(0xff858585)),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * .02),
                          borderSide: BorderSide.none)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 1,
          child: ButtonTheme(
            child: MaterialButton(
              color: isButtonEnabled ? Colors.blueAccent : Colors.blueAccent,
              onPressed: () {
                widget.onSend(widget.msgController.text.toString());
              },
              shape: const CircleBorder(),
              elevation: 0.0,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .04),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
