import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http ; 


///Singleton Session class to handle cookies
class Session {
  Map<String, String> sessionHeaders = {};

  Session._privateConstructor();
  static final Session _instance = Session._privateConstructor();

  static Session getInstance(){
    return _instance ; 
  }

  Future<http.Response> get(dynamic url, {Map<String, String> headers}) async {
    http.Response response = await http.get(url, headers: sessionHeaders);
    _updateCookie(response);
    log('status : ${response.statusCode} , response body : ' + response.body) ; 
    return response ; 
  }

  Future<http.Response> post(dynamic url, {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    http.Response response = await http.post(url, body: body, headers: sessionHeaders);
    log('status : ${response.statusCode} , response body : ' + response.body) ; 
    _updateCookie(response);
    return response ; 
  }

  void _updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      sessionHeaders['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}