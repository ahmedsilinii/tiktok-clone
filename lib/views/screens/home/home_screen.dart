import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controllers/auth/auth_controller.dart';
import 'package:tiktok_clone/controllers/home/video_controller.dart';
import 'package:tiktok_clone/models/home/video_model.dart';
import 'package:tiktok_clone/repositories/home/video_repository.dart';
import 'package:video_player/video_player.dart';

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

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final Video video;

  const VideoPlayerWidget({super.key, required this.video});

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final cachedFile = await ref
          .read(videoRepositoryProvider)
          .cacheVideo(widget.video.url);

      _controller = VideoPlayerController.file(cachedFile)
        ..initialize().then((_) {
          setState(() => _isLoading = false);
          _controller.play();
          _controller.setLooping(true);
        });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  widget.video.likedBy.contains(
                        ref.read(authControllerProvider).value?.uid,
                      )
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed:
                    () => ref
                        .read(videoControllerProvider.notifier)
                        .likeVideo(
                          widget.video.id,
                          ref.read(authControllerProvider).value!.uid,
                        ),
              ),
              Text('${widget.video.likes}'),
            ],
          ),
        ),
      ],
    );
  }
}
