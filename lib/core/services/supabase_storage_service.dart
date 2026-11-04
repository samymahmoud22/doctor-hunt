import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/core/utils/app_logger.dart';

class SupabaseStorageService {
  final SupabaseClient _client;

  static const String avatarsBucket = 'avatars';
  static const String doctorsBucket = 'doctors';

  SupabaseStorageService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Uploads binary data to the given Supabase Storage bucket
  Future<String?> uploadBytes({
    required String bucket,
    required String path,
    required Uint8List bytes,
    String? contentType,
  }) async {
    try {
      await _client.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: contentType ?? 'image/jpeg',
            ),
          );

      final publicUrl = _client.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } on StorageException catch (e) {
      AppLogger.error('Supabase StorageException on upload: ${e.message}', e);
      return null;
    } catch (e) {
      AppLogger.error('Supabase Storage general upload error: $e', e);
      return null;
    }
  }

  /// Gets the public URL for an asset in a bucket
  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  /// Uploads a doctor's avatar image
  Future<String?> uploadDoctorAvatar({
    required String doctorId,
    required Uint8List bytes,
    String extension = 'jpg',
  }) async {
    final fileName = 'doctor_$doctorId.$extension';
    return await uploadBytes(
      bucket: doctorsBucket,
      path: fileName,
      bytes: bytes,
      contentType: extension == 'png' ? 'image/png' : 'image/jpeg',
    );
  }

  /// Uploads a patient/user's avatar image
  Future<String?> uploadUserAvatar({
    required String userId,
    required Uint8List bytes,
    String extension = 'jpg',
  }) async {
    final fileName = 'user_$userId.$extension';
    return await uploadBytes(
      bucket: avatarsBucket,
      path: fileName,
      bytes: bytes,
      contentType: extension == 'png' ? 'image/png' : 'image/jpeg',
    );
  }

  /// Deletes an asset from a bucket
  Future<bool> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await _client.storage.from(bucket).remove([path]);
      return true;
    } catch (e) {
      AppLogger.error('Supabase Storage delete error: $e', e);
      return false;
    }
  }
}
