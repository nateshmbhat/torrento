import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:torrential_lib/src/core/contracts/torrent_interface.dart';
import 'package:torrential_lib/src/core/exceptions/exceptions.dart';
import 'package:torrential_lib/src/torrent_client_controllers/u_torrent/session.dart';

abstract class UTorrentController extends TorrentController {
  factory UTorrentController(
          {@required String serverIp, @required int serverPort}) =>
      _UTorrentControllerImpl(
        serverIp: serverIp,
        serverPort: serverPort,
      );
}

class _UTorrentControllerImpl implements UTorrentController {
  final String serverIp;
  final int serverPort;
  final String baseUrl;

  final Session _session = Session();

  Map<String, String> actions;

  _UTorrentControllerImpl({@required this.serverIp, @required this.serverPort})
      : baseUrl = 'http://$serverIp:$serverPort/gui/' {
    assert(serverIp != null);
    assert(serverPort != null);
  }

  Future<void> logIn({String username, String password}) async {
    String authCredentialsBase64Encoded =
        getBase64EncodingOf(username: username, password: password);

    addKVPsToSessionHeaders({'authorization': authCredentialsBase64Encoded});

    setSessionToken(await getToken());
  }

  String getBase64EncodingOf(
      {@required String username, @required String password}) {
    return 'Basic ' + base64.encode(utf8.encode('$username:$password'));
  }

  void addKVPsToSessionHeaders(Map<String, dynamic> keyValuePairs) {
    _session.sessionHeaders.addAll(keyValuePairs);
  }

  Future<String> getToken() async {
    http.Response tokenResponse = await _session.get('${baseUrl}token.html');

    String token =
        html.parse(tokenResponse?.body)?.getElementById('token')?.text;

    if (tokenResponse.statusCode != 200)
      throw InvalidCredentialsException(tokenResponse);

    return token;
  }

  void setSessionToken(String token) {
    _session.token = token;
  }

  void logOut() {
    _session.clearSession();
  }

  String concatenateTorrentHashhes(List<String> torrentHashes) {
    String toReturn = '';

    for (String torrentHash in torrentHashes) toReturn += '&hash=$torrentHash';

    return toReturn;
  }

  Future<http.Response> addTorrent(String torrentUrl) async {
    assert(torrentUrl != null);

    String url = '$baseUrl?action=add-url&s=$torrentUrl';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.StreamedResponse> addTorrentFile({String filePath}) async {
    assert(filePath != null);

    String url = '$baseUrl?action=add-file';

    http.StreamedResponse response = await _session.multipartPost(url,
        fieldName: 'torrent_file', path: filePath);

    return response;
  }

  Future<http.Response> startTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=start&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> startMultipleTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '${baseUrl}?action=start${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> stopTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=stop&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> stopMultipleTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '${baseUrl}?action=stop${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> pauseTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=pause&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> pauseMultipleTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '${baseUrl}?action=pause${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> unpauseTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=unpause&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> unpauseMultipleTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '${baseUrl}?action=unpause${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> forceStartTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=forcestart&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> forceStartMultipleTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '${baseUrl}?action=forcestart${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  @override
  Future resumeTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=resume&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  @override
  Future resumeMultipleTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '${baseUrl}?action=resume${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> recheckTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=recheck&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> recheckMultipleTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '${baseUrl}?action=recheck${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> removeTorrent(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=remove&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> removeMultipleTorrents(List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '$baseUrl?action=remove${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> removeTorrentAndData(String torrentHash) async {
    assert(torrentHash != null);

    String url = '$baseUrl?action=removedata&hash=$torrentHash';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<http.Response> removeMultipleTorrentsAndData(
      List<String> torrentHashes) async {
    assert(torrentHashes != null);
    assert(torrentHashes.length != 0);

    String url =
        '${baseUrl}?action=removedata${concatenateTorrentHashhes(torrentHashes)}';

    http.Response response = await _session.get(url);

    return response;
  }

  Future<List<dynamic>> getTorrentsList() async {
    http.Response response = await _session.get('$baseUrl?list=1');

    return json.decode(response.body)['torrents'];
  }

  @override
  String getApiDocUrl() {
    return 'http://help.utorrent.com/customer/portal/topics/664593/articles';
  }

  @override
  Future<http.Response> getClientSettings() async {
    String url = '${baseUrl}?action=getsettings';

    http.Response response = await _session.get(url);

    return response;
  }

  @override
  Future<http.Response> getListOfFilesUnderATorrentJob(
      String torrentHash) async {
    String url = '${baseUrl}?action=getfiles&hash=${torrentHash}';

    http.Response response = await _session.get(url);

    return response;
  }

  @override
  Future<http.Response> getPropertiesOfTorrent(String torrentHash) async {
    String url = '${baseUrl}?action=getprops&hash=${torrentHash}';

    http.Response response = await _session.get(url);

    return response;
  }

  @override
  Future<http.Response> setClientSettings(
      Map<String, dynamic> settingsAndValues) async {
    String url =
        '${baseUrl}?action=setsetting${generateValuePairsString(settingsAndValues)}';

    http.Response response = await _session.get(url);

    return response;
  }

  String generateValuePairsString(Map<String, dynamic> settingsAndValues) {
    String toReturn = '';

    for (MapEntry<String, dynamic> entry in settingsAndValues.entries) {
      String toAdd = '&s=${entry.key}&v=${entry.value}';
      toReturn += toAdd;
    }

    return toReturn;
  }

  @override
  Future setPropertiesOfTorrent(String torrentHash,
      {Map<String, dynamic> propertiesAndValues}) async {
    String url =
        '${baseUrl}?action=setprops${generateValuePairsString(propertiesAndValues)}';

    http.Response response = await _session.get(url);

    return response;
  }
}
