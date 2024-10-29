import 'package:flutter/material.dart';
import 'package:my_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CreateThreadScreen extends StatefulWidget {
  final String courseId;

  const CreateThreadScreen({super.key, required this.courseId});

  @override
  _CreateThreadScreenState createState() => _CreateThreadScreenState();
}

class _CreateThreadScreenState extends State<CreateThreadScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Load userId when screen initializes
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId'); // Assuming 'userId' was saved during login
    });
  }


  void _createThread() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
       // Handle case where userId is not available
      print('User ID not found or fields are empty');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ApiService().createThread(
        courseId: widget.courseId,
        title: titleController.text,
        description: descriptionController.text,
         userId: _userId!, // Pass the retrieved userId here
      );
      Navigator.pop(context); // Go back after thread creation
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error creating thread: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Thread'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createThread,
                    child: const Text('Create Thread'),
                  ),
          ],
        ),
      ),
    );
  }
}
