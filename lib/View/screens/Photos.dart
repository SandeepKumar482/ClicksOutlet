import 'dart:math';

import 'package:clicksoutlet/View/widgets/ImageDTO.dart';
import 'package:clicksoutlet/View/widgets/ImagePopUp.dart';
import 'package:flutter/material.dart';
import 'package:clicksoutlet/View/widgets/MySearchBar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PhotosScrn extends StatelessWidget {
  const PhotosScrn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _items = List.generate(
        200,
            (index) => {
          "id": index,
          "title": "Item $index",
          "height": Random().nextInt(150) + 50.5
        });


    return Scaffold(
      body: Column(
        children: [
          Container(
              margin:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: MySearchBar(),
          ),
          Container(
            height: 700,
            child: MasonryGridView.count(
              itemCount: _items.length,
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
              builder: (_) => ImageDialog(imageUrl: 'https://wallpapercave.com/wp/wp5163360.jpg',
              ),
            );
          },
                  child: Stack(
                    children: [Card(
                      // Give each item a random background color
                      color: Color.fromARGB(
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256)),
                      key: ValueKey(_items[index]['id']),
                      child: ImageDTO(imageUrl: "https://wallpapercave.com/wp/wp5163360.jpg",),
                    ),
                    Positioned(
                            bottom: 15,
                            left: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                
                              children:[ Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.favorite, color: Colors.red,size: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.023 : MediaQuery.of(context).size.height * 0.03,
                  ),
                
                   
                    Text('likes', style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.023 : MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                  ],
                              ),
                              Text('username', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.025 : MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                              ]
                            ),
                          ),
                    ]
                
                  ),
                );
              },
            ),
          )


        ],
      ),
    );
  }
}
