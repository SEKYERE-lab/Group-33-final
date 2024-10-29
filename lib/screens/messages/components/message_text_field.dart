import 'package:flutter/material.dart';
import 'package:my_app/providers/message_provider.dart';
import 'package:my_app/shared/extentions.dart';
import 'package:provider/provider.dart';
import '../../../models/Message.dart';
import '../../../providers/user_provider.dart';
import 'package:uuid/uuid.dart';




class MessageTextField extends StatefulWidget {
  const MessageTextField({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  late final TextEditingController _messageController;
  late String _currentUserId;
  late String _currentUsername;
  final Uuid uuid = const Uuid();
  
  


  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
     final userProvider = context.read<UserProvider>();
    _currentUserId = userProvider.currentUser?.userId ?? '';
    _currentUsername = userProvider.currentUser?.username ?? '';
        
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: _messageController,
        textInputAction: TextInputAction.send,
        onFieldSubmitted: (value) async {
         if (value.isNotEmpty) {
           final message = Message(
            id: uuid.v4(),
             userId: _currentUserId,
             username: _currentUsername,
             message: _messageController.text,
             type: "Message",
             createdAt: DateTime.now(),
           );

           final error =
               await context.read<MessageProvider>().sendMessage(message);
             
             if (error != null) {
              context.showError(error);  // Display the error if it exists
            } else {
              _messageController.clear();  // Clear the input field if sending was successful
            }
          
         }
        },
        
        decoration: const InputDecoration(
          hintText: "Type message",
          border: InputBorder.none,
        ),
      ),
    );
  }
}