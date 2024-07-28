import 'dart:io';
import 'package:apex_infinity/apex_infinity.dart';
import 'package:apex_infinity/http/response.dart';
import 'package:apex_infinity/navigation/naviaftion_data.model.dart';
import 'package:clicks_outlet/FirebaseService/auth.service.dart';
import 'package:clicks_outlet/FirebaseService/image_collection.service.dart';
import 'package:clicks_outlet/View/screens/authentication/auth.view.dart';
import 'package:clicks_outlet/View/widgets/images_grid.widget.dart';
import 'package:clicks_outlet/View/widgets/input.widget.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:clicks_outlet/model/user_details.dart';
import 'package:clicks_outlet/utils/floating_msg.util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/HashtagBubble.dart';

class MyUploads extends StatefulWidget {

  final AxNavigationData navigationData;

  const MyUploads({super.key,required this.navigationData});

  @override
  State<MyUploads> createState() => _MyUploadsState();
}

class _MyUploadsState extends State<MyUploads> {
  List<ImageModel> imageList = [];

  UserDetailsModel userDetailsModel = UserDetailsModel.fromSP();
  final ImagePicker _picker = ImagePicker();
  late HashtagEditingController _controller;
  Future<List<ImageModel>>? getImages;

  @override
  void initState() {
    super.initState();
    _controller = HashtagEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void fetchImageList() {
    setState(() {
      getImages =
          ImageCollectionService().getImages(userId: userDetailsModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final FloatingActionButton floatingActionButton = FloatingActionButton(
      onPressed: () async {
        userDetailsModel = UserDetailsModel.fromSP();
        if (userDetailsModel.id == null) {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                return const Auth();
              });
          setState(() {
            userDetailsModel = UserDetailsModel.fromSP();
          });
        } else {
          await selectAnduploadImage();
        }
      },
      child: const Icon(
        Icons.add_a_photo_outlined,
      ),
    );

    if (userDetailsModel.id == null) {
      return Center(
        child: floatingActionButton,
      );
    } else {
      fetchImageList();
      return Column(
        children: [
          Expanded(
            child: Column(
              children: [
                _UserProfile(userDetailsModel: userDetailsModel),
                Expanded(child: ImagesGrid(getImages: getImages)),
              ],
            ),
          ),
          floatingActionButton
        ],
      );
    }
  }

  Future<void> selectAnduploadImage() async {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage == null) {
      FloatingMsg.show(
        context: context,
        msg: "Please Select A Image",
        msgType: MsgType.error
      );
    } else {
      File file = File(selectedImage.path);
      final d = await decodeImageFromList(file.readAsBytesSync());
      final formKey = GlobalKey<FormState>();

      final TextEditingController caption = TextEditingController();
      final TextEditingController tags = TextEditingController();

      return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        context: context,
        builder: (ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.file(file),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InputWidget(
                      label: "Caption",
                      controller: caption,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InputWidget(
                      label: "Tags",
                      controller: _controller,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    FilledButton(
                      onPressed: () async {
                        AxHttpResponse response = await Ax.httpRequest.post(
                          url: '/images/',
                          body: {
                            'image' : File(file.path),
                            'caption' : caption.text,
                            'tags' : [tags.text],
                            'height' : d.height,
                            'width' : d.width,
                          }
                        );

                        if(response.status) {
                          Ax.goBack();
                        } else {
                          FloatingMsg.show(context: context, msg: response.msg, msgType: MsgType.error);
                        }
                      },
                      child: const Text("Upload"),
                    ),
                    const SizedBox(
                      height: 25.0,
                    )
                  ],
                ),
              ),
            ),
          );
        });
    }
  }

}

class _UserProfile extends StatelessWidget {
  final UserDetailsModel userDetailsModel;

  const _UserProfile({required this.userDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(userDetailsModel.profilePicture),
                ),
                const SizedBox(
                  width: 25.0,
                ),
                Text(userDetailsModel.name ?? "Any"),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  await GoogleAuthServices.signOut();
                  Ax.goBack();
                  // Get.to(const Home());
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}
