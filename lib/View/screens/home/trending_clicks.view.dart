import 'dart:math';

import 'package:clicksoutlet/FirebaseService/image_collection.service.dart';
import 'package:clicksoutlet/View/widgets/image_dto.widget.dart';
import 'package:clicksoutlet/View/widgets/image_pop_up.widget.dart';
import 'package:clicksoutlet/main.dart';
import 'package:clicksoutlet/model/click.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clicksoutlet/View/widgets/my_search_bar.widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TrendingClicks extends StatefulWidget {
  const TrendingClicks({Key? key}) : super(key: key);

  @override
  State<TrendingClicks> createState() => _TrendingClicksState();
}

class _TrendingClicksState extends State<TrendingClicks> {
  Future<List<ImageModel>>? getImages;

  void fetchImageList() {
    setState(() {
      getImages = ImageCollectionService().getImages();
    });
  }

  @override
  void initState() {
    fetchImageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          return fetchImageList();
        },
        child: FutureBuilder(
            future: getImages,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                List<ImageModel> imagesList = snapshot.data ?? [];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: MySearchBar(),
                    ),
                    Expanded(
                      child: MasonryGridView.count(
                        itemCount: imagesList.length,
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 10),
                        // the number of columns
                        crossAxisCount: 2,
                        // vertical gap between two items
                        mainAxisSpacing: 4,
                        // horizontal gap between two items
                        crossAxisSpacing: 4,
                        itemBuilder: (context, index) {
                          // display each  item with a card

                          ImageModel image = imagesList[index];
                          return InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => ImageDialog(
                                  imageUrl: image.url,
                                ),
                              );
                            },
                            child: Stack(children: [
                              Card(
                                // Give each item a random background color
                                color: Color.fromARGB(
                                    Random().nextInt(256),
                                    Random().nextInt(256),
                                    Random().nextInt(256),
                                    Random().nextInt(256)),
                                key: ValueKey(imagesList[index].url),
                                child: ImageDTO(
                                  imageUrl: image.url,
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                left: 10,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              fontSize: MediaQuery.of(context)
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
                                          ),
                                        ],
                                      ),
                                      Text(
                                        image.userName ?? "Anonymous",
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
                      ),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
