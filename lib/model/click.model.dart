import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String url;
  final String? caption;
  final List<String?> tags;
  final String? userId;
  final String? userName;
  final int? likes;
  final String? imageId;
  final List<String?>? likedBy;

  ImageModel({
    required this.url,
    required this.userId,
    this.userName,
    this.caption,
    this.tags = const [],
    this.likes = 0,
    this.imageId,
    this.likedBy,
  });

  static ImageModel fromMap(
      {required Map<dynamic, dynamic>? map, String? imageId}) {
    return ImageModel(
        url: map?['url'],
        caption: map?['caption'],
        userId: map?['user_id'],
        userName: map?['user_name'],
        likes: map?['likes'],
        imageId: imageId /*,
        likedBy: map?['likedBy']*/
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'caption': caption,
      'tags': tags,
      'user_id': userId,
      'user_name': userName,
      'likes': likes,
      'likedBy': likedBy
    };
  }

  static List<ImageModel> getImagesList(
      {required List<QueryDocumentSnapshot<Map<String, dynamic>>>? docsList}) {
    List<ImageModel> list = [];
    if (docsList != null && docsList.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> dataObj in docsList) {
        list.add(ImageModel.fromMap(map: dataObj.data(), imageId: dataObj.id));
      }
    }
    return list;
  }
}
