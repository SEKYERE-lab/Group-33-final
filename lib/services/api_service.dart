import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/Thread.dart';
import 'package:my_app/models/course.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_app/models/announcement.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart'; // Add this import

class ApiService {
  static const String baseUrl = "http://localhost/slic_api/";
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    responseType: ResponseType.json,
  ));

  final logger = Logger(); // Initialize logger

  Future<Map<String, dynamic>> postMessage({
    required String userId,
    required String courseId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse("${baseUrl}post_message.php"),
      body: {
          'user_id': userId,
        'course_id': courseId,
        'message': message,
      },
    );
    return json.decode(response.body);
  }

  Future<List<dynamic>> getMessage({
    required String courseId,
  }) async {
    final response = await http.post(
      Uri.parse("${baseUrl}get_message.php"),
      body: {
        'course_id': courseId,
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return jsonResponse['messages'] as List<dynamic>;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to get messages');
      }
    } else {
      throw Exception('Failed to get messages. Status code: ${response.statusCode}');
    }
  }



  // Sign Up Method
  Future<Map<String, dynamic>> signUp({
    required String username,
    required String password,
    required String email,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }


  // Sign In Method
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        'signin.php',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Sign in successful',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to sign in',
          'data': null,
        };
      }
    } catch (e) {
      logger.e('Error during sign in: $e'); // Use logger for error logging
      return {
        'success': false,
        'message': 'Error during sign in: $e',
        'data': null,
      };
    }
  }


// Fetch Chat List
  Future<List<dynamic>> fetchChatList() async {
    final url = Uri.parse('$baseUrl/get_chats.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch chat list');
    }
  }

  // Send Message
  Future<Map<String, dynamic>> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final url = Uri.parse('$baseUrl/send_message.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }

  // Fetch Messages in a Chat
  Future<List<dynamic>> fetchMessages({
    required String chatId,
  }) async {
    final url = Uri.parse('$baseUrl/get_messages.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'chat_id': chatId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch messages');
    }
  }
 Future<List<dynamic>> getThreads({required String courseId}) async {
    final response = await http.get(Uri.parse('$baseUrl/get_threads.php?course_id=$courseId'));
    if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load threads');
  }
 }

  Future<void> createThread({
    required String courseId,
    required String title,
    required String description,
    required String userId, // Pass the user ID dynamically
  }) async {
    try{
    final response = await http.post(
      Uri.parse('$baseUrl/create_thread.php'),
      body: {
        'course_id': courseId,
        'user_id': userId, // Use dynamic user ID
        'title': title,
        'description': description,
      },
    );


     final data = json.decode(response.body);
    if (data['status'] == 'success') {
      logger.i('Thread created successfully'); // Use logger for info logging
    } else {
      logger.e('Error: ${data['message']}'); // Use logger for error logging
    }
  } catch (e) {
    logger.e('Error creating thread: $e'); // Use logger for error logging
  }
  }

  Future<void> postThreadMessage({
    required String threadId,
    required String message,
    required String userId, // Pass the user ID dynamically
  }) async {
    await http.post(
      Uri.parse('$baseUrl/post_thread_message.php'),
      body: {
        'thread_id': threadId,
        'user_id': userId, // Use dynamic user ID
        'message': message,
      },
    );
  }

   Future<List<dynamic>> getThreadMessages({required String threadId}) async {
    final response = await http.get(Uri.parse('$baseUrl/get_thread_messages.php?thread_id=$threadId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load thread messages');
    }
  }

   // Fetch list of courses
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/get_courses.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((courseJson) => Course.fromJson(courseJson)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

   // Fetch threads for a course
  Future<List<Thread>> fetchThreads(String courseId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_threads.php?course_id=$courseId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          List<dynamic> data = jsonResponse['data'];
          return data.map((threadJson) => Thread.fromJson(threadJson)).toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load threads');
        }
      } else {
        throw Exception('Failed to load threads. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching threads: $e');
    }
  }

  Future<List<Announcement>> getAnnouncements() async {
    final response = await http.get(Uri.parse('https://uenr.edu.gh'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Announcement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String content,
    required int createdBy,
  }) async {
    final url = Uri.parse('${baseUrl}create_announcement.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'content': content,
        'created_by': createdBy,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create announcement');
    }
  }

  Future<void> launchAnnouncementsWebsite() async {
    const url = 'https://uenr.edu.gh';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchPortal() async {
    const url = 'https://sis.uenr.edu.gh';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}