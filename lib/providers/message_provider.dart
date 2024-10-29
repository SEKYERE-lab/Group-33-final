import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Message.dart';

class MessageProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Message> _messages = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Message> get messages => _messages;
  String? get errorMessage => _errorMessage;

  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getMessages() async {
    _setIsLoading(true);
    const url = 'http://localhost/slic_api/get_messages.php'; // Update with your API URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Message> loadedMessages = [];
        final extractedData = json.decode(response.body) as List<dynamic>;
        for (var msg in extractedData) {
          loadedMessages.add(Message.fromJson(msg));
        }
        _messages = loadedMessages;
      } else {
        _errorMessage = 'Failed to load messages';
      }
    } catch (error) {
      _errorMessage = error.toString();
    }
    _setIsLoading(false);
  }

  Future<String?> sendMessage(Message message) async {
    const url = 'http://localhost/slic_api/send_message.php'; // Update with your API URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(message.toJson()),
      );
      if (response.statusCode == 201) {
        _messages.insert(0, message);
        notifyListeners();
        return null;  // Indicate success
      } else {
         return 'Failed to send message';
      }
    } catch (error) {
       return error.toString();
    }
  }

  void addMessage(Message message) {
    _messages.insert(0, message);
    notifyListeners();
  }
}
