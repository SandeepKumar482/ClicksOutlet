import 'package:apex_infinity/navigation/navigation_data.model.dart';
import 'package:clicks_outlet/View/screens/home/liked.view.dart';
import 'package:clicks_outlet/View/screens/home/my_account.dart';
import 'package:clicks_outlet/View/screens/home/my_uploads.view.dart';
import 'package:clicks_outlet/View/screens/home/trending_clicks.view.dart';
import 'package:clicks_outlet/View/widgets/custom_app_bar.widget.dart';
import 'package:clicks_outlet/routers/routes.config.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final AxNavigationData navigationData;
  const Home({required this.navigationData, super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<_BottomNavItems> _bottomItems = [];
  int _currentIndex = 0;

  @override
  void initState() {
    _setPageData();
    super.initState();
  }

  void _setPageData() {
    _bottomItems = [
      _BottomNavItems(
        index: 0,
        key: RoutesConfig.trending,
        iconData: Icons.home,
        page: TrendingClicks( navigationData: widget.navigationData,)
      ),
      _BottomNavItems(
        index: 1,
        key: RoutesConfig.liked,
        iconData: Icons.home,
        page: LikedClicks(navigationData: widget.navigationData,)
      ),
      _BottomNavItems(
        index: 2,
        key: RoutesConfig.myUploads,
        iconData: Icons.photo_album_outlined,
        page: MyUploads(navigationData: widget.navigationData,)
      ),
      _BottomNavItems(
        index: 3,
        key: RoutesConfig.myAccount,
        iconData: Icons.account_circle_outlined,
        page: MyAccount(navigationData: widget.navigationData,)
      ),
    ];

    _currentIndex = _bottomItems.firstWhere((element) {
      return element.key == widget.navigationData.path;
    }, orElse: () => _bottomItems.first).index;

  }

  @override
  Widget build(BuildContext context) {

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
      bottomNavigationBar: CurvedNavigationBar(
        key: Key(_bottomItems[_currentIndex].key),
        height: 64,
        color: const Color(0xffB6F2AF),
        backgroundColor: Colors.transparent,
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _bottomItems.map<Widget>((navItem){
          return Icon(
            navItem.iconData,
            size: 30.0,
          );
        }).toList(),
      ),
      body: _bottomItems[_currentIndex].page,
    );
  }
}

class _BottomNavItems {
  final int index;
  final String key;
  final IconData iconData;
  final Widget page;

  _BottomNavItems(
      {required this.index,
      required this.key,
      required this.iconData,
      required this.page});
}
