class ClickModel {
  final String? url;
  final String? caption;
  final List<String?> tags;
  final String? userId;
  final int? likes;

  ClickModel(
      {required this.url,
      required this.caption,
      required this.tags,
      required this.userId,
      required this.likes});
}
