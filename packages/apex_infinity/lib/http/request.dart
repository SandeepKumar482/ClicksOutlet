import 'dart:convert';

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

  Future<Map<String, dynamic>> get(
      {required String url,
      Map<String, String> params = const {},
      Map<String, String> extraHeaders = const {}}) async {
    final Uri uri = Uri.parse(url);

    final String fullUrl = "${_baseUrl ?? ""}${uri.path}";

    Map<String, String> finalHeaders = _headers;

    if (extraHeaders.isNotEmpty) {
      finalHeaders.addAll(extraHeaders);
    }


    bool status = true;
    Map<String, dynamic> response = {};
    try {
      Response res = await http.get(Uri.parse(fullUrl), headers: finalHeaders);
      response = jsonDecode(res.body);
    } catch (e) {
      status = false;
      response['error'] = e.toString();
    }

    return {"status": status, "res": response};
  }
}
