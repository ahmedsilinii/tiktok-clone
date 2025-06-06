import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/core/providers/firebase_providers.dart';
import 'package:tiktok_clone/models/home/video_model.dart';
import 'package:tiktok_clone/repositories/home/video_repository.dart';

final videoControllerProvider =
    StreamNotifierProvider<VideoController, List<Video>>(() {
      return VideoController();
    });

class VideoController extends StreamNotifier<List<Video>> {
  @override
  Stream<List<Video>> build() {
    return ref.read(videoRepositoryProvider).getVideos();
  }

  Future<void> likeVideo(String videoId, String userId) async {
    try {
      await ref
          .read(firestoreProvider)
          .collection('videos')
          .doc(videoId)
          .update({
            'likes': FieldValue.increment(1),
            'likedBy': FieldValue.arrayUnion([userId]),
          });
    } catch (e) {
      throw Exception('Failed to like video: $e');
    }
  }
}
