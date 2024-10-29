import 'package:flutter/material.dart';
import 'package:my_app/components/filled_outline_button.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/Chat.dart';
import 'package:my_app/screens/auth/components/forum_screen.dart';
import 'package:my_app/screens/messages/message_screen.dart';

import 'chat_card.dart';

class Body extends StatefulWidget {
  final List<Chat> chats; // Added this line to accept a list of chats
  final Function(dynamic chat) onChatSelected;

  const Body({
    Key? key,
    required this.chats, // Added this line to accept a list of chats
    required this.onChatSelected,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool showRecentMessages = true; // State to toggle between recent and active chats

  @override
  Widget build(BuildContext context) {
    // Filter chats based on the selected button
    List<Chat> filteredChats = showRecentMessages
        ? widget.chats // Use the provided chats list
        : widget.chats.where((chat) => chat.isActive).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color:  const Color.fromARGB(255, 100, 193, 230),
          child: Row(
            children: [
              FillOutlineButton(
                press: () {
                  setState(() {
                    showRecentMessages = true;
                  });
                },
                text: "Recent Message",
                isFilled: showRecentMessages,
              ), 
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {
                  setState(() {
                    showRecentMessages = false;
                  });
                },
                text: "Active",
                isFilled: !showRecentMessages,
              ),
                 const SizedBox(width: kDefaultPadding),
                ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForumScreen(courseId: 'your_course_id_here'),
      ),
    );
  },
  child: const Text('Go to Forum'),
),

            ],
          ),
        ),

        // Example button to navigate to ForumScreen


        Expanded(
          child: ListView.builder(
            itemCount: filteredChats.length,
            itemBuilder: (context, index) => ChatCard(
              chat: filteredChats[index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagesScreen(
                    chat: filteredChats[index], // Pass the selected chat to the MessagesScreen
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
