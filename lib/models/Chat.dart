import 'package:intl/intl.dart';



class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final String image;
  final DateTime  timestamp;
  final String time;
  final bool isActive;
  final bool isRead;
  final int unreadMessages;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    this.image = '',
    this.isActive = false,
    this.isRead = false,
    this.unreadMessages = 0,
  }) : time = DateFormat('h:mm a').format(timestamp); // Automatically set 'time' based on 'timestamp'

    // Factory method to create a Chat object from a JSON response
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      timestamp: DateTime.parse(json['timestamp']),
      image: json['image'] ?? '', // Assuming image URL or path might be provided
      isRead: json['isRead'],
    );
  }

  // Method to convert Chat object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'timestamp': timestamp.toIso8601String(),
      'image': image,
      'isRead': isRead,
      'time': time,
      'isActive': isActive,
      'unreadMessages': unreadMessages,
    };
  }
}

 