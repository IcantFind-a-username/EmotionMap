import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;
  Timer? _debounce;
  LatLng _center = const LatLng(AppConstants.defaultLat, AppConstants.defaultLng);

  static const _emotionHues = {
    'HAPPY': BitmapDescriptor.hueGreen,
    'SAD': BitmapDescriptor.hueBlue,
    'ANGRY': BitmapDescriptor.hueRed,
    'ANXIOUS': BitmapDescriptor.hueOrange,
    'CALM': BitmapDescriptor.hueCyan,
  };

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _loadData() {
    final provider = context.read<EmotionProvider>();
    provider.loadNearbyEmotions(_center.latitude, _center.longitude);
    provider.loadHeatmapData(_center.latitude, _center.longitude);
  }

  void _onCameraIdle() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _loadData();
    });
  }

  void _onCameraMove(CameraPosition pos) {
    _center = pos.target;
  }

  Set<Marker> _buildMarkers(EmotionProvider provider) {
    if (provider.showHeatmap) return {};
    return provider.nearbyEmotions.map((record) {
      final emoji = AppConstants.emotionEmojis[record.emotionType] ?? '❓';
      final label = AppConstants.emotionLabels[record.emotionType] ?? record.emotionType;
      final hue = _emotionHues[record.emotionType] ?? BitmapDescriptor.hueViolet;

      return Marker(
        markerId: MarkerId('emotion_${record.id}'),
        position: LatLng(record.latitude, record.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: '$emoji $label',
          snippet: record.note ?? '',
        ),
      );
    }).toSet();
  }

  Set<Circle> _buildCircles(EmotionProvider provider) {
    if (!provider.showHeatmap) return {};
    return provider.nearbyEmotions.map((record) {
      final isPositive = AppConstants.positiveEmotions.contains(record.emotionType);
      final color = isPositive ? Colors.green : Colors.red;

      return Circle(
        circleId: CircleId('heatmap_${record.id}'),
        center: LatLng(record.latitude, record.longitude),
        radius: 60,
        fillColor: color.withOpacity(0.3),
        strokeColor: color.withOpacity(0.6),
        strokeWidth: 1,
      );
    }).toSet();
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
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            markers: _buildMarkers(provider),
            circles: _buildCircles(provider),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
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
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
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
