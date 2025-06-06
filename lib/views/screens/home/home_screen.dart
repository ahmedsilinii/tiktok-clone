import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controllers/home/video_controller.dart';
import 'package:tiktok_clone/models/home/video_model.dart';
import 'package:tiktok_clone/repositories/home/video_repository.dart';
import 'package:tiktok_clone/views/widgets/video_player_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(videoControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Video Feed App')),
      body: videos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data:
            (videos) => PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: videos.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _preCacheVideos(videos, index);
              },
              itemBuilder: (context, index) {
                return VideoPlayerWidget(video: videos[index]);
              },
            ),
      ),
    );
  }

  void _preCacheVideos(List<Video> videos, int currentIndex) {
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
