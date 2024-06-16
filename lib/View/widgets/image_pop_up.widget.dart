import 'package:clicks_outlet/FirebaseService/image_collection.service.dart';
import 'package:clicks_outlet/FirebaseService/user_collection.service.dart';
import 'package:clicks_outlet/main.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:clicks_outlet/model/user_details.dart';
import 'package:clicks_outlet/utils/floating_msg.util.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatefulWidget {
  final String? imageUrl;
  final String? imageId;

  ImageDialog({super.key, required this.imageUrl, required this.imageId});

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  bool isLiked = false;

  UserCollectionService userCollectionService = UserCollectionService();

  ImageCollectionService imageCollectionService = ImageCollectionService();

  UserDetailsModel userDetailsModel = UserDetailsModel.fromSP();

  void fetch() async {
    ImageModel? imageModel =
        await imageCollectionService.getDocumentById(widget.imageId!);
    if (imageModel!.likedBy != null &&
        imageModel.likedBy!.contains(userDetailsModel.id)) {
      isLiked = true;
    }
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth,
            height: MediaQuery.sizeOf(context).height * 0.70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl ?? config.imagePreviewUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: isLiked
                            ? const Icon(Icons.favorite_sharp)
                            : const Icon(Icons.favorite_border),
                        onPressed: () async {
                          // Add your like logic here.
                          if (isLiked) {
                            await removeLike(userDetailsModel.id,
                                widget.imageId, widget.imageUrl);
                            setState(() {
                              isLiked = false;
                            });
                          } else {
                            await addLike(userDetailsModel.id, widget.imageId,
                                widget.imageUrl);
                            setState(() {
                              isLiked = true;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () async {
                          // Add your download logic here.

                          try {
                            await ImageCollectionService()
                                .downloadAndSaveImage(widget.imageUrl!);
                            FloatingMsg.show(
                                context: context,
                                msg: "Image Saved!",
                                msgType: MsgType.success);
                          } catch (e) {
                            FloatingMsg.show(
                                context: context,
                                msg: e.toString(),
                                msgType: MsgType.error);
                          }
                        },
                      ),
                      /*  IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // Add your share logic here.
                        },
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> addLike(
      String? userId, String? imageId, String? imageUrl) async {
    if (imageId != null && userId != null) {
      ImageModel? imageModel =
          await imageCollectionService.getDocumentById(imageId);
      if (imageModel != null) {
        int? likes = imageModel.likes;
        likes ??= 0;
        List<String?>? likedBy = imageModel.likedBy;
        List<String?> updatedLikedBy = likedBy?.toList() ?? [];
        updatedLikedBy.add(userId);
        ImageModel imageModel2 = ImageModel(
            url: imageUrl!,
            userId: imageModel.userId,
            caption: imageModel.caption,
            tags: imageModel.tags,
            userName: imageModel.userName,
            likes: likes + 1,
            likedBy: updatedLikedBy,
            imageId: imageId);
        await imageCollectionService.updateImageDetails(imageModel2);
        return true;
      }
    }
    return false;
  }

  Future<bool> removeLike(
      String? userId, String? imageId, String? imageUrl) async {
    if (imageId != null && userId != null) {
      ImageModel? imageModel =
          await imageCollectionService.getDocumentById(imageId);
      if (imageModel != null) {
        int? likes = imageModel.likes;
        List<String?>? likedBy = imageModel.likedBy;
        List<String?> updatedLikedBy = likedBy?.toList() ?? [];
        if (likedBy != null && likedBy.isNotEmpty && likedBy.contains(userId)) {
          updatedLikedBy.remove(userId);
        }
        ImageModel imageModel2 = ImageModel(
            url: imageUrl!,
            userId: imageModel.userId,
            caption: imageModel.caption,
            tags: imageModel.tags,
            userName: imageModel.userName,
            likes: likes == null ? 0 : likes - 1,
            likedBy: updatedLikedBy,
            imageId: imageId);
        await imageCollectionService.updateImageDetails(imageModel2);
        return true;
      }
    }
    return false;
  }
}
