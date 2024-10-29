
class Message {
  final String id;
  final String userId;
  final String username;
  final String message;
  final String type;
  final DateTime createdAt;

  // Constructor
  Message({
    required this.id,
    required this.userId,
    required this.username,
    required this.message,
    required this.type,
    required this.createdAt,
  });

  // Factory method to create a Message instance from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''), // Parse as DateTime
    );
  }

  // Method to convert a Message instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'message': message,
      'type': type,
      'createdAt': createdAt.toIso8601String(), // Convert DateTime to String
    };
  }

  // Equality operator to compare two Message instances
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message &&
        id == other.id &&
        userId == other.userId &&
        username == other.username &&
        message == other.message &&
        type == other.type &&
        createdAt == other.createdAt;
  }

  // HashCode method to generate a hash code for the Message instance
  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ username.hashCode ^ message.hashCode ^ type.hashCode ^ createdAt.hashCode;

  get text => null;


  // toString method to get a string representation of the Message instance
  @override
  String toString() {
    return 'Message{id: $id, userId: $userId, username: $username, message: $message, type: $type, createdAt: $createdAt}';
  }

  // Method to create a copy of the current Message instance with modified values
  Message copyWith({
    String? userId,
    String? username,
    String? message,
    String? type,
    DateTime? createdAt,
  }) {
    return Message(
      id: id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
