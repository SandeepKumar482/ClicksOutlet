import 'package:apex_infinity/utils/comman.uitls.dart';

import '../main.dart';

class ImageModel {
  final String? mid;
  final String? uid;
  final String? labelName;
  final String? userName;
  final String? imageUrl;
  final String? imageName;
  final double? width;
  final double? height;
  final String? captions;
  final List<String?> tags;
  final int? likes;

  ImageModel({
    this.mid,
    this.uid,
    this.labelName,
    this.userName,
    required this.imageUrl,
    this.imageName,
    this.width,
    this.height,
    this.captions,
    this.tags = const [],
    this.likes = 0,
  });

  factory ImageModel.fromMap({required dynamic map}) {
    if(map is Map) {
     return ImageModel(
       mid: map['img_id'].toString(),
       uid: map['uid'].toString(),
       labelName: map['label_name'],
       userName: map['user_name'],
       imageName: map['image_name'],
       imageUrl: map['image_url'],
       width: map['width']?.toDouble(),
       height: map['height']?.toDouble(),
       captions: map['caption'],
       tags: getStringList(list: map['tags']),
       likes: map['likes']
     ) ;
    } else {
      return ImageModel(
        imageUrl: config.previewImageUrl
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
    };
  }

  static List<ImageModel> getImagesList({required dynamic list}) {
    List<ImageModel> imageList = [];
    if (list is List) {
      for (var data in list) {
        imageList.add(ImageModel.fromMap(map: data));
      }
    }

    return imageList;
  }
}
