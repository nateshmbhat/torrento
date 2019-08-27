import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

const String contentType = 'application/json';

/// Maintains various tokens and headers to keep the session
/// going.
/// 
/// It stores tokens, cookies, authorization credentials and other
/// required headers to be sent over and over to the client.
class Session {

  // Headers to be set : 
  // 1. authorization
  // 2. content-type
  // 3. cookie

  Map<String, String> sessionHeaders = {};
  String _token;

  Session() : sessionHeaders = {'content-type': 'application/json'};


  /// Pass in a valid URL [url] and optionally, [headers] to fire a `get` request to
  /// the specified URL.
  Future<http.Response> get(String url, {Map<String, String> headers}) async {
    assert(url != null);

    if (_token != null) url = '${url}&token=$_token';

    http.Response res = await http.get(
      url,
      headers: headers ?? sessionHeaders,
    );

    log('status : ${res.statusCode}, response body : ${res.body}');

    _updateCookie(res);

    return res;
  }

  /// Pass in URl [url], optionally headers, body and encoding (which defaults utf8) to 
  /// fire a `post` request at the specified url.
  Future<http.Response> post(dynamic url,
      {Map<String, String> headers,
      Map<String, dynamic> body,
      Encoding encoding}) async {
    assert(url != null);

    http.Response response =
        await http.post(url, headers: sessionHeaders, body: body);

    log('status : ${response.statusCode} , response body : ' + response.body);

    _updateCookie(response);

    return response;
  }


  void _updateCookie(http.Response res) {
    String rawCookie = res.headers['set-cookie'];

    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      sessionHeaders['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  set token(String token) => _token = token;
}
