import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/emotion_record.dart';
import '../providers/auth_provider.dart';
import '../providers/emotion_provider.dart';
import '../utils/constants.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<EmotionProvider>().refreshMyEmotions();
    });
  }

  Future<void> _loadHistory() async {
    await context.read<EmotionProvider>().refreshMyEmotions();
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Log out')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<EmotionProvider>().clearMyEmotions();
      await context.read<AuthProvider>().logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
        );
      }
    }
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('MMM d, yyyy  HH:mm').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final emotionProvider = context.watch<EmotionProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final username = auth.currentUser?.username ?? 'User';
    final history = emotionProvider.myEmotions;
    final loading = emotionProvider.isLoadingMyEmotions;
    final error = emotionProvider.myEmotionsError;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _loadHistory,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User info header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      username[0].toUpperCase(),
                      style: TextStyle(fontSize: 32, color: colorScheme.onPrimaryContainer),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(username, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    '${history.length} emotion${history.length == 1 ? '' : 's'} shared',
                    style: TextStyle(color: colorScheme.outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Emotion history
            Text('Your Emotions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            if (loading)
              const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
            else if (error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 8),
                      Text('Failed to load history',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(error,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: colorScheme.outline)),
                      const SizedBox(height: 12),
                      FilledButton.tonal(onPressed: _loadHistory, child: const Text('Retry')),
                    ],
                  ),
                ),
              )
            else if (history.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 48, color: colorScheme.outline),
                      const SizedBox(height: 8),
                      Text('No emotions recorded yet', style: TextStyle(color: colorScheme.outline)),
                    ],
                  ),
                ),
              )
            else
              ...history.map((record) => _buildRecordCard(record, colorScheme)),

            const SizedBox(height: 32),

            // Logout button
            OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Log Out', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(EmotionRecord record, ColorScheme colorScheme) {
    final emoji = AppConstants.emotionEmojis[record.emotionType] ?? '❓';
    final label = AppConstants.emotionLabels[record.emotionType] ?? record.emotionType;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Text(emoji, style: const TextStyle(fontSize: 28)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (record.note != null && record.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(record.note!, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            const SizedBox(height: 4),
            Text(_formatDate(record.createdAt),
                style: TextStyle(fontSize: 12, color: colorScheme.outline)),
          ],
        ),
      ),
    );
  }
}
