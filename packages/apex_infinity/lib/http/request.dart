import 'dart:convert';

import 'package:apex_infinity/http/response.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AxHttpRequest {
  static String? _baseUrl;
  static Map<String, String> _headers = {};

  void configRequest(
      {required String baseUrl, Map<String, String> headers = const {}}) {
    _baseUrl = baseUrl;
    _headers = headers;
  }

  Future<AxHttpResponse> get(
    {required String url,
    Map<String, String> params = const {},
    Map<String, String> extraHeaders = const {}}) async {

    AxHttpResponse response = AxHttpResponse(
      status: false,
      statusCode: 500,
    );

    final Uri uri = Uri.parse(url);

    final String fullUrl = "${_baseUrl ?? ""}${uri.path}";

    Map<String, String> finalHeaders = _headers;

    if (extraHeaders.isNotEmpty) {
      finalHeaders.addAll(extraHeaders);
    }

    try {
      Response res = await http.get(Uri.parse(fullUrl), headers: finalHeaders);

      Map<String, dynamic> jsonResponse = jsonDecode(res.body);

      if(res.statusCode == 200) {
        response = AxHttpResponse(
          status: jsonResponse['status'] ?? false,
          statusCode: jsonResponse['status_code'] ?? res.statusCode,
          msg: jsonResponse['msg'],
          data: jsonResponse['data']
        );
      } else {
        response = AxHttpResponse(
          status: false,
          statusCode: res.statusCode,
          msg: "Some Issue While Getting Data"
        );
      }

    } catch (e) {
      response = AxHttpResponse(status: false, statusCode: 600);
    }

    return response;
  }
}
