import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/Message.dart';
import 'package:my_app/screens/messages/components/text_message.dart';



class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
    required this.message,
    this.isSender = false,
}) : super(key: key);

  final Message message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
        isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
              CircleAvatar(
               radius: 12,
               backgroundColor: kPrimaryColor,
               child: Text(
                    message.username.isNotEmpty?
                 message.username[0].toUpperCase():'',
                 style: const TextStyle(color: Color.fromARGB(255, 172, 170, 170)),
               ),
             ),
            const SizedBox(width: kDefaultPadding / 2),
          ],
          TextMessage(message: message. text, isSender: isSender),
        ],
          
      ),
    );
  }
}