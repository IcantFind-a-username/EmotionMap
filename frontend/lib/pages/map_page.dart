import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../utils/constants.dart';
import '../widgets/emotion_bottom_sheet.dart';
import '../widgets/emotion_detail_sheet.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  Timer? _debounce;
  LatLng _center = LatLng(AppConstants.defaultLat, AppConstants.defaultLng);

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
      _debounce =
          Timer(const Duration(milliseconds: 600), () => _loadData());
    }
  }

  List<Marker> _buildMarkers(EmotionProvider provider) {
    if (provider.showHeatmap) return [];
    return provider.nearbyEmotions.map((record) {
      final emoji = AppConstants.emotionEmojis[record.emotionType] ?? '❓';
      final color =
          AppConstants.emotionColors[record.emotionType] ?? Colors.grey;
      final label = AppConstants.emotionLabels[record.emotionType] ??
          record.emotionType;

      return Marker(
        point: LatLng(record.latitude, record.longitude),
        width: 44,
        height: 44,
        child: GestureDetector(
          onTap: () => showEmotionDetailSheet(context, record),
          child: Tooltip(
            message: '$label'
                '${record.note != null && record.note!.isNotEmpty ? "\n${record.note}" : ""}',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.45),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<CircleMarker> _buildHeatCircles(EmotionProvider provider) {
    if (!provider.showHeatmap) return [];
    final data = provider.heatmapData;
    if (data.isEmpty) return [];

    final weights = data
        .map((p) => (p['weight'] as num?)?.toDouble() ?? 1.0)
        .toList();
    final maxWeight = weights.fold<double>(1, (a, b) => a > b ? a : b);

    return data.map((p) {
      final lat = (p['latitude'] as num).toDouble();
      final lng = (p['longitude'] as num).toDouble();
      final weight = (p['weight'] as num?)?.toDouble() ?? 1.0;
      final emotion = p['dominantEmotion']?.toString() ?? 'HAPPY';
      final color =
          AppConstants.emotionColors[emotion] ?? Colors.grey;
      final ratio = (weight / maxWeight).clamp(0.0, 1.0);
      final radiusMeters = 40 + ratio * 120;
      final alpha = 0.25 + ratio * 0.35;
      return CircleMarker(
        point: LatLng(lat, lng),
        radius: radiusMeters,
        useRadiusInMeter: true,
        color: color.withOpacity(alpha),
        borderColor: color.withOpacity((alpha + 0.2).clamp(0.0, 0.85)),
        borderStrokeWidth: 1,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('EmotionMap'),
        centerTitle: true,
        backgroundColor: colorScheme.surface.withOpacity(0.85),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: provider.showHeatmap ? 'Show markers' : 'Show heatmap',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                provider.showHeatmap
                    ? Icons.local_fire_department
                    : Icons.local_fire_department_outlined,
                key: ValueKey(provider.showHeatmap),
                color: provider.showHeatmap
                    ? Colors.deepOrange
                    : colorScheme.onSurface,
              ),
            ),
            onPressed: () => provider.toggleHeatmap(),
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
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
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.emotion_map',
              ),
              CircleLayer(circles: _buildHeatCircles(provider)),
              MarkerLayer(markers: _buildMarkers(provider)),
            ],
          ),
          if (provider.isLoading)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(minHeight: 3),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showEmotionBottomSheet(context),
        icon: const Icon(Icons.add_reaction_outlined),
        label: const Text('How do you feel?'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
      ),
    );
  }
}
