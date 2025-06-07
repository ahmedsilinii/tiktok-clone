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
  int _selectedTab = 0;

  void _onTabTapped(int index) {
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
    } else {
      setState(() {
        _selectedTab = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(videoControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Video Feed App')),
      body: videos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data:
            (videoList) => PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: videoList.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                ref
                    .read(videoControllerProvider.notifier)
                    .preCacheVideos(videoList, index);
              },
              itemBuilder: (context, index) {
                final video = videoList[index];
                return Stack(
                  children: [
                    LocalVideoPlayer(assetPath: video.url),
                    Positioned(
                      right: 16,
                      bottom: 100,
                      child: Column(
                        children: [
                          Icon(Icons.thumb_up, color: Colors.white, size: 32),
                          Text(
                            '${video.likes}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _onTabTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text(
          'This is the Profile Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
