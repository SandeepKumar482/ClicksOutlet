
import 'package:apex_infinity/apex_infinity.dart';
import 'package:apex_infinity/http/response.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:clicks_outlet/utils/shared_preferrences.util.dart';

class ImageCollectionService {

  static String trendingImgCacheKey = 'trendingImage';
  static String myUploadImgCacheKey = 'myUploads';

  Future<List<ImageModel>> getImages({String? userId, bool isRefresh = false}) async {

    String cacheKey = userId != null && userId.isNotEmpty
      ? ImageCollectionService.myUploadImgCacheKey
      : ImageCollectionService.trendingImgCacheKey;

    List<ImageModel> imageList = [];

    Map<String, dynamic> imagesFromSp = SharedPreference.getJson(key: cacheKey);

    List<ImageModel> cacheImageList = ImageModel.getImagesList(list: imagesFromSp['images']);

    if (!isRefresh || cacheImageList.isEmpty) {

      final AxHttpResponse response = await Ax.httpRequest.get(url: "/images/");

      if (response.status) {
        imageList = ImageModel.getImagesList(list: response.data['images']);
      }

      if (imageList.isNotEmpty) {
        List<Map> imageListMap = [];

        for (ImageModel img in imageList) {
          imageListMap.add(img.toMap());
        }

        await SharedPreference.setJson(
            key: cacheKey, value: {'images': imageListMap});
      } else {
        imageList = cacheImageList;
      }
    }

    return imageList;
  }

  Future<void> downloadAndSaveImage(String imageUrl) async {
    // final response = await http.get(Uri.parse(imageUrl));
    // if (response.statusCode == 200) {
    //   final appDir = await getApplicationDocumentsDirectory();
    //   final file = File('${appDir.path}/my_image.jpg');
    //   await file.writeAsBytes(response.bodyBytes);
    //   // Show a success message or update UI accordingly
    // } else {
    //   // Handle error (e.g., show an error message)
    // }
  }

}
