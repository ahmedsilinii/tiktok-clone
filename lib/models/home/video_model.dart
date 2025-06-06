import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String url; //file path - assetPath or network URL
  final String title;
  int likes;
  final List<String> likedBy;
  final String creatorId;
  final DateTime createdAt;

  Video({
    required this.id,
    required this.url,
    required this.title,
    this.likes = 0,
    this.likedBy = const [],
    required this.creatorId,
    required this.createdAt,
  });

  factory Video.fromMap(Map<String, dynamic> map, String id) {
    return Video(
      id: id,
      url: map['url'],
      title: map['title'],
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      creatorId: map['creatorId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
