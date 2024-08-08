class AxNavigationData {
  final String path;
  final Iterable<String> pathSegments;
  final String query;
  final Map<String, String> queryParameters;
  final String fragment;
  final Map<String, dynamic> extraArguments;

  AxNavigationData(
      {required this.path,
      required this.pathSegments,
      required this.query,
      required this.queryParameters,
      required this.fragment,
      required this.extraArguments});
}
