class EmotionRecord {
  final int id;
  final int? userId;
  final String emotionType;
  final double latitude;
  final double longitude;
  final String? note;
  final String createdAt;

  EmotionRecord({
    required this.id,
    this.userId,
    required this.emotionType,
    required this.latitude,
    required this.longitude,
    this.note,
    required this.createdAt,
  });

  factory EmotionRecord.fromJson(Map<String, dynamic> json) {
    return EmotionRecord(
      id: json['id'] as int,
      userId: json['userId'] as int?,
      emotionType: json['emotionType'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      note: json['note'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  static List<EmotionRecord> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => EmotionRecord.fromJson(e as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'emotionType': emotionType,
        'latitude': latitude,
        'longitude': longitude,
        'note': note,
        'createdAt': createdAt,
      };
}
