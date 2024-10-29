import 'package:flutter/material.dart';
import 'package:my_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThreadMessagesScreen extends StatefulWidget {
  final String threadId;
  final String threadTitle;

  const ThreadMessagesScreen({
    Key? key,
    required this.threadId,
    required this.threadTitle,
  }) : super(key: key);

  @override
  _ThreadMessagesScreenState createState() => _ThreadMessagesScreenState();
}

class _ThreadMessagesScreenState extends State<ThreadMessagesScreen> {
  List<dynamic> _messages = [];
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Load userId from SharedPreferences
    _fetchMessages();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId'); // Assuming 'userId' is saved after login
    });
  }


  Future<void> _fetchMessages() async {
    final apiService = ApiService();
    final messages = await apiService.getThreadMessages(threadId: widget.threadId);

    setState(() {
      _messages = messages;
      _isLoading = false;
    });
  }

  Future<void> _postMessage() async {
    final message = _messageController.text;

    if (message.isNotEmpty) {
      final apiService = ApiService();
      await apiService.postThreadMessage(
        threadId: widget.threadId,
        message: message,
        userId: _userId!,
      );

      _messageController.clear();
      _fetchMessages(); // Refresh message list after posting
      } else {
      print("Message is empty or userId is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.threadTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        title: Text(message['message']),
                        subtitle: Text('Posted by ${message['username']}'),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _postMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
