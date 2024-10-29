import 'package:flutter/material.dart';
import 'package:my_app/models/course.dart';
import 'package:my_app/screens/auth/components/thread_screen.dart';
import 'package:my_app/services/api_service.dart';


class CourseSelectionScreen extends StatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  _CourseSelectionScreenState createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  List<Course> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final fetchedCourses = await ApiService().fetchCourses();
      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Course'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course.courseName),
                  onTap: () {
                    // Navigate to ThreadScreen with courseId
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThreadScreen(courseId: course.courseId),
                ),
              );
                  },
                );
              },
            ),
    );
  }
}
