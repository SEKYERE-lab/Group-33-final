import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/Chat.dart';
import 'package:my_app/providers/message_provider.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/screens/messages/components/chat_input_field.dart';
import 'package:my_app/shared/extentions.dart';
import 'package:provider/provider.dart';

import '../welcome/welcome_screen.dart';
import 'components/message_tile.dart';

class MessagesScreen extends StatefulWidget {
  final Chat chat;

  const MessagesScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late StreamSubscription _messageSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageProvider>().getMessages();
    });
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: _buildAppBar(context, userProvider),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, UserProvider userProvider) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 69, 189, 245),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(widget.chat.image),
            radius: 20,
          ),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chat.name,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Online',
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
        IconButton(
          onPressed: () => _handleSignOut(context, userProvider),
          icon: userProvider.isLoading
              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              : const Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return Consumer<MessageProvider>(
      builder: (_, messProvider, __) {
        if (messProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (messProvider.errorMessage != null) {
          return Center(
            child: Text(messProvider.errorMessage!, style: const TextStyle(color: Colors.red)),
          );
        }
        return ListView.builder(
          reverse: true,
          itemCount: messProvider.messages.length,
          itemBuilder: (context, index) {
            final message = messProvider.messages[index];
            final isSender = message.userId == context.read<UserProvider>().currentUser?.userId;
            return MessageTile(
              message: message,
              isSender: isSender,
            );
          },
        );
      },
    );
  }

  void _handleSignOut(BuildContext context, UserProvider userProvider) async {
    final response = await userProvider.signOut();
    response.fold(
      (error) => context.showError(error),
      (result) {
        if (result) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      },
    );
  }
}


