class Course {
  final String courseId;
  final String courseName;

  Course({required this.courseId, required this.courseName});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'],
      courseName: json['course_name'],
    );
  }
}
