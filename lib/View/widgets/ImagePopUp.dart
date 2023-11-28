
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;
  ImageDialog({required this.imageUrl});
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth,
            height: MediaQuery.sizeOf(context).height*0.50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  
                 decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
                 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {
                          // Add your like logic here.
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () {
                          // Add your download logic here.
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          // Add your share logic here.
                        },
                      ),
                     
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
