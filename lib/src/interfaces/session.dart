import 'dart:convert';

import 'package:http/http.dart' as http ; 
import 'package:meta/meta.dart' ; 

abstract class ISession {
    Future<http.Response> get(dynamic url, {Map<String, String> headers}) ;
    Future<http.Response> post(dynamic url,
      {Map<String, String> headers,
      Map<String, dynamic> body,
      Encoding encoding}) ;
}

abstract class IQbitTorrentSession  extends ISession{

}

abstract class IUTorrentSession extends ISession{

}