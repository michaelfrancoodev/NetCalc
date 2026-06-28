import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/local_storage.dart';
import '../models/favorite_model.dart';
import '../theme/app_theme.dart';
import 'calculator_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final void Function(String expression)? onReuse;
  const FavoritesScreen({super.key, this.onReuse});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await LocalStorage.loadFavorites();
    if (mounted) {
      setState(() {
        _entries = data.toList();
        _loading = false;
      });
    }
  }

  Future<void> _deleteAt(int index) async {
    await LocalStorage.removeFavoriteAt(index);
    setState(() => _entries.removeAt(index));
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Clear Favorites',
            style: TextStyle(color: AppTheme.textDark)),
        content: const Text('Delete all saved favorites?',
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
      await LocalStorage.clearFavorites();
      setState(() => _entries = []);
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainBackground),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.textDark, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Favorites',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark)),
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
              const Divider(color: Colors.black12, height: 1),

              if (!_loading && _entries.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.swipe_left_rounded,
                          color: AppTheme.textGrey, size: 14),
                      const SizedBox(width: 6),
                      Text('Swipe left to delete  •  Tap to reuse',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black.withOpacity(0.3))),
                    ],
                  ),
                ),

              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.neonCyan, strokeWidth: 2))
                    : _entries.isEmpty
                        ? _buildEmpty()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            itemCount: _entries.length,
                            itemBuilder: (ctx, i) {
                              final e = _entries[i];
                              return _buildCard(e, i);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border_rounded,
              size: 60, color: Colors.black.withOpacity(0.1)),
          const SizedBox(height: 14),
          Text('No favorites yet',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.4))),
          const SizedBox(height: 6),
          Text('Tap the star icon on the calculator\nto save a result.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.3),
                  height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildCard(FavoriteEntry e, int index) {
    return Dismissible(
      key: ValueKey('${e.expression}_${e.savedAt.millisecondsSinceEpoch}'),
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
      onDismissed: (_) {
        HapticFeedback.lightImpact();
        _deleteAt(index);
      },
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (widget.onReuse != null) {
            widget.onReuse!(e.expression);
            Navigator.pop(context);
          } else {
            // Navigate to calculator and load the expression directly
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CalculatorScreen(initialExpression: e.expression),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Colors.black.withOpacity(0.05)),
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
              Icon(Icons.star_rounded,
                  color: AppTheme.neonCyan.withOpacity(0.7),
                  size: 18),
              const SizedBox(width: 12),
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
                        style: const TextStyle(
                            fontSize: 20,
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(_formatTime(e.savedAt),
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.black.withOpacity(0.3),
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
