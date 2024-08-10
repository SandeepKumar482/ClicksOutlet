import 'dart:convert';
import 'dart:io';

import 'package:apex_infinity/http/cache_rule.dart';
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

  Future<AxHttpResponse> get({
    required String url,
      Map<String, String> params = const {},
      Map<String, String> extraHeaders = const {},
      bool isRefreshCache = false,
      AxRequestCacheRule? cacheRule
    }) async {

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

    if(!(cacheRule?.isDataExpired() ?? true)) {
      debugPrint("************************* FROM CACHE *****************************");
      return _response(data: cacheRule!.getData());
    } else {
      await cacheRule?.clearData();
      try {
        Response res = await _dio.get(fullUrl, options: Options(
            headers: finalHeaders
        ));

        return _response(data: res.data,statusCode: res.statusCode,cacheRule: cacheRule);
      } catch (e) {
       return _response(data: null);
      }
    }
  }

  Future<AxHttpResponse> post({
    required String url,
    Map<String, dynamic> body = const {},
    Map<String, String> extraHeaders = const {}
  }) async {


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


      return _response(data: res.data,statusCode: res.statusCode);

    } catch (e) {
      print(e);
      _response(data: null);
    }

    return _response(data: null);

  }

  AxHttpResponse _response({required dynamic data,int? statusCode,AxRequestCacheRule? cacheRule}) {
    AxHttpResponse response = AxHttpResponse(status: false, statusCode: 600);

    if (data != null) {
      Map<String, dynamic> jsonResponse ;
      if(data is Map<String,dynamic>) {
        jsonResponse = data;
      } else {
        jsonResponse = jsonDecode(data);
      }

      if(statusCode == 200 || jsonResponse.isNotEmpty) {
        cacheRule?.setData(data: jsonResponse);
        response = AxHttpResponse(
          status: jsonResponse['status'] ?? false,
          statusCode: jsonResponse['status_code'] ?? statusCode,
          msg: jsonResponse['msg'],
          data: jsonResponse['data'] ?? {},
          redirectUrl: jsonResponse['redirect_url'],
        );
      } else {
        response = AxHttpResponse(
            status: false,
            statusCode: statusCode ?? 600,
            msg: "Some Issue While Getting Data"
        );
      }
    }
    return response;
  }

}
