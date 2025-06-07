import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controllers/auth/auth_controller.dart';
import 'package:tiktok_clone/controllers/home/video_controller.dart';
import 'package:tiktok_clone/models/home/video_model.dart';
import 'package:tiktok_clone/repositories/home/video_repository.dart';
import 'package:video_player/video_player.dart';

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
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.file(File(widget.video.url))
      ..addListener(() {
        if (mounted) setState(() {});
      });

    // The URL can be local if it is a file path.
    // For local files, use VideoPlayerController.file instead of .network.
    // Example:
    // _controller = VideoPlayerController.file(File(widget.video.url))
    //   ..addListener(() {
    //     if (mounted) setState(() {});
    //   });

    // If widget.video.url is a local file path:
    // import 'dart:io'; at the top if not already imported.

    // Otherwise, for network URLs, keep using VideoPlayerController.network.
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
      print('Error initializing video: $e');
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
