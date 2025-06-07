import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tiktok_clone/core/providers/firebase_providers.dart';
import 'package:tiktok_clone/models/home/video_model.dart';

class VideoRepository {
  final FirebaseFirestore _firestore;
  final DefaultCacheManager _cacheManager;

  VideoRepository(this._firestore, this._cacheManager);

  Stream<List<Video>> getVideos() {
    return _firestore
        .collection('videos')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Video.fromMap(doc.data(), doc.id))
                  .toList(),
        );
    // return Stream.value(_localVideos);
  }

  Future<List<File>> getCachedVideos(List<String> urls) async {
    List<File> files = [];
    for (final url in urls) {
      final fileInfo = await _cacheManager.getFileFromCache(url);
      if (fileInfo != null && fileInfo.file.existsSync()) {
        files.add(fileInfo.file);
      }
    }
    return files;
  }

  Future<File?> cacheVideo(String url) async {
    if (url.startsWith('assets/')) return null;
    return await _cacheManager.getSingleFile(url);
  }

  // Example local video list for testing/demo purposes.
  final List<Video> _localVideos = [
    Video(
      id: '1',
      url: 'assets/video1.mp4',
      title: 'Funny Cat',
      creatorId: 'o45TDWXD33OpIL7smvIc4NJH3CB3',
      createdAt: DateTime.now(),
    ),
    Video(
      id: '2',
      url: 'assets/video2.mp4',
      title: 'Dancing Dog',
      creatorId: 'o45TDWXD33OpIL7smvIc4NJH3CB3',
      createdAt: DateTime.now(),
    ),
    Video(
      id: '3',
      url: 'assets/video3.mp4',
      title: 'Epic Fail',
      creatorId: 'o45TDWXD33OpIL7smvIc4NJH3CB3',
      createdAt: DateTime.now(),
    ),
    Video(
      id: '4',
      url: 'assets/video4.mp4',
      title: 'Amazing Nature',
      creatorId: 'o45TDWXD33OpIL7smvIc4NJH3CB3',
      createdAt: DateTime.now(),
    ),
    Video(
      id: '5',
      url: 'assets/video5.mp4',
      title: 'Cooking Show',
      creatorId: 'o45TDWXD33OpIL7smvIc4NJH3CB3',
      createdAt: DateTime.now(),
    ),
  ];

  List<Video> getLocalVideos() => _localVideos;

  Future<void> toggleLike({
    required String videoId,
    required String userId,
    required List<String> currentLikedBy,
    required int currentLikes,
  }) async {
    final isLiked = currentLikedBy.contains(userId);

    await _firestore.collection('videos').doc(videoId).update({
      'likes': isLiked ? currentLikes - 1 : currentLikes + 1,
      'likedBy':
          isLiked
              ? FieldValue.arrayRemove([userId])
              : FieldValue.arrayUnion([userId]),
    });
  }
}

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepository(ref.read(firestoreProvider), DefaultCacheManager());
});
