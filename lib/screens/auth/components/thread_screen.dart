import 'package:flutter/material.dart';
import 'package:my_app/models/Thread.dart';
import 'package:my_app/services/api_service.dart';
import 'create_thread_screen.dart'; // Placeholder for the next step

class ThreadScreen extends StatefulWidget {
  final String courseId;

  const ThreadScreen({super.key, required this.courseId});

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  List<Thread> threads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchThreads();
  }

  Future<void> _fetchThreads() async {
    try {
      final fetchedThreads = await ApiService().fetchThreads(widget.courseId);
      setState(() {
        threads = fetchedThreads;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching threads: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threads for Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to Create Thread Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateThreadScreen(courseId: widget.courseId),
      
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
            child: CircularProgressIndicator(),
            
            )
          : ListView.builder(
              itemCount: threads.length,
              itemBuilder: (context, index) {
                final thread = threads[index];
                return ListTile(
                  title: Text(thread.title),
                  subtitle: Text(thread.description),
                  onTap: () {
                    // Navigate to Forum for this thread (we'll implement next)
                  },
                );
              },
            ),
    );
  }
}
