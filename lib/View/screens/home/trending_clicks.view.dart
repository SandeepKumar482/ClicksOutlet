import 'dart:math';

import 'package:clicksoutlet/FirebaseService/image_collection.service.dart';
import 'package:clicksoutlet/View/widgets/image_dto.widget.dart';
import 'package:clicksoutlet/View/widgets/image_pop_up.widget.dart';
import 'package:clicksoutlet/View/widgets/images_grid.widget.dart';
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
    return RefreshIndicator(
        onRefresh: () async {
          return fetchImageList();
        },
        child: Expanded(child: ImagesGrid(getImages: getImages)));
  }
}
