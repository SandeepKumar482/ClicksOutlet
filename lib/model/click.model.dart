class ClickModel {
  final String? url;
  final String? caption;
  final List<String?> tags;
  final String? userId;
  final int? likes;

  ClickModel(
      {required this.url,
      required this.userId,
      this.caption,
      this.tags = const [],
      this.likes});

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'caption': caption,
      'tags': tags,
      'user_id': userId,
      'likes': likes
    };
  }
}
