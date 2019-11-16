import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http ;
import 'package:torrential_lib/src/core/contracts/session.dart';


///Singleton Session class to handle cookies
class Session implements IQbitTorrentSession {
  Map<String, String> sessionHeaders = {};

  Future<http.Response> get(dynamic url, {Map<String, String> headers}) async {
    /// headers receives as per the headers arg is sent to the API>
    http.Response response = await http.get(url, headers: sessionHeaders);
    _updateCookie(response);
    log('status : ${response.statusCode} , response body : ' + response.body) ; 
    return response ; 
  }

  Future<http.Response> post(dynamic url, {Map<String, String> headers, Map<String,dynamic> body, Encoding encoding}) async {
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