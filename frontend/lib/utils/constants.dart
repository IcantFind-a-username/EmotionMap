import 'package:flutter/material.dart';

class AppConstants {
  static const String baseUrl = 'http://localhost:8080/api'; // Use 10.0.2.2 for Android emulator

  // NTU campus center coordinates
  static const double defaultLat = 1.3483;
  static const double defaultLng = 103.6831;
  static const double defaultRadius = 2000; // meters

  static const Map<String, String> emotionEmojis = {
    'HAPPY': '😊',
    'SAD': '😢',
    'ANGRY': '😠',
    'ANXIOUS': '😰',
    'CALM': '😌',
  };

  static const Map<String, String> emotionLabels = {
    'HAPPY': 'Happy',
    'SAD': 'Sad',
    'ANGRY': 'Angry',
    'ANXIOUS': 'Anxious',
    'CALM': 'Calm',
  };

  static const Map<String, Color> emotionColors = {
    'HAPPY': Color(0xFF4CAF50),
    'SAD': Color(0xFF2196F3),
    'ANGRY': Color(0xFFF44336),
    'ANXIOUS': Color(0xFFFF9800),
    'CALM': Color(0xFF9C27B0),
  };

  static const List<String> positiveEmotions = ['HAPPY', 'CALM'];
  static const List<String> negativeEmotions = ['SAD', 'ANGRY', 'ANXIOUS'];
}
