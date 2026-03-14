import 'package:flutter/foundation.dart';
import '../models/emotion_record.dart';
import '../services/api_service.dart';

class EmotionProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<EmotionRecord> nearbyEmotions = [];
  List<Map<String, dynamic>> heatmapData = [];
  List<Map<String, dynamic>> trendData = [];
  bool isLoading = false;
  bool showHeatmap = false;

  final String? _token;
  EmotionProvider(this._token);

  Future<void> loadNearbyEmotions(double lat, double lng, {double radius = 2000}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get('/emotions/nearby', params: {
        'lat': lat,
        'lng': lng,
        'radius': radius,
      });
      final data = response.data['data'] as List<dynamic>;
      nearbyEmotions = EmotionRecord.fromJsonList(data);
    } catch (e) {
      print('Failed to load nearby emotions: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadHeatmapData(double lat, double lng, {double radius = 2000}) async {
    try {
      final response = await _api.get('/emotions/heatmap', params: {
        'lat': lat,
        'lng': lng,
        'radius': radius,
      });
      final data = response.data['data'];
      if (data is List) {
        heatmapData = data.cast<Map<String, dynamic>>();
      }
      notifyListeners();
    } catch (e) {
      print('Failed to load heatmap data: $e');
    }
  }

  Future<void> loadTrends(double lat, double lng, {int days = 7}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get('/emotions/trends', params: {
        'lat': lat,
        'lng': lng,
        'days': days,
      });
      final data = response.data['data'];
      if (data is List) {
        trendData = data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Failed to load trends: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> submitEmotion(
    String emotionType,
    double lat,
    double lng,
    String? note,
  ) async {
    try {
      await _api.post('/emotions', data: {
        'emotionType': emotionType,
        'latitude': lat,
        'longitude': lng,
        'note': note,
      });
      await loadNearbyEmotions(lat, lng);
      return true;
    } catch (e) {
      print('Failed to submit emotion: $e');
      return false;
    }
  }

  void toggleHeatmap() {
    showHeatmap = !showHeatmap;
    notifyListeners();
  }

  Future<List<EmotionRecord>> loadUserEmotions() async {
    try {
      final response = await _api.get('/emotions/my');
      final data = response.data['data'] as List<dynamic>;
      return EmotionRecord.fromJsonList(data);
    } catch (e) {
      print('Failed to load user emotions: $e');
      return [];
    }
  }
}
