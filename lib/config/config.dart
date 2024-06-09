class Config {
  final String userCollection;
  final String imageCollection;
  final String imageFolder;
  final String userProfilePicture;
  final String imagePreviewUrl;

  Config(
      {required this.userCollection,
      required this.imageFolder,
      required this.userProfilePicture,
      required this.imageCollection,
      this.imagePreviewUrl =
          'https://th.bing.com/th/id/OIP.ElJblfvkbDmDPtls38WzsgHaHa?w=500&h=500&rs=1&pid=ImgDetMain'});
}
