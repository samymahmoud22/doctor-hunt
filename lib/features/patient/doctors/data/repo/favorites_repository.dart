import 'package:doctor_hunt/core/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesRepository {
  final SupabaseClient? client;
  SharedPreferences? prefs;
  String? _overrideUserId;

  // In-memory cache keyed by userId -> Set of doctor IDs
  final Map<String, Set<String>> _memoryCache = {};

  FavoritesRepository({
    this.client,
    this.prefs,
    String? initialUserId,
  }) : _overrideUserId = initialUserId;

  SupabaseClient? _getClient() {
    try {
      return client ?? Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Future<SharedPreferences?> _getPrefs() async {
    if (prefs != null) return prefs;
    try {
      prefs = await SharedPreferences.getInstance().timeout(
        const Duration(milliseconds: 300),
        onTimeout: () => throw Exception('SharedPreferences timeout'),
      );
      return prefs;
    } catch (e) {
      AppLogger.warning('SharedPreferences.getInstance: $e');
      return null;
    }
  }

  /// Returns the current user's ID or fallback to 'guest_user'
  String get currentUserId {
    if (_overrideUserId != null && _overrideUserId!.isNotEmpty) {
      return _overrideUserId!;
    }
    try {
      final client = _getClient();
      final user = client?.auth.currentUser;
      if (user != null && user.id.isNotEmpty) {
        return user.id;
      }
    } catch (_) {}
    return 'guest_user';
  }

  String _prefsKey(String userId) => 'doctor_hunt_user_favorites_$userId';

  /// Called when the authenticated user changes (login/logout)
  void onUserChanged({String? newUserId}) {
    _overrideUserId = newUserId;
  }

  /// Synchronous getter for favorite IDs for the current user (from memory cache)
  Set<String> get favoriteDoctorIds {
    final uid = currentUserId;
    return Set.unmodifiable(_memoryCache[uid] ?? <String>{});
  }

  /// Synchronous check if a doctor is favorited (from memory cache)
  bool isFavorite(String doctorId, {String? userId}) {
    if (doctorId.isEmpty) return false;
    final uid = userId ?? currentUserId;
    return _memoryCache[uid]?.contains(doctorId) ?? false;
  }

  /// Asynchronous check that ensures favorites are loaded from storage first
  Future<bool> isFavoriteAsync(String doctorId, {String? userId}) async {
    if (doctorId.isEmpty) return false;
    final uid = userId ?? currentUserId;
    if (!_memoryCache.containsKey(uid)) {
      await getFavorites(userId: uid);
    }
    return isFavorite(doctorId, userId: uid);
  }

  /// Fetches favorites for a user, loading from SharedPreferences first (offline-first),
  /// and syncing with Supabase user_favorites table when available.
  Future<Set<String>> getFavorites({String? userId, bool forceRefresh = false}) async {
    final uid = userId ?? currentUserId;

    if (!forceRefresh && _memoryCache.containsKey(uid) && _memoryCache[uid]!.isNotEmpty) {
      return Set.unmodifiable(_memoryCache[uid]!);
    }

    // 1. Read from SharedPreferences
    final prefs = await _getPrefs();
    final localList = prefs?.getStringList(_prefsKey(uid));
    if (localList != null) {
      _memoryCache[uid] = localList.toSet();
    } else {
      _memoryCache[uid] ??= <String>{};
    }

    // 2. Sync with Supabase user_favorites table
    try {
      final client = _getClient();
      if (client != null) {
        final response = await client
            .from('user_favorites')
            .select('doctor_id')
            .eq('user_id', uid);

        final records = response as List<dynamic>;
        final remoteSet = records
            .map((e) => (e['doctor_id'] ?? '').toString())
            .where((id) => id.isNotEmpty)
            .toSet();

        // Merge local and remote
        final merged = <String>{..._memoryCache[uid]!, ...remoteSet};
        _memoryCache[uid] = merged;
        await prefs?.setStringList(_prefsKey(uid), merged.toList());
      }
    } catch (e) {
      AppLogger.debug('Supabase getFavorites (local fallback): $e');
    }

    return Set.unmodifiable(_memoryCache[uid] ?? <String>{});
  }

  /// Toggles favorite status for a doctor.
  /// Updates local memory cache, persists to SharedPreferences, and syncs to Supabase.
  /// Returns `true` if doctor is now favorite, `false` if removed.
  Future<bool> toggleFavorite(String doctorId, {String? userId}) async {
    if (doctorId.isEmpty) return false;
    final uid = userId ?? currentUserId;

    _memoryCache[uid] ??= <String>{};
    final currentSet = _memoryCache[uid]!;
    final isAlreadyFav = currentSet.contains(doctorId);

    if (isAlreadyFav) {
      currentSet.remove(doctorId);
    } else {
      currentSet.add(doctorId);
    }

    try {
      final p = await _getPrefs();
      await p?.setStringList(_prefsKey(uid), currentSet.toList());
    } catch (e) {
      AppLogger.warning('SharedPreferences save favorite: $e');
    }

    try {
      final c = _getClient();
      if (c != null) {
        if (isAlreadyFav) {
          await c.from('user_favorites').delete().match({
            'user_id': uid,
            'doctor_id': doctorId,
          });
        } else {
          await c.from('user_favorites').upsert({
            'user_id': uid,
            'doctor_id': doctorId,
          });
        }
      }
    } catch (e) {
      AppLogger.debug('Supabase toggle favorite: $e');
    }

    return !isAlreadyFav;
  }

  /// Removes a doctor from all local caches and storage (e.g. when a doctor is deleted)
  Future<void> removeFavorite(String doctorId) async {
    for (final uid in _memoryCache.keys) {
      _memoryCache[uid]?.remove(doctorId);
    }

    try {
      final p = await _getPrefs();
      for (final uid in _memoryCache.keys) {
        if (_memoryCache[uid] != null) {
          await p?.setStringList(_prefsKey(uid), _memoryCache[uid]!.toList());
        }
      }
    } catch (e) {
      AppLogger.warning('SharedPreferences removeFavorite: $e');
    }

    try {
      final c = _getClient();
      await c?.from('user_favorites').delete().eq('doctor_id', doctorId);
    } catch (e) {
      AppLogger.debug('Supabase removeFavorite: $e');
    }
  }

  /// Clears cache in memory (useful for testing or full reset)
  void clearMemoryCache() {
    _memoryCache.clear();
  }
}
