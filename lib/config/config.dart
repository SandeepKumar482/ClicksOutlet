class Config {

  final String baseUrl;
  final String previewImageUrl;
  final String apiKey;

  Config(
      {required this.baseUrl,
        this.previewImageUrl = "",
        required this.apiKey,
      });
}
