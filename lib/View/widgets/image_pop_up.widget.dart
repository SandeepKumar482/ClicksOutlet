import 'package:apex_infinity/utils/snack_bar.util.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:flutter/material.dart';


class ImageDialog extends StatelessWidget {
  final ImageModel imageModel;

  const ImageDialog({super.key, required this.imageModel});

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
                image: NetworkImage(imageModel.imageUrl!),
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
                        icon: const Icon(Icons.favorite_sharp),
                        onPressed: () async {
                          // Add your like logic here.
                          // TODO : Like/Unlike
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () async {
                          // Add your download logic here.
                          try {
                            // await ImageCollectionService()
                            //     .downloadAndSaveImage(imageModel.imageUrl);
                            AxSnackBar(
                              context: context,
                              message: "Image Saved!",
                              msgType: AxSnackBarMsgType.error
                            ).show();
                          } catch (e) {
                            AxSnackBar(
                              context: context,
                              message: e.toString(),
                              msgType: AxSnackBarMsgType.error
                            ).show();
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
