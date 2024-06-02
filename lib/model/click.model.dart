import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String? url;
  final String? caption;
  final List<String?> tags;
  final String? userId;
  final String? userName;
  final int? likes;

  ImageModel(
      {required this.url,
      required this.userId,
      this.userName,
      this.caption,
      this.tags = const [],
      this.likes});

  static ImageModel fromMap({required Map<dynamic, dynamic>? map}) {
    return ImageModel(
      url: map?['url'],
      caption: map?['caption'],
      userId: map?['user_id'],
      userName: map?['user_name'],
      likes: map?['likes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'caption': caption,
      'tags': tags,
      'user_id': userId,
      'user_name': userName,
      'likes': likes
    };
  }

  static List<ImageModel> getImagesList(
      {required List<QueryDocumentSnapshot>? docsList}) {
    List<ImageModel> list = [];
    if (docsList != null && docsList.isNotEmpty) {
      docsList.forEach((dataObj) {
        list.add(ImageModel.fromMap(map: dataObj.data() as Map));
      });
    }
    return list;
  }
}
