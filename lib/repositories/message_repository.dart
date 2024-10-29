import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';


import '../models/Message.dart';

class MessageRepository {
  final String baseUrl = 'http://localhost/slic_api'; // Base URL
  final String sendMessageEndpoint = '/send_message.php'; // Endpoint for sending messages
  final String getMessageEndpoint = '/get_messages.php'; // Endpoint for retrieving messages
  final String latestMessagesEndpoint = '/get_latest_messages.php'; // Endpoint for getting latest messages

 Future<Either<String, Message?>> sendMessage(Message message) async {
  final url = '$baseUrl$sendMessageEndpoint'; // Full URL for sending messages
   try{
     final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(message.toJson()),
     );
     
      if (response.statusCode == 201) { // Assuming 201 Created is the success code
        final messageJson = json.decode(response.body);
        return right(Message.fromJson(messageJson));
      } else {
        return left('Failed to send message');
      }
    } catch (e) {
      return left('An error occurred');
    }
  }

 Future<Either<String, List<Message>>> getMessage() async {
  final url = '$baseUrl$getMessageEndpoint'; // Full URL for retrieving messages
   try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final messages = data.map((json) => Message.fromJson(json)).toList();
        messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return right(messages);
      } else {
        return left('Failed to load messages');
      }
    } catch (e) {
      return left('An error occurred');
    }
  }

 Future<Either<String, List<Message>>> getLatestMessage() async {
    final url = '$baseUrl$latestMessagesEndpoint'; // Full URL for latest messages

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final messages = data.map((json) => Message.fromJson(json)).toList();
        return right(messages);
      } else {
        return left('Failed to load latest messages');
      }
    } catch (e) {
      return left('An error occurred');
    }
  }

  Stream<Message> subscribeToMessage() async* {
    // XAMPP does not have built-in support for GraphQL subscriptions,
    // you may need to use WebSockets or other methods for real-time updates.
    // This is a placeholder to show where subscription code would go.
  }
}

  