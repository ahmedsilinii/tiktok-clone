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
  }

  Future<File> cacheVideo(String url) async {
    return await _cacheManager.getSingleFile(url);
  }
}

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepository(ref.read(firestoreProvider), DefaultCacheManager());
});
