import 'package:clicks_outlet/FirebaseService/image_collection.service.dart';
import 'package:clicks_outlet/View/widgets/images_grid.widget.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:flutter/material.dart';

class TrendingClicks extends StatefulWidget {

  const TrendingClicks({super.key});

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
    return RefreshIndicator(
      onRefresh: () async {
        fetchImageList();
      },
      child: ImagesGrid(
        getImages: getImages
      )
    );
  }
}
