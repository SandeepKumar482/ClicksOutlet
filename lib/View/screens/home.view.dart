import 'package:apex_infinity/navigation/navigator.dart';
import 'package:clicks_outlet/View/screens/home/liked.view.dart';
import 'package:clicks_outlet/View/screens/home/my_uploads.view.dart';
import 'package:clicks_outlet/View/screens/home/trending_clicks.view.dart';
import 'package:clicks_outlet/View/widgets/custom_app_bar.widget.dart';
import 'package:clicks_outlet/View/widgets/side_draswer.widget.dart';
import 'package:clicks_outlet/routers/routes.config.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String? section;
  const Home({required this.section, super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<_BottomNavItems> bottomItems = [
      _BottomNavItems(
          index: 0,
          key: 'trending',
          path: RoutesConfig.homeTrending,
          icon: const Icon(Icons.home, size: 30),
          page: const TrendingClicks()),
      _BottomNavItems(
          index: 1,
          key: 'liked',
          path: RoutesConfig.homeLiked,
          icon: const Icon(Icons.favorite, size: 30),
          page: const LikedClicks()),
      _BottomNavItems(
          index: 2,
          key: 'my-uploads',
          path: RoutesConfig.homeMyUploads,
          icon: const Icon(Icons.photo_album_outlined, size: 30),
          page: const MyUploads()),
    ];

    int currentIndex = bottomItems.firstWhere((element) {
      return element.key == widget.section;
    }, orElse: () => bottomItems.first).index;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const CustomAppBar(
            word1: "Clicks",
            word2: "Outlet",
          ),
        ),
        drawer: const SideDrawer(),
        bottomNavigationBar: CurvedNavigationBar(
          key: Key(bottomItems[currentIndex].key),
          height: 64,
          color: const Color(0xffB6F2AF),
          backgroundColor: Colors.transparent,
          index: currentIndex,
          onTap: (index) {
            AxNaviagtion.goTo(path: bottomItems[index].path);
          },
          items: const [
            Icon(Icons.home, size: 30),
            Icon(Icons.favorite, size: 30),
            Icon(Icons.photo_album_outlined, size: 30),
          ],
        ),
        body: Center(child: bottomItems[currentIndex].page));
  }
}

class _BottomNavItems {
  final int index;
  final String key;
  final String path;
  final Widget icon;
  final Widget page;

  _BottomNavItems(
      {required this.index,
      required this.key,
      required this.path,
      required this.icon,
      required this.page});
}
