import 'package:flutter/material.dart';
import 'package:my_app/screens/auth/components/thread_messages_screen.dart';
import 'package:my_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumScreen extends StatefulWidget {
  final String courseId;

  const ForumScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<dynamic> _threads = [];
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
     _loadUserId(); // Load userId from SharedPreferences
    _fetchThreads();
  }

   Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId'); // Get the userId
    });
  }


  Future<void> _fetchThreads() async {
    final apiService = ApiService();
    final threads = await apiService.getThreads(courseId: widget.courseId);

    setState(() {
      _threads = threads;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Discussions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _threads.length,
              itemBuilder: (context, index) {
                final thread = _threads[index];
                return ListTile(
                  title: Text(thread['title']),
                  subtitle: Text('Started by ${thread['username']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThreadMessagesScreen(
                          threadId: thread['thread_id'],
                          threadTitle: thread['title'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateThreadDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateThreadDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Thread'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Thread Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Thread Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final apiService = ApiService();
                await apiService.createThread(
                  courseId: widget.courseId,
                  title: titleController.text,
                  description: descriptionController.text,
                  userId: _userId!, // Pass the userId here
                );
                Navigator.pop(context);
                _fetchThreads(); // Refresh thread list after creating a thread
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
