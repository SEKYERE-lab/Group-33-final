import 'package:flutter/material.dart';
import 'package:my_app/screens/auth/components/create_thread_screen.dart';
import 'package:my_app/screens/auth/components/thread_messages_screen.dart';
import 'package:my_app/services/api_service.dart';


class ThreadListScreen extends StatefulWidget {
  final String courseId;

  const ThreadListScreen({super.key, required this.courseId});

  @override
  _ThreadListScreenState createState() => _ThreadListScreenState();
}

class _ThreadListScreenState extends State<ThreadListScreen> {
  late ApiService apiService;
  List<dynamic> threads = [];

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchThreads();
  }

  Future<void> fetchThreads() async {
    try {
      final data = await apiService.getThreads(courseId: widget.courseId);
      setState(() {
        threads = data;
      });
    } catch (e) {
      print("Error fetching threads: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Open thread creation screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateThreadScreen(courseId: widget.courseId),
                ),
              );
            },
          )
        ],
      ),
      body: threads.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: threads.length,
              itemBuilder: (context, index) {
                final thread = threads[index];
                return ListTile(
                  title: Text(thread['title']),
                  subtitle: Text(thread['description']),
                  onTap: () {
                    // Open thread messages screen
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
    );
  }
}
