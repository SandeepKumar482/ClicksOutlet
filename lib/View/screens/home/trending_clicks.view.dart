import 'package:apex_infinity/layout/future.layout.dart';
import 'package:apex_infinity/navigation/naviaftion_data.model.dart';
import 'package:clicks_outlet/FirebaseService/image_collection.service.dart';
import 'package:clicks_outlet/View/widgets/images_grid.widget.dart';
import 'package:clicks_outlet/config/api.config.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:flutter/material.dart';

class TrendingClicks extends StatefulWidget {

  final AxNavigationData navigationData;

  const TrendingClicks({super.key,required this.navigationData });

  @override
  State<TrendingClicks> createState() => _TrendingClicksState();
}

class _TrendingClicksState extends State<TrendingClicks> {

  @override
  Widget build(BuildContext context) {
    return AxFutureBuilder(
      url: APIConfig.home,
      childBuilder:(data) {

        List<ImageModel> images = ImageModel.getImagesList(list: data['images']);

        return ImagesGrid(images: images);
      }
    );
  }
}
