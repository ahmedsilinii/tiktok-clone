import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controllers/home/video_controller.dart';
import 'package:tiktok_clone/views/widgets/local_video_player_widget.dart';

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
      appBar: AppBar(
        title: Text('Video Feed App'),
      ),
      body: videos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (videoList) => PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: videoList.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                // preCacheVideos(videoList, index);
              },
              itemBuilder: (context, index) {
                return LocalVideoPlayer(assetPath: videoList[index].url);
              },
            ),
      ),
    );
  }


}
