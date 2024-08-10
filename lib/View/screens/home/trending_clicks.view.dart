import 'package:apex_infinity/apex_infinity.dart';
import 'package:apex_infinity/http/cache_rule.dart';
import 'package:apex_infinity/layout/future.layout.dart';
import 'package:apex_infinity/navigation/navigation_data.model.dart';
import 'package:clicks_outlet/View/widgets/images_grid.widget.dart';
import 'package:clicks_outlet/View/widgets/my_search_bar.widget.dart';
import 'package:clicks_outlet/config/api.config.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:flutter/material.dart';

class TrendingClicks extends StatelessWidget {

  final AxNavigationData navigationData;

  const TrendingClicks({super.key,required this.navigationData });

  @override
  Widget build(BuildContext context) {
    Future<dynamic> Function()?  apiData;

    apiData = () => Ax.httpRequest.get(
      url: APIConfig.home,
      cacheRule: AxRequestCacheRule(
        key: "trending_clicks",
        duration: const Duration(hours: 1),
      )
    );

    return Column(
      children: [
        Container(
          margin:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: MySearchBar(),
        ),
        Expanded(
          child: AxFutureBuilder(
            future: apiData,
            childBuilder:(data) {

              List<ImageModel> images = ImageModel.getImagesList(list: data['images']);

              return ImagesGrid(images: images);
            }
          ),
        ),
      ],
    );
  }
}
