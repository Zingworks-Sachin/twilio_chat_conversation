import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BubbleWidget extends StatelessWidget {
  final Map messageMap;
  final bool isMe;
  const BubbleWidget({Key? key, required this.messageMap, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bubble(
        margin: BubbleEdges.only(top: MediaQuery.of(context).size.width * .02),
        alignment: (isMe) ? Alignment.topRight : Alignment.topLeft,
        nipWidth: MediaQuery.of(context).size.width * .02,
        nipHeight: MediaQuery.of(context).size.width * .025,
        radius: const Radius.circular(12),
        nip: (isMe) ? BubbleNip.rightTop : BubbleNip.leftTop,
        color: (isMe) ? const Color(0xffE1FFC7) : const Color(0xfff5f1f1),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 5.0, right: 8, top: 5, bottom: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                (isMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (messageMap['attributes'] == "true")
                        ? "ChatGPT"
                        : messageMap["author"],
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 30, maxWidth: 250),
                      child: Text(messageMap["body"],
                          maxLines: 50, softWrap: true)),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * .015,
                        right: MediaQuery.of(context).size.width * .01),
                    child: Text(getDate(messageMap["dateCreated"]),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                        softWrap: true),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  String getFormattedTime(BuildContext context, int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return TimeOfDay.fromDateTime(date).format(context);
  }

  String getDate(String utcDateTimeString) {
    // String utcDateTimeString = '2023-06-12T11:45:17.123Z';

    DateTime utcDateTime = DateTime.parse(utcDateTimeString);

    // Convert UTC DateTime to IST DateTime
    DateTime istDateTime = utcDateTime.toLocal();

    // Format the IST DateTime as desired
    String formattedDateTime =
        DateFormat('dd/MM/yyyy hh:mm a').format(istDateTime);

    //print(formattedDateTime);
    return formattedDateTime;
  }
}
