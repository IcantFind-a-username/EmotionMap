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

  static const List<String> positiveEmotions = ['HAPPY', 'CALM'];
  static const List<String> negativeEmotions = ['SAD', 'ANGRY', 'ANXIOUS'];
}
