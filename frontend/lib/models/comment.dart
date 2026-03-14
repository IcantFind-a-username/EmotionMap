class Comment {
  final int id;
  final int emotionRecordId;
  final int userId;
  final String content;
  final String createdAt;

  Comment({
    required this.id,
    required this.emotionRecordId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      emotionRecordId: json['emotionRecordId'] as int,
      userId: json['userId'] as int,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'emotionRecordId': emotionRecordId,
        'userId': userId,
        'content': content,
        'createdAt': createdAt,
      };
}
