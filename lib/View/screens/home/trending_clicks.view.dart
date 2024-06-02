import 'dart:math';

import 'package:clicksoutlet/View/widgets/image_dto.widget.dart';
import 'package:clicksoutlet/View/widgets/image_pop_up.widget.dart';
import 'package:flutter/material.dart';
import 'package:clicksoutlet/View/widgets/my_search_bar.widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TrendingClicks extends StatelessWidget {
  const TrendingClicks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = List.generate(
        200,
        (index) => {
              "id": index,
              "title": "Item $index",
              "height": Random().nextInt(150) + 50.5
            });

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: MySearchBar(),
        ),
        SizedBox(
          height: 700,
          child: MasonryGridView.count(
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            // the number of columns
            crossAxisCount: 2,
            // vertical gap between two items
            mainAxisSpacing: 4,
            // horizontal gap between two items
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              // display each item with a card
              return GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => const ImageDialog(
                      imageUrl: 'https://wallpapercave.com/wp/wp5163360.jpg',
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
                    key: ValueKey(items[index]['id']),
                    child: const ImageDTO(
                      imageUrl: "https://wallpapercave.com/wp/wp5163360.jpg",
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? MediaQuery.of(context).size.width * 0.023
                                    : MediaQuery.of(context).size.height * 0.03,
                              ),
                              Text(
                                'likes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.portrait
                                          ? MediaQuery.of(context).size.width *
                                              0.023
                                          : MediaQuery.of(context).size.height *
                                              0.03,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'username',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? MediaQuery.of(context).size.width * 0.025
                                  : MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ]),
                  ),
                ]),
              );
            },
          ),
        )
      ],
    );
  }
}
