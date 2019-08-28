import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

const String contentType = 'application/json';

/// Maintains various tokens and headers to keep the session
/// going.
///
/// It stores tokens, cookies, authorization credentials and other
/// required headers to be sent over and over to the client.
class Session {
  // Headers to be set post authentication:
  // 1. authorization
  // 2. content-type
  // 3. cookie

  Map<String, String> sessionHeaders = {};
  String _token;

  Session() : sessionHeaders = {'content-type': 'application/json'};

  /// Pass in a valid URL [url] and optionally, [headers] to fire a `GET` request at
  /// the specified URL.
  Future<http.Response> get(dynamic url, {Map<String, String> headers}) async {
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

  /// Pass in URL [url], optionally headers, body and encoding (which defaults to utf8) to
  /// fire a `POST` request at the specified url.
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

  /// Pass in URL [url] and optionally fieldName and path of the file to be sent.
  /// This fires a multipart `POST` request at the specfied url.
  Future<http.StreamedResponse> multipartPost(dynamic url,
      {String fieldName, String path}) async {
    assert(url != null);

    if (_token != null) url += '&token=$_token';

    Uri uri = Uri.parse(url);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('torrent_file', path);

    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    request.headers.addAll(sessionHeaders);
    request.headers['content-type'] = 'multipart/form-dart';
    print(request.headers);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    return response;
  }

  /// Utility function to extract a cookie, if present,
  /// and add it to session headers.
  void _updateCookie(http.Response res) {
    String rawCookie = res.headers['set-cookie'];

    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      sessionHeaders['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  set token(String token) => _token = token;

  /// Utility function to clear a session.
  void clearSession() {
    sessionHeaders.clear();
    sessionHeaders['content-type'] = 'application/json';
  }
}
