import 'dart:convert';

import 'package:http/http.dart' as http ; 

abstract class ISession {
    Future<http.Response> get(dynamic url, {Map<String, String> headers}) ;
    Future<http.Response> post(dynamic url,
      {Map<String, String> headers,
      Map<String, dynamic> body,
      Encoding encoding}) ;
}


abstract class IUTorrentSession extends ISession{

}