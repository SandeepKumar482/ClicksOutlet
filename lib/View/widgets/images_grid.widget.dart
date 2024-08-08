import 'package:apex_infinity/image/network_image.dart';
import 'package:clicks_outlet/View/widgets/image_pop_up.widget.dart';
import 'package:clicks_outlet/View/widgets/my_search_bar.widget.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImagesGrid extends StatelessWidget {
  final List<ImageModel> images;

  const ImagesGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      itemCount: images.length,
      padding: const EdgeInsets.symmetric(
          vertical: 30, horizontal: 10),
      // the number of columns
      crossAxisCount: 2,
      // vertical gap between two items
      mainAxisSpacing: 4,
      // horizontal gap between two items
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {

        ImageModel image = images[index];
        // Add null check
        return InkWell(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => ImageDialog(imageModel: image),
            );
          },
          child: Stack(children: [
            Card(
              key: ValueKey(image.imageUrl),
              child: AxNetworkImage(
                imageUrl: image.imageUrl,
              ),
            ),
            Positioned(
              bottom: 15,
              left: 10,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: MediaQuery.of(context)
                              .orientation ==
                              Orientation.portrait
                              ? MediaQuery.of(context)
                              .size
                              .width *
                              0.023
                              : MediaQuery.of(context)
                              .size
                              .height *
                              0.03,
                        ),
                        Text(
                          '${image.likes ?? 0} likes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.fontSize, // Use theme-based font size
                          ),
                        ),
                      ],
                    ),
                    Text(
                      image.labelName ?? "Anonymous",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context)
                            .orientation ==
                            Orientation.portrait
                            ? MediaQuery.of(context)
                            .size
                            .width *
                            0.025
                            : MediaQuery.of(context)
                            .size
                            .height *
                            0.03,
                      ),
                    ),
                  ]),
            ),
          ]),
        );
      },
    );
  }
}
