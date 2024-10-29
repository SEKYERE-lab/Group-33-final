class Thread {
  final String threadId;
  final String title;
  final String description;

  Thread({
    required this.threadId,
    required this.title,
    required this.description,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      threadId: json['thread_id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
