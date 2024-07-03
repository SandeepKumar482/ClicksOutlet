class AxNaviagtionData {
  final String? path;
  final Iterable<String>? pathSegments;
  final String? query;
  final Map<String, dynamic>? queryParameters;
  final String? fragment;
  final Map<String, dynamic>? extraArgumnets;

  AxNaviagtionData(
      {required this.path,
      required this.pathSegments,
      required this.query,
      required this.queryParameters,
      required this.fragment,
      required this.extraArgumnets});
}
