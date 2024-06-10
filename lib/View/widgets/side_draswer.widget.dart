import 'package:clicks_outlet/main.dart';
import 'package:clicks_outlet/model/package.model.dart';
import 'package:clicks_outlet/model/user_details.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final PackageInfoModel packageInfoModel = PackageInfoModel.fromSP();

    final UserDetailsModel userDetailsModel = UserDetailsModel.fromSP();
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage: NetworkImage(
                                        userDetailsModel.profilePicture ??
                                            config.imagePreviewUrl),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userDetailsModel.name ?? "Anonymous",
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(userDetailsModel.userName ??
                                          "anonymous"),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const ListTile(
                        title: Text("Settings"),
                      ),
                      const ListTile(
                        title: Text("Privacy Policy"),
                      ),
                      const ListTile(
                        title: Text("Logout"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo-rounded.png',
                    height: 150.0,
                    width: 150.0,
                  ),
                  Text(
                    "Verison : ${packageInfoModel.version ?? "--"} | Build : ${packageInfoModel.build ?? "--"}",
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 16.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
