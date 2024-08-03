import 'dart:convert';
import 'dart:io';

import 'package:apex_infinity/http/response.dart';
import 'package:flutter/foundation.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class AxHttpRequest {
  static String? _baseUrl;
  static Map<String, String> _headers = {};
  static Dio _dio = Dio() ;

  Future<void> configRequest(
      {required String baseUrl, Map<String, String> headers = const {}}) async {
    _baseUrl = baseUrl;
    _headers = headers;

    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory dir = await  new Directory('${appDocDirectory.path}/cookie').create(recursive: true);
    _dio.interceptors.add(CookieManager(PersistCookieJar(storage: FileStorage(dir.path))));
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
      Response res = await _dio.get(fullUrl, options: Options(
        headers: finalHeaders
      ));

      Map<String, dynamic> jsonResponse = {};

      if(res.data is Map) {
        jsonResponse = res.data;
      } else {
        jsonResponse = jsonDecode(res.data);
      }

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
          statusCode: res.statusCode ?? 0,
          msg: "Some Issue While Getting Data"
        );
      }

    } catch (e) {
      print(e);
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

      FormData formData = FormData();
      
      for(var data in body.entries ){
        if (data.value != null) {
          if(data.value is File) {
          
            MultipartFile multipartFile = await MultipartFile.fromFile(data.value.path);
          
            formData.files.add(MapEntry(data.key,multipartFile));
          } else {
            formData.fields.add(MapEntry(data.key, data.value.toString()));
          }
        }
      }
      Response res = await _dio.post(fullUrl,data:formData,options: Options(headers: finalHeaders));

      Map<String, dynamic> jsonResponse ;
      if(res.data is Map) {
        jsonResponse = res.data;
      } else {
        jsonResponse = jsonDecode(res.data);
      }
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
            statusCode: res.statusCode ?? 0,
            msg: "Some Issue While Getting Data"
        );
      }
    } catch (e) {
      print(e);
      response = AxHttpResponse(
        status: false,
        statusCode: 600,
        msg: "enable to decode Response"
      );
    }

    return response;

  }

}
