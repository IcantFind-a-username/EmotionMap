import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../utils/constants.dart';
import '../widgets/emotion_bottom_sheet.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  Timer? _debounce;
  LatLng _center = LatLng(AppConstants.defaultLat, AppConstants.defaultLng);

  static const _emotionColors = {
    'HAPPY': Colors.green,
    'SAD': Colors.blue,
    'ANGRY': Colors.red,
    'ANXIOUS': Colors.orange,
    'CALM': Colors.teal,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _loadData() {
    final provider = context.read<EmotionProvider>();
    provider.loadNearbyEmotions(_center.latitude, _center.longitude);
    provider.loadHeatmapData(_center.latitude, _center.longitude);
  }

  void _onMapEvent(MapEvent event) {
    if (event is MapEventMoveEnd) {
      _center = event.camera.center;
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), () => _loadData());
    }
  }

  List<Marker> _buildMarkers(EmotionProvider provider) {
    if (provider.showHeatmap) return [];
    return provider.nearbyEmotions.map((record) {
      final emoji = AppConstants.emotionEmojis[record.emotionType] ?? '❓';
      final color = _emotionColors[record.emotionType] ?? Colors.grey;

      return Marker(
        point: LatLng(record.latitude, record.longitude),
        width: 40,
        height: 40,
        child: Tooltip(
          message: '${AppConstants.emotionLabels[record.emotionType] ?? record.emotionType}'
              '${record.note != null && record.note!.isNotEmpty ? "\n${record.note}" : ""}',
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)],
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<CircleMarker> _buildHeatCircles(EmotionProvider provider) {
    if (!provider.showHeatmap) return [];
    return provider.nearbyEmotions.map((record) {
      final isPositive = AppConstants.positiveEmotions.contains(record.emotionType);
      final color = isPositive ? Colors.green : Colors.red;

      return CircleMarker(
        point: LatLng(record.latitude, record.longitude),
        radius: 25,
        color: color.withOpacity(0.3),
        borderColor: color.withOpacity(0.6),
        borderStrokeWidth: 1,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EmotionMap'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(provider.showHeatmap ? Icons.layers : Icons.layers_outlined),
            tooltip: provider.showHeatmap ? 'Show markers' : 'Show heatmap',
            onPressed: () => provider.toggleHeatmap(),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15,
              onMapEvent: _onMapEvent,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.emotion_map',
              ),
              CircleLayer(circles: _buildHeatCircles(provider)),
              MarkerLayer(markers: _buildMarkers(provider)),
            ],
          ),
          if (provider.isLoading)
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary),
                      ),
                      const SizedBox(width: 8),
                      const Text('Loading emotions...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showEmotionBottomSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('How do you feel?'),
      ),
    );
  }
}
