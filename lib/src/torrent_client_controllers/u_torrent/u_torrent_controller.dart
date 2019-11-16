import 'dart:convert';
import 'dart:developer';

import 'package:meta/meta.dart';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:torrential_lib/src/torrent_client_controllers/u_torrent/session.dart';

/// A wrapper class written around the WebUI API of uTorrent client.
///
/// Instantiate this class to get access to a host of methods
/// aimed at the end-points so exposed.
class UTorrentApi {
  final String serverIp;
  final int serverPort;
  final String baseUrl;

  final Session _session = Session();

  Map<String, String> actions;

  /// Please follow this
  /// [link](https://github.com/SchizoDuckie/DuckieTV/wiki/Setting-up-uTorrent-Web-UI-with-DuckieTV)
  /// to set-up WebUI from inside uTorrent.
  UTorrentApi({@required this.serverIp, @required this.serverPort})
      : baseUrl = 'http://$serverIp:$serverPort/gui/' {
    assert(serverIp != null);
    assert(serverPort != null);
  }

  /// Pass-in username and password as
  /// [set up](https://github.com/SchizoDuckie/DuckieTV/wiki/Setting-up-uTorrent-Web-UI-with-DuckieTV)
  /// in your WebUI Settings
  /// to log-in the user.
  ///
  /// Use guest's username, as per the set-up, and empty string(non-null) for password to log-in as guest.
  /// Please know that guest users have limited access!
  ///
  /// Returns true on successful autentication, otherwise false.
  Future<bool> logIn({String username, String password}) async {
    String authCredentials = 'Basic ' +
        base64.encode(
          utf8.encode('$username:$password'),
        );

    _session.sessionHeaders.addAll({
      'authorization': authCredentials,
    });

    http.Response tokenResponse = await _session.get('${baseUrl}token.html');

    String token =
        html.parse(tokenResponse?.body)?.getElementById('token')?.text;

    _session.token = token;

    log('[logIn] : statusCode : ${tokenResponse.statusCode}, response-body : ${tokenResponse.body}');

    return tokenResponse.statusCode == 200;
  }

  /// Logs out the current user
  void logOut() {
    _session.clearSession();
  }

  /// Pass in the [torrentHash], i.e. hash of the torrent file
  /// to initiate it (commences download).
  Future<http.Response> startTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=start&hash=$torrentHash';
    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHashes], i.e. list of hashes of the
  /// torrent files to initiate them all.
  Future<http.Response> startTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url = '$baseUrl?action=start';

    for (String torrentHash in torrentHashes) url += '&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHash], i.e. hash of the torrent file
  /// to stop it.
  Future<http.Response> stopTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=stop&hash=$torrentHash';
    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHashes], i.e. list of hashes of the
  /// torrent files to stop them all.
  Future<http.Response> stopTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url = '$baseUrl?action=stop';

    for (String torrentHash in torrentHashes) url += '&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHash], i.e. hash of the torrent file
  /// to pause it.
  Future<http.Response> pauseTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=pause&hash=$torrentHash';
    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHashes], i.e. list of hashes of the
  /// torrent files to pause them.
  Future<http.Response> pauseTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url = '$baseUrl?action=pause';

    for (String torrentHash in torrentHashes) url += '&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHash], i.e. hash of the torrent file
  /// to force-start it.
  Future<http.Response> forceStartTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=forcestart&hash=$torrentHash';
    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHashes], i.e. list of hashes of the
  /// torrent files to force-start them.
  Future<http.Response> forceStartTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url = '$baseUrl?action=forcestart';

    for (String torrentHash in torrentHashes) url += '&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHash], i.e. hash of the torrent file
  /// to pause it.
  Future<http.Response> unpauseTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=unpause&hash=$torrentHash';
    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHashes], i.e. list of hashes of the
  /// torrent files to pause them.
  Future<http.Response> unpauseTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url = '$baseUrl?action=unpause';

    for (String torrentHash in torrentHashes) url += '&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHash], i.e. hash of the torrent file
  /// to recheck it.
  Future<http.Response> recheckTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=recheck&hash=$torrentHash';
    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHashes], i.e. list of hashes of the
  /// torrent files to recheck them.
  Future<http.Response> recheckTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url = '$baseUrl?action=recheck';

    for (String torrentHash in torrentHashes) url += '&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHash], i.e. hash of the torrent file
  /// to  remove it.
  Future<http.Response> removeTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=remove&hash=$torrentHash';
    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHashes], i.e. list of hashes of the
  /// torrent files to remove them.
  Future<http.Response> removeTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url = '$baseUrl?action=remove';

    for (String torrentHash in torrentHashes) url += '&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHash], i.e. hash of the torrent file
  /// to  remove it.
  Future<http.Response> removeTorrentAndData(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=removedata&hash=$torrentHash';
    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in the [torrentHashes], i.e. list of hashes of the
  /// torrent files to remove them.
  Future<http.Response> removeTorrentsAndData(
      List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url = '$baseUrl?action=removedata';

    for (String torrentHash in torrentHashes) url += '&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in a torrent-url to initiate its download.
  Future<http.Response> addTorrentUrl(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=add-url&s=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  /// Pass in a torrent-file path (on the server) to initiate its download.
  Future<http.StreamedResponse> addTorrentFile({String filePath}) async {
    assert(filePath != null);

    String url = '$baseUrl?action=add-file';

    http.StreamedResponse response = await _session.multipartPost(url,
        fieldName: 'torrent_file', path: filePath);

    print(response);

    log('[addTorrentFile]: statusCode : ${response.statusCode}, response-body: ${response.stream}');

    return response;
  }

  /// A list of torrents being held on the server
  Future<List<dynamic>> get torrentsList async {
    http.Response response = await _session.get('$baseUrl?list=1');

    log('[torrentsList] : statusCode : ${response.statusCode}, response-body: ${response.body}');

    return json.decode(response.body)['torrents'];
  }
}
