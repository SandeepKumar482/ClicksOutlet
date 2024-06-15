import 'package:clicks_outlet/FirebaseService/image_collection.service.dart';
import 'package:clicks_outlet/FirebaseService/user_collection.service.dart';
import 'package:clicks_outlet/main.dart';
import 'package:clicks_outlet/utils/floating_msg.util.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String? imageUrl;
  UserCollectionService userCollectionService = UserCollectionService();

  ImageDialog({super.key, required this.imageUrl});

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
                image: NetworkImage(imageUrl ?? config.imagePreviewUrl),
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
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          // Add your like logic here.
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () async {
                          // Add your download logic here.

                          try {
                            await ImageCollectionService()
                                .downloadAndSaveImage(imageUrl!);
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
}
