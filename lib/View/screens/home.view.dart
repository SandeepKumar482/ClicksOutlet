import 'package:clicks_outlet/View/screens/home/liked.view.dart';
import 'package:clicks_outlet/View/screens/home/my_uploads.view.dart';
import 'package:clicks_outlet/View/screens/home/trending_clicks.view.dart';
import 'package:clicks_outlet/View/widgets/custom_app_bar.widget.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageidx = 0;

  var page = [const TrendingClicks(), const LikedClicks(), const MyUploads()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          height: 64,
          color: const Color(0xffB6F2AF),
          backgroundColor: Colors.transparent,
          onTap: (index) {
            setState(() {
              pageidx = index;
            });
          },
          items: const [
            Icon(Icons.home, size: 30),
            Icon(Icons.favorite, size: 30),
            Icon(Icons.photo_album_outlined, size: 30),
          ],
        ),
        body: Center(child: page[pageidx]));
  }
}
