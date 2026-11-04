import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/features/patient/doctors/data/repo/favorites_repository.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSupabaseClient mockClient;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockClient = MockSupabaseClient();
  });

  group('FavoritesRepository - User Isolation & Persistence', () {
    test('guest user fallback when no user is signed in', () {
      final repo = FavoritesRepository(client: mockClient);
      expect(repo.currentUserId, 'guest_user');
      expect(repo.favoriteDoctorIds, isEmpty);
    });

    test('custom userId via initialUserId or onUserChanged', () {
      final repo = FavoritesRepository(
        client: mockClient,
        initialUserId: 'user_123',
      );
      expect(repo.currentUserId, 'user_123');

      repo.onUserChanged(newUserId: 'user_456');
      expect(repo.currentUserId, 'user_456');

      repo.onUserChanged(newUserId: null);
      expect(repo.currentUserId, 'guest_user');
    });

    test('per-user isolation: user A favorites do not leak to user B', () async {
      final repo = FavoritesRepository(
        client: mockClient,
        initialUserId: 'user_A',
      );

      // User A favorites doc_1
      await repo.toggleFavorite('doc_1');
      expect(repo.isFavorite('doc_1'), isTrue);
      expect(repo.favoriteDoctorIds, contains('doc_1'));

      // Switch to User B
      repo.onUserChanged(newUserId: 'user_B');
      expect(repo.isFavorite('doc_1'), isFalse);
      expect(repo.favoriteDoctorIds, isEmpty);

      // User B favorites doc_2
      await repo.toggleFavorite('doc_2');
      expect(repo.isFavorite('doc_2'), isTrue);
      expect(repo.isFavorite('doc_1'), isFalse);

      // Switch back to User A
      repo.onUserChanged(newUserId: 'user_A');
      expect(repo.isFavorite('doc_1'), isTrue);
      expect(repo.isFavorite('doc_2'), isFalse);
    });

    test('local persistence: restores favorites from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'doctor_hunt_user_favorites_user_saved': ['doc_10', 'doc_20'],
      });

      final repo = FavoritesRepository(
        client: mockClient,
        initialUserId: 'user_saved',
      );

      final favs = await repo.getFavorites();
      expect(favs, containsAll({'doc_10', 'doc_20'}));
      expect(repo.isFavorite('doc_10'), isTrue);
      expect(repo.isFavorite('doc_20'), isTrue);
      expect(repo.isFavorite('doc_30'), isFalse);
    });

    test('toggleFavorite toggles state on and off, updating local storage', () async {
      final repo = FavoritesRepository(
        client: mockClient,
        initialUserId: 'test_user',
      );

      // 1. Initially false
      expect(repo.isFavorite('doc_99'), isFalse);

      // 2. Toggle to true
      final res1 = await repo.toggleFavorite('doc_99');
      expect(res1, isTrue);
      expect(repo.isFavorite('doc_99'), isTrue);
      expect(repo.favoriteDoctorIds, contains('doc_99'));

      // 3. Toggle back to false
      final res2 = await repo.toggleFavorite('doc_99');
      expect(res2, isFalse);
      expect(repo.isFavorite('doc_99'), isFalse);
      expect(repo.favoriteDoctorIds, isNot(contains('doc_99')));
    });

    test('removeFavorite removes doctor across all user caches when doctor is deleted', () async {
      final repo = FavoritesRepository(client: mockClient);

      // User 1 favorites doc_del
      await repo.toggleFavorite('doc_del', userId: 'u1');
      // User 2 favorites doc_del
      await repo.toggleFavorite('doc_del', userId: 'u2');

      expect(repo.isFavorite('doc_del', userId: 'u1'), isTrue);
      expect(repo.isFavorite('doc_del', userId: 'u2'), isTrue);

      // Doctor is deleted globally
      await repo.removeFavorite('doc_del');

      expect(repo.isFavorite('doc_del', userId: 'u1'), isFalse);
      expect(repo.isFavorite('doc_del', userId: 'u2'), isFalse);
    });

    test('clearMemoryCache empties in-memory cache', () async {
      final repo = FavoritesRepository(
        client: mockClient,
        initialUserId: 'cache_user',
      );

      await repo.toggleFavorite('doc_1');
      expect(repo.favoriteDoctorIds, contains('doc_1'));

      repo.clearMemoryCache();
      expect(repo.favoriteDoctorIds, isEmpty);
    });

    test('edge case: empty doctor ID does nothing and returns false', () async {
      final repo = FavoritesRepository(client: mockClient);
      expect(repo.isFavorite(''), isFalse);

      final res = await repo.toggleFavorite('');
      expect(res, isFalse);
      expect(repo.favoriteDoctorIds, isEmpty);
    });
  });
}

