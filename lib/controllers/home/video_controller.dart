import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/models/home/video_model.dart';
import 'package:tiktok_clone/repositories/home/video_repository.dart';

final videoControllerProvider =
    StreamNotifierProvider<VideoController, List<Video>>(() {
      return VideoController();
    });

class VideoController extends StreamNotifier<List<Video>> {
  late final VideoRepository _repository = ref.read(videoRepositoryProvider);

  @override
  Stream<List<Video>> build() {
    return ref.read(videoRepositoryProvider).getVideos();
  }

  Future<void> toggleLike({
    required String userId,
    required List<String> currentLikedBy,
    required int currentLikes,
    required String videoId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.toggleLike(
        videoId: videoId,
        userId: userId,
        currentLikedBy: currentLikedBy,
        currentLikes: currentLikes,
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void preCacheVideos(List<Video> videos, int currentIndex) {
    final indicesToCache = [
      currentIndex - 1,
      currentIndex,
      currentIndex + 1,
    ].where((i) => i >= 0 && i < videos.length);

    for (final index in indicesToCache) {
      ref.read(videoRepositoryProvider).cacheVideo(videos[index].url);
    }
  }
}
