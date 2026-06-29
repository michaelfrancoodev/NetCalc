import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/local_storage.dart';
import '../models/history_model.dart';
import '../theme/app_theme.dart';
import '../theme/settings_manager.dart';
import 'calculator_screen.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await LocalStorage.loadHistory();
    if (mounted) {
      setState(() {
        _entries = data.toList();
        _loading = false;
      });
    }
  }

  Future<void> _deleteAt(int index) async {
    if (SettingsManager().haptic) HapticFeedback.lightImpact();
    await LocalStorage.removeHistoryAt(index);
    if (!mounted) return;
    setState(() => _entries.removeAt(index));
  }

  Future<void> _clearAll() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.textDark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Clear History',
            style: TextStyle(color: textColor)),
        content: const Text('Delete all history entries?',
            style: TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel',
                  style: TextStyle(color: AppTheme.textGrey))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete All',
                  style: TextStyle(color: AppTheme.neonPink))),
        ],
      ),
    );
    if (confirmed == true) {
      await LocalStorage.clearHistory();
      if (!mounted) return;
      setState(() => _entries = []);
    }
  }

  void _reuseEntry(HistoryEntry e) {
    if (SettingsManager().haptic) HapticFeedback.lightImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CalculatorScreen(initialExpression: e.expression),
      ),
    );
  }

  String _timeLabel(DateTime dt) {
    final now  = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1)   return '${diff.inMinutes}m ago';
    if (diff.inDays < 1)    return '${diff.inHours}h ago';
    if (diff.inDays < 7)    return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final manager = SettingsManager();

    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : AppTheme.textDark;
        final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            decoration: BoxDecoration(gradient: isDark ? null : AppTheme.mainBackground),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              color: textColor, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text('History',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: textColor)),
                        const Spacer(),
                        if (_entries.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.delete_sweep_rounded,
                                color: AppTheme.neonPink, size: 22),
                            onPressed: _clearAll,
                            tooltip: 'Clear all',
                          ),
                      ],
                    ),
                  ),
                  Divider(color: isDark ? Colors.white10 : Colors.black12, height: 1),

                  if (!_loading && _entries.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Row(
                        children: [
                          const Icon(Icons.swipe_left_rounded,
                              color: AppTheme.textGrey, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Swipe left to delete  •  Tap to reuse  •  Long-press for detail',
                            style: TextStyle(
                                fontSize: 11,
                                color: (isDark ? Colors.white : Colors.black).withOpacity(0.3)),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: _loading
                        ? Center(
                            child: CircularProgressIndicator(
                                color: manager.accentColor, strokeWidth: 2))
                        : _entries.isEmpty
                            ? _buildEmpty(isDark)
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                itemCount: _entries.length,
                                itemBuilder: (ctx, i) =>
                                    _buildCard(_entries[i], i, manager.accentColor, cardColor, textColor),
                              ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty(bool isDark) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded,
                size: 60, color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
            const SizedBox(height: 14),
            Text('No history yet',
                style: TextStyle(
                    fontSize: 16,
                    color: (isDark ? Colors.white : Colors.black).withOpacity(0.4))),
            const SizedBox(height: 6),
            Text('Calculations will appear here.',
                style: TextStyle(
                    fontSize: 12,
                    color: (isDark ? Colors.white : Colors.black).withOpacity(0.3))),
          ],
        ),
      );

  Widget _buildCard(HistoryEntry e, int index, Color accent, Color cardColor, Color textColor) {
    return Dismissible(
      key: ValueKey('hist_${e.expression}_${e.timestamp.millisecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.neonPink.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: AppTheme.neonPink, size: 22),
      ),
      onDismissed: (_) => _deleteAt(index),
      child: GestureDetector(
        onTap: () => _reuseEntry(e),
        onLongPress: () {
          if (SettingsManager().haptic) HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                expression: e.expression,
                result: e.result,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.expression,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textGrey,
                            fontWeight: FontWeight.w400),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('= ${e.result}',
                        style: TextStyle(
                            fontSize: 20,
                            color: textColor,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(_timeLabel(e.timestamp),
                  style: TextStyle(
                      fontSize: 11,
                      color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(0.3))),
            ],
          ),
        ),
      ),
    );
  }
}
