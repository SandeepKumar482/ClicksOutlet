import 'dart:convert';
import 'dart:io';

import 'package:apex_infinity/http/response.dart';
import 'package:flutter/foundation.dart';
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
      statusCode: 600,
    );

    final Uri uri = Uri.parse(url);

    String fullUrl = "${_baseUrl ?? ""}${uri.path}";

    Map<String, String> finalHeaders = _headers;

    if (extraHeaders.isNotEmpty) {
      finalHeaders.addAll(extraHeaders);
    }

    // finalHeaders.addAll({
    //   'cookie': 'PHPSESSID=vsma7oi1mmbrsgtv4fimdc8b0c'
    // });

    if(params.isNotEmpty) {
      String queryString = "?";
      params.forEach((key,vale) {
        queryString += "$key=$vale&";
      });
      fullUrl += queryString;
    }

    debugPrint("************************* GET  REQUEST *****************************");
    debugPrint(fullUrl);

    try {
      Response res = await http.get(Uri.parse(fullUrl), headers: finalHeaders);

      Map<String, dynamic> jsonResponse = jsonDecode(res.body);
      _setCookie(headers:res.headers);

      if(res.statusCode == 200) {
        response = AxHttpResponse(
          status: jsonResponse['status'] ?? false,
          statusCode: jsonResponse['status_code'] ?? res.statusCode,
          msg: jsonResponse['msg'],
          data: jsonResponse['data'],
          redirectUrl: jsonResponse['redirect_url'],
        );
      } else {
        response = AxHttpResponse(
          status: false,
          statusCode: res.statusCode,
          msg: "Some Issue While Getting Data"
        );
      }

    } catch (e) {
      response = AxHttpResponse(
        status: false,
        statusCode: 600,
        msg: "enable to decode Response"
      );
    }

    return response;
  }

  Future<AxHttpResponse> post({
    required String url,
    Map<String, dynamic> body = const {},
    Map<String, String> extraHeaders = const {}
  }) async {

    AxHttpResponse response = AxHttpResponse(status: false, statusCode: 600);

    final Uri uri = Uri.parse(url);

    final String fullUrl = "${_baseUrl ?? ""}${uri.path}";

    Map<String, String> finalHeaders = _headers;

    if (extraHeaders.isNotEmpty) {
      finalHeaders.addAll(extraHeaders);
    }
    debugPrint("************************* POST  REQUEST *****************************");
    debugPrint(fullUrl);
    try {
      MultipartRequest request = http.MultipartRequest('POST',Uri.parse(fullUrl));
      request.headers.addAll(finalHeaders);

      Map<String, String> fields = {};
      List<MultipartFile> files = [];
      
      for(var data in body.entries ){
        if(data.value is File) {
         files.add(await MultipartFile.fromPath(data.key,data.value.path));
        } else {
          fields.addAll({
            data.key : data.value.toString()
          });
        }
      }

      request.files.addAll(files);
      request.fields.addAll(fields);

      final StreamedResponse res = await request.send();

      final resData = await res.stream.bytesToString();

      Map<String, dynamic> jsonResponse = jsonDecode(resData);
      _setCookie(headers: res.headers);

      if(res.statusCode == 200) {
        response = AxHttpResponse(
            status: jsonResponse['status'] ?? false,
            statusCode: jsonResponse['status_code'] ?? res.statusCode,
            msg: jsonResponse['msg'],
            data: jsonResponse['data'] ?? {},
            redirectUrl: jsonResponse['redirect_url'],
        );
      } else {
        response = AxHttpResponse(
            status: false,
            statusCode: res.statusCode,
            msg: "Some Issue While Getting Data"
        );
      }
    } catch (e) {
      response = AxHttpResponse(
        status: false,
        statusCode: 600,
        msg: "enable to decode Response"
      );
    }

    return response;

  }

  void _setCookie({required Map<String,String> headers}) {
    if(headers['set-cookie'] != null) {
      _headers['cookie'] = headers['set-cookie'].toString();
    }
  }
  AxHttpResponse _response() {

    AxHttpResponse response = AxHttpResponse(status: false, statusCode: 600);

    return response;

  }
}
