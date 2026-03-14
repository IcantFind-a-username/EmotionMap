import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../utils/constants.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
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

  void _loadData() {
    context.read<EmotionProvider>().loadTrends(
          AppConstants.defaultLat,
          AppConstants.defaultLng,
          days: 7,
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Emotion Trends'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.trendData.isEmpty
                ? _buildEmptyState(colorScheme)
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildPieSection(context, provider),
                      const SizedBox(height: 24),
                      _buildLineSection(context, provider),
                    ],
                  ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        Center(
          child: Column(
            children: [
              Icon(Icons.insert_chart_outlined, size: 64, color: colorScheme.outline),
              const SizedBox(height: 12),
              Text(
                'No emotion data yet',
                style: TextStyle(fontSize: 16, color: colorScheme.outline),
              ),
              const SizedBox(height: 4),
              Text(
                'Be the first to share how you feel!',
                style: TextStyle(color: colorScheme.outline),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Pie chart: overall emotion distribution ---
  Widget _buildPieSection(BuildContext context, EmotionProvider provider) {
    final distribution = _computeDistribution(provider.trendData);
    if (distribution.isEmpty) return const SizedBox.shrink();

    final total = distribution.values.fold<int>(0, (sum, v) => sum + v);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emotion Distribution',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: distribution.entries.map((e) {
                    final pct = (e.value / total * 100).toStringAsFixed(1);
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      color: _emotionColors[e.key] ?? Colors.grey,
                      title: '$pct%',
                      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      radius: 55,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: distribution.entries.map((e) {
                final emoji = AppConstants.emotionEmojis[e.key] ?? '';
                final label = AppConstants.emotionLabels[e.key] ?? e.key;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _emotionColors[e.key],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('$emoji $label (${e.value})'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- Line chart: emotion counts per day ---
  Widget _buildLineSection(BuildContext context, EmotionProvider provider) {
    final perDay = _computeDailyTrends(provider.trendData);
    if (perDay.isEmpty) return const SizedBox.shrink();

    final dates = perDay.keys.toList()..sort();
    final emotionTypes = <String>{};
    for (final dayCounts in perDay.values) {
      emotionTypes.addAll(dayCounts.keys);
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('7-Day Trend',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 32, interval: 1),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= dates.length) return const SizedBox.shrink();
                          final d = dates[idx];
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              d.length >= 5 ? d.substring(5) : d,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: emotionTypes.map((emo) {
                    return LineChartBarData(
                      spots: List.generate(dates.length, (i) {
                        final count = perDay[dates[i]]?[emo] ?? 0;
                        return FlSpot(i.toDouble(), count.toDouble());
                      }),
                      isCurved: true,
                      color: _emotionColors[emo] ?? Colors.grey,
                      barWidth: 2.5,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: emotionTypes.map((emo) {
                final emoji = AppConstants.emotionEmojis[emo] ?? '';
                final label = AppConstants.emotionLabels[emo] ?? emo;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 16, height: 3, color: _emotionColors[emo]),
                    const SizedBox(width: 4),
                    Text('$emoji $label', style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Backend returns: [{date, happyCount, sadCount, angryCount, anxiousCount, calmCount}]
  Map<String, int> _computeDistribution(List<Map<String, dynamic>> data) {
    final result = <String, int>{
      'HAPPY': 0,
      'SAD': 0,
      'ANGRY': 0,
      'ANXIOUS': 0,
      'CALM': 0,
    };
    for (final entry in data) {
      result['HAPPY'] = result['HAPPY']! + ((entry['happyCount'] as num?)?.toInt() ?? 0);
      result['SAD'] = result['SAD']! + ((entry['sadCount'] as num?)?.toInt() ?? 0);
      result['ANGRY'] = result['ANGRY']! + ((entry['angryCount'] as num?)?.toInt() ?? 0);
      result['ANXIOUS'] = result['ANXIOUS']! + ((entry['anxiousCount'] as num?)?.toInt() ?? 0);
      result['CALM'] = result['CALM']! + ((entry['calmCount'] as num?)?.toInt() ?? 0);
    }
    result.removeWhere((_, v) => v == 0);
    return result;
  }

  Map<String, Map<String, int>> _computeDailyTrends(List<Map<String, dynamic>> data) {
    final result = <String, Map<String, int>>{};
    for (final entry in data) {
      final date = entry['date']?.toString() ?? '';
      result[date] = {
        'HAPPY': (entry['happyCount'] as num?)?.toInt() ?? 0,
        'SAD': (entry['sadCount'] as num?)?.toInt() ?? 0,
        'ANGRY': (entry['angryCount'] as num?)?.toInt() ?? 0,
        'ANXIOUS': (entry['anxiousCount'] as num?)?.toInt() ?? 0,
        'CALM': (entry['calmCount'] as num?)?.toInt() ?? 0,
      };
    }
    return result;
  }
}
