class AxHttpResponse{
  final bool status;
  final int statusCode;
  final String? msg;
  final Map<String,dynamic> data;
  final String? redirectUrl;

  AxHttpResponse(
  {
    required this.status,
    required this.statusCode,
    this.msg,
    this.data = const {},
    this.redirectUrl
});
}