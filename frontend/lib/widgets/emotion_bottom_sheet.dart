import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';

void showEmotionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _EmotionSheet(),
  );
}

class _EmotionSheet extends StatefulWidget {
  const _EmotionSheet();

  @override
  State<_EmotionSheet> createState() => _EmotionSheetState();
}

class _EmotionSheetState extends State<_EmotionSheet> {
  final _noteController = TextEditingController();
  final _locationService = LocationService();

  String? _selectedEmotion;
  double? _lat;
  double? _lng;
  bool _submitting = false;
  bool _locating = true;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    try {
      final pos = await _locationService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _lat = pos.latitude;
          _lng = pos.longitude;
          _locating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Fall back to campus center so the user can still submit
          _lat = AppConstants.defaultLat;
          _lng = AppConstants.defaultLng;
          _locationError = e.toString().replaceFirst('Exception: ', '');
          _locating = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (_selectedEmotion == null || _lat == null || _lng == null) return;

    setState(() => _submitting = true);

    final provider = context.read<EmotionProvider>();
    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();
    final success = await provider.submitEmotion(_selectedEmotion!, _lat!, _lng!, note);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? 'Emotion recorded! 🎉' : 'Failed to submit. Please try again.'),
        backgroundColor: success ? Colors.teal : Colors.red.shade400,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset, left: 20, right: 20, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'How are you feeling?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // Emotion selector row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: AppConstants.emotionEmojis.entries.map((entry) {
              final selected = _selectedEmotion == entry.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedEmotion = entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? colorScheme.primaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? colorScheme.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.value, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 4),
                      Text(
                        AppConstants.emotionLabels[entry.key] ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Note field
          TextField(
            controller: _noteController,
            maxLength: 255,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Add a note (optional)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),

          // Location status
          if (_locating)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary)),
                const SizedBox(width: 8),
                Text('Detecting location...', style: TextStyle(fontSize: 13, color: colorScheme.outline)),
              ],
            )
          else if (_locationError != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 14, color: colorScheme.outline),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Using campus center (GPS unavailable)',
                    style: TextStyle(fontSize: 12, color: colorScheme.outline),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 14, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text('Location detected', style: TextStyle(fontSize: 12, color: colorScheme.primary)),
              ],
            ),
          const SizedBox(height: 16),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: (_selectedEmotion == null || _locating || _submitting) ? null : _submit,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Submit', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
