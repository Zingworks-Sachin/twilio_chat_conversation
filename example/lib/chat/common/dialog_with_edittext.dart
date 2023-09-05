import 'package:flutter/material.dart';
import 'package:twilio_chat_conversation_example/chat/common/widgets/common_textfield.dart';

class DialogWithEditText extends StatefulWidget {
  final Function onPressed;
  final String dialogTitle;

  const DialogWithEditText(
      {super.key, required this.onPressed, required this.dialogTitle});

  @override
  _DialogWithEditTextState createState() => _DialogWithEditTextState();
}

class _DialogWithEditTextState extends State<DialogWithEditText> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
      title: Text(
        widget.dialogTitle,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.brown[400],
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextInputField(
          textCapitalization: TextCapitalization.none,
          hintText: "Type here..",
          hintStyle: const TextStyle(
            color: Color(0xffB7B7B7),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
          //  maxLength: 1,
          textInputFormatter: const [],
          keyboardType: TextInputType.text,
          width: MediaQuery.of(context).size.width * 0.14,
          color: Colors.white,
          borderColor: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.31),
              blurRadius: 15,
              offset: const Offset(-5, 5),
            )
          ],
          controller: _textFieldController,
          textStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
          ),
          child: const Text('OK'),
          onPressed: () {
            String enteredText = _textFieldController.text;
            // Do something with the entered text
            widget.onPressed(enteredText);
          },
        ),
      ],
    );
  }
}
