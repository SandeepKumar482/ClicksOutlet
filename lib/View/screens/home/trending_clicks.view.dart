import 'package:clicks_outlet/FirebaseService/image_collection.service.dart';
import 'package:clicks_outlet/FirebaseService/user_collection.service.dart';
import 'package:clicks_outlet/View/widgets/images_grid.widget.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:clicks_outlet/model/user_details.dart';
import 'package:flutter/material.dart';

class TrendingClicks extends StatefulWidget {
  const TrendingClicks({Key? key}) : super(key: key);

  @override
  State<TrendingClicks> createState() => _TrendingClicksState();
}

class _TrendingClicksState extends State<TrendingClicks> {
  Future<List<ImageModel>>? getImages;
  UserDetailsModel userDetailsModel = UserDetailsModel.fromSP();
  UserCollectionService userCollectionService = UserCollectionService();

  void fetchImageList() {
    setState(() {
      getImages = ImageCollectionService().getImages();
    });
  }

  @override
  void initState() {
    fetchImageList();
    /* if (userDetailsModel.id == null || userDetailsModel.id!.isEmpty) {
      String? id =
          Utils.generateUserName(username: Utils.generateRandomUserId(7));
      userCollectionService.addUpdateData(UserDetailsModel(
          id: id, email: null, phone: null, name: null, userName: id));
    }*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          return fetchImageList();
        },
        child: ImagesGrid(getImages: getImages));
  }
}
