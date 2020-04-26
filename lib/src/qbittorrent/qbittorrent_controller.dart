import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:torrento/src/core/constant.dart';
import 'package:torrento/src/qbittorrent/qbittorrent_interface/qbittorrent_controller.dart';
import 'package:torrento/src/core/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:torrento/src/qbittorrent/qbittorrent_session.dart';
import 'package:torrento/src/qbittorrent/qbittorrent_util.dart';

// TODO : Add method  Get and set application preferences

class QbitTorrentControllerImpl implements QbitTorrentController {
  // API Doc at : https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information
  final String _serverIP;
  final int _serverPort;
  String _apiURL;
  Session session;

  final String API_DOC_URL =
      'https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information';

  QbitTorrentControllerImpl(this._serverIP, this._serverPort) {
    _apiURL = 'http://${_serverIP}:${_serverPort}/api/v2';
    session = Session();
  }

// Throws InvalidParameterException if status code is not 200
  void _checkForInvalidParameters(http.Response response) {
    if (response.statusCode != 200) {
      throw InvalidParameterException(response);
    }
  }

// TODO : USE THIS METHOD across all other methods TO REMOVE Many of the REDUNDANCIES
  Future<Response> _sendPostAndCheckResponse(String endPoint,
      {Map<String, dynamic> body}) async {
    Response resp = await session.post('${_apiURL}${endPoint}', body: body);
    _checkForInvalidParameters(resp);
    return resp;
  }

// TODO : USE THIS METHOD across all other methods TO REMOVE Many of the REDUNDANCIES
  Future<Response> _sendGetRequestAndCheckResponse(String endPoint,
      {Map<String, String> headers}) async {
    Response resp =
        await session.get('${_apiURL}${endPoint}', headers: headers);
    _checkForInvalidParameters(resp);
    return resp;
  }

  /// ======================== AUTH methods ==========================

  @override
  Future logIn(String username, String password) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_AUTH_LOGIN}',
        body: {Constant.username: username, Constant.password: password});

    if (resp.body.trim() == 'Fails.') {
      throw InvalidCredentialsException(resp);
    }
    _checkForInvalidParameters(resp);
  }

  @override
  Future logOut() async {
    await _sendPostAndCheckResponse(QbitTorrentApiEndPoint.API_AUTH_LOGOUT);
  }

  @override
  Future<bool> isLoggedIn() async {
    await _sendPostAndCheckResponse(QbitTorrentApiEndPoint.API_APP_VERSION);
    return true;
  }

  /// ====================  APP API methods ==========================

  @override
  Future<String> getVersion() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_APP_VERSION}');
    return resp.body;
  }

  @override
  Future<dynamic> getBuildInfo() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_APP_BUILDINFO}');
    return resp.body;
  }

  @override
  Future<String> getDefaultSavePath() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_APP_DEFAULT_SAVE_PATH}');
    return resp.body;
  }

  @override
  Future<String> getWebApiVersion() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_APP_WEBAPIVERSION}');
    return resp.body;
  }

  @override
  Future shutdownApplication() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_APP_SHUTDOWN}');
    _checkForInvalidParameters(resp);
  }

  @override
  Future<dynamic> getClientSettings() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_APP_PREFERENCES}');
    return json.decode(resp.body);
  }

  @override
  Future setClientSettings(Map<String, dynamic> jsondata) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_APP_SET_PREFERENCES}',
        body: {Constant.json: json.encode(jsondata)});
    _checkForInvalidParameters(resp);
  }

  /// ===========================  Log api methods  ======================

  @override
  Future<dynamic> getLog(
      {bool normal = true,
      bool info = true,
      bool warning = true,
      bool critical = true,
      int last_known_id = -1}) async {
    Response resp = await await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_LOG_MAIN,
        body: {
          Constant.normal: json.encode(normal),
          Constant.info: info,
          Constant.warning: warning,
          Constant.critical: critical,
          Constant.last_known_id: last_known_id
        });
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getPeerLog({int last_known_id = -1}) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_LOG_PEER}',
        body: {Constant.last_known_id: last_known_id});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  /// =======================  Sync api methods ======================

  @override
  Future<dynamic> syncMainData({String responseId = Constant.zeroDigit}) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_SYNC_MAINDATA}',
        body: {Constant.rid: responseId});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> syncTorrentPeers(
      {String responseId = Constant.zeroDigit, String torrentHash}) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_SYNC_TORRENT_PEERS}',
        body: {Constant.rid: responseId, Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  /// =======================  Transfer api methods ======================
  ///

  @override
  Future<dynamic> getTransferInfo() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_TRANSFER_INFO}');
    return json.decode(resp.body);
  }

  @override
  Future<String> getSpeedLimitsMode() async {
    Response resp = await session.get(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TRANSFER_SPEED_LIMITS_MODE}');
    return resp.body;
  }

  @override
  Future<String> toggleSpeedLimitsMode() async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TRANSFER_TOGGLE_SPEED_LIMITS}');
    return resp.body;
  }

  @override
  Future<String> getGlobalDownloadLimit() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_TRANSFER_DOWNLOAD_LIMIT}');
    return resp.body;
  }

  @override
  Future<String> setGlobalDownloadLimit(int limit) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TRANSFER_SET_DOWNLOAD_LIMIT}',
        body: {Constant.limit: limit});
    _checkForInvalidParameters(resp);
    return resp.body;
  }

  @override
  Future<String> getGlobalUploadLimit() async {
    Response resp = await session
        .get('${_apiURL}${QbitTorrentApiEndPoint.API_TRANSFER_UPLOAD_LIMIT}');
    return resp.body;
  }

  @override
  Future<String> setGlobalUploadLimit(int limit) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TRANSFER_SET_UPLOAD_LIMIT}',
        body: {Constant.limit: limit});
    _checkForInvalidParameters(resp);
    return resp.body;
  }

  @override
  Future<String> banPeers(List<String> peers) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TRANSFER_BAN_PEERS}',
        body: {Constant.peers: peers.join('|')});
    _checkForInvalidParameters(resp);
    return resp.body;
  }

  /// =======================  Torrent api methods ======================

  @override
  Future<List> getTorrentsList(
      {TorrentFilter filter,
      String category,
      String sort,
      bool reverse,
      int limit,
      int offset,
      List<String> hashes}) async {
    final Map<String, dynamic> body = {};
    if (filter != null) {
      body[Constant.filter] = filter.toString().split('.').last;
    }
    if (category != null) {
      body[Constant.category] = category;
    }
    if (sort != null) {
      body[Constant.sort] = sort;
    }
    if (reverse != null) {
      body[Constant.reverse] = reverse.toString();
    }
    if (offset != null) {
      body[Constant.offset] = offset.toString();
    }
    if (hashes != null) {
      body[Constant.hashes] = hashes.join('|');
    }

    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_INFO}',
        body: body);
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentProperties(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_PROPERTIES}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentTrackers(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_TRACKERS}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentWebSeeds(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_WEBSEEDS}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentContents(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_FILES}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentPieceStates(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_PIECE_STATES}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentPieceHashes(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_PIECE_HASHES}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<void> pauseMultipleTorrents(List<String> torrentHashs) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_PAUSE}',
        body: {Constant.hashes: torrentHashs.join('|')});
    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> pauseTorrent(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_PAUSE}',
        body: {Constant.hashes: torrentHash});
    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> resumeTorrent(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_RESUME}',
        body: {Constant.hashes: torrentHash});
    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> resumeMultipleTorrents(List<String> torrentHashs) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_RESUME}',
        body: {Constant.hashes: torrentHashs.join('|')});
    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> removeTorrent(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_DELETE}',
        body: {Constant.hashes: torrentHash, Constant.deleteFiles: false});
    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> removeMultipleTorrents(List<String> torrentHashs) async {
    Response resp = await session
        .post('${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_DELETE}', body: {
      Constant.hashes: torrentHashs.join('|'),
      Constant.deleteFiles: false
    });

    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> removeMultipleTorrentsWithData(List<String> torrentHashs) async {
    Response resp = await session
        .post('${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_DELETE}', body: {
      Constant.hashes: torrentHashs.join('|'),
      Constant.deleteFiles: Constant.trueString
    });
    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> recheckMultipleTorrents(List<String> torrentHashs) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_RECHECK}',
        body: {Constant.hashes: torrentHashs.join('|')});
    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> recheckTorrent(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_RECHECK}',
        body: {Constant.hashes: torrentHash});
    _checkForInvalidParameters(resp);
  }

  @override
  Future<String> reannounceTorrents(List<String> torrentHashs) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_REANNOUNCE}',
        body: {Constant.hashes: torrentHashs.join('|')});
    _checkForInvalidParameters(resp);
    return (resp.body);
  }

  ///TODO : ADD TORRENT HAS TO BE REDESIGNED PROPERLY
  @override
  Future addTorrents(List<String> urls,
      {String torrentFileContent,
      String savepath,
      String cookie,
      String category,
      bool skip_checking = false,
      bool paused = false,
      bool root_folder = false,
      String rename,
      int uploadLimit,
      int downloadLimit,
      bool useAutoTMM,
      bool sequentialDownload = false,
      bool prioritizeFirstLastPiece = false}) async {
    final Map<String, dynamic> body = {
      Constant.urls: urls.join('%0A'),
    };

    if (torrentFileContent != null) {
      body[Constant.torrents] = torrentFileContent;
    }
    if (skip_checking != null) {
      body[Constant.skip_checking] = skip_checking;
    }
    if (paused != null) {
      body[Constant.paused] = paused;
    }
    if (root_folder != null) {
      body[Constant.root_folder] = root_folder;
    }
    if (sequentialDownload != null) {
      body[Constant.sequentialDownload] = sequentialDownload;
    }
    if (prioritizeFirstLastPiece != null) {
      body[Constant.firstLastPiecePrio] = prioritizeFirstLastPiece;
    }

    if (savepath != null) {
      body[Constant.savePath] = savepath;
    }
    if (cookie != null) {
      body[Constant.cookie] = cookie;
    }
    if (category != null) {
      body[Constant.category] = category;
    }
    if (rename != null) {
      body[Constant.rename] = rename;
    }
    if (uploadLimit != null) {
      body[Constant.upLimit] = uploadLimit;
    }
    if (downloadLimit != null) {
      body[Constant.dlLimit] = downloadLimit;
    }
    if (useAutoTMM != null) {
      body[Constant.useAutoTMM] = useAutoTMM;
    }
    if (torrentFileContent == null) {
      body.remove(Constant.torrents);
    }

    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_ADD}',
        body: body);
    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> addTorrentTrackers(String torrentHash,
      List<String> trackers) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_ADD_TRACKERS}',
        body: {
          Constant.hash: torrentHash,
          Constant.urls: trackers.join('%0A')
        });
    _checkForInvalidParameters(resp);
  }

  ///See docs for response code meaning
  @override
  Future<void> editTorrentTrackers(String torrentHash, List<String> oldTrackers,
      List<String> newTrackers) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_EDIT_TRACKERS}',
        body: {
          Constant.hash: torrentHash,
          Constant.origUrl: oldTrackers.join('%0A'),
          Constant.newUrl: newTrackers.join('%0A')
        });
    _checkForInvalidParameters(resp);
  }

  ///See docs for response code meaning
  @override
  Future<void> removeTorrentTrackers(
      String torrentHash, List<String> trackers) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_REMOVE_TRACKERS}',
        body: {Constant.hash: torrentHash, Constant.urls: trackers.join('|')});
    _checkForInvalidParameters(resp);
  }

  /// Returns true if successfully added
  @override
  Future<void> addTorrentPeers(List<String> torrentHashes,
      List<String> peers) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_ADD_PEERS}',
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.peers: peers.join('|')
        });

    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> startTorrent(String torrentHash) async {
    await resumeTorrent(torrentHash);
  }

  @override
  Future<void> startMultipleTorrents(List<String> torrentHashes) async {
    await resumeMultipleTorrents(torrentHashes);
  }

  @override
  Future<void> stopTorrent(String torrentHash) async {
    await pauseTorrent(torrentHash);
  }

  @override
  Future<void> stopMultipleTorrents(List<String> torrentHashes) async {
    await pauseMultipleTorrents(torrentHashes);
  }

  @override
  String getApiDocUrl() {
    return API_DOC_URL;
  }

  @override
  Future<void> pauseAllTorrents() async {
    await pauseMultipleTorrents([Constant.all]);
  }

  @override
  Future<void> recheckAllTorrents() async {
    await recheckMultipleTorrents([Constant.all]);
  }

  @override
  Future<void> removeAllTorrents() async {
    await removeMultipleTorrents([Constant.all]);
  }

  @override
  Future<void> resumeAllTorrents() async {
    await resumeMultipleTorrents([Constant.all]);
  }

  @override
  Future<void> startAllTorrents() async {
    await startMultipleTorrents([Constant.all]);
  }

  @override
  Future<void> stopAllTorrents() async {
    await stopMultipleTorrents([Constant.all]);
  }

  @override
  Future<void> addNewCategory(String category, String savePath) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_CREATE_CATEGORY}',
        body: {Constant.category: category, Constant.savePath: savePath});

    _checkForInvalidParameters(resp);
  }

  @override
  Future<void> addTorrentTags(List<String> torrentHashes,
      List<String> tags) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_ADD_TAGS}',
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.tags: tags.join(',')
        });

    _checkForInvalidParameters(resp);
  }

  @override
  Future createTags(List<String> tags) async {
    Response resp = await session.post(
        '${_apiURL}${QbitTorrentApiEndPoint.API_TORRENT_CREATE_TAGS}',
        body: {Constant.tags: tags.join(',')});

    _checkForInvalidParameters(resp);
  }

  @override
  Future deleteTags(List<String> tags) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_DELETE_TAGS,
        body: {Constant.tags: tags.join(',')});
  }

  @override
  Future<void> decreasePriority(List<String> torrentHashes) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_DECREASE_PRIORITY,
        body: {Constant.hashes: torrentHashes.join('|')});
  }

  @override
  Future<void> editCategory(String category, String newSavePath) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_EDIT_CATEGORY,
        body: {Constant.category: category, Constant.savePath: newSavePath});
  }

  @override
  Future<void> forceStartTorrent(String torrentHash) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_FORCE_START,
        body: {Constant.hashes: torrentHash});
  }

  @override
  Future<void> forceStartMultipleTorrents(List<String> torrentHashes) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_FORCE_START,
        body: {Constant.hashes: torrentHashes.join('|')});
  }

  @override
  Future<dynamic> getAllCategories() async {
    return (await _sendGetRequestAndCheckResponse(
            QbitTorrentApiEndPoint.API_TORRENT_CATEGORY))
        .body;
  }

  @override
  Future<List<String>> getAllTags() async {
    return (await _sendGetRequestAndCheckResponse(
            QbitTorrentApiEndPoint.API_TORRENT_TAGS))
        .body
        ?.split(',');
  }

  @override
  Future<String> getDownloadLimit(List<String> torrentHashes) async {
    Response resp = await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_DOWNLOAD_LIMIT,
        body: {Constant.hashes: torrentHashes.join('|')});
    return resp.body;
  }

  @override
  Future<List<dynamic>> getFilesOfTorrent(String torrentHash) async {
    Response resp = await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_FILES, body: {
      Constant.hash: torrentHash,
    });
    return json.decode(resp.body);
  }

  @override
  Future<String> getUploadLimit(List<String> torrentHashes) async {
    Response resp = await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_UPLOAD_LIMIT,
        body: {Constant.hashes: torrentHashes.join('|')});
    return resp.body;
  }

  @override
  Future<void> increasePriority(List<String> torrentHashes) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_INCREASE_PRIORITY,
        body: {Constant.hashes: torrentHashes.join('|')});
  }

  @override
  Future<void> removeTorrentAndData(String torrentHash) async {
    await removeMultipleTorrentsAndData([torrentHash]);
  }

  @override
  Future<void> removeMultipleTorrentsAndData(List<String> torrentHashes) async {
    await _sendPostAndCheckResponse(QbitTorrentApiEndPoint.API_TORRENT_DELETE,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.deleteFiles: Constant.trueString
        });
  }

  @override
  Future<void> removeCategories(List<String> categories) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_REMOVE_CATEGORY,
        body: {
          Constant.categories: categories.join('\n'),
        });
  }

  @override
  Future<void> removeTorrentTags(
      List<String> torrentHashes, List<String> tags) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_DELETE_TAGS,
        body: {
          Constant.tags: tags.join(','),
        });
  }

  @override
  Future<void> setAutoTorrentManagement(
      List<String> torrentHashes, bool enable) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_AUTOMANAGEMENT,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.enable: enable
        });
  }

  @override
  Future<void> setCategory(List<String> torrentHashes, String category) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_CATEGORY,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.category: category
        });
  }

  @override
  Future<void> setTorrentDownloadLimit(
      List<String> torrentHashes, int limitInBytesPerSecond) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_DOWNLOAD_LIMIT,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.limit: limitInBytesPerSecond
        });
  }

  @override
  Future<void> setFirstOrLastPiecePriority(List<String> torrentHashes) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_TOGGLE_FIRST_LAST_PRIO,
        body: {
          Constant.hashes: torrentHashes.join('|'),
        });
  }

  @override
  Future<void> setForceStart(List<String> torrentHashes, bool value) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_FORCE_START,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.value: value
        });
  }

  @override
  Future<void> setMaxPriority(List<String> torrentHashes) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_TOP_PRIORITY,
        body: {
          Constant.hashes: torrentHashes.join('|'),
        });
  }

  @override
  Future<void> setMinPriority(List<String> torrentHashes) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_BOTTOM_PRIORITY,
        body: {
          Constant.hashes: torrentHashes.join('|'),
        });
  }

  @override
  Future<void> setTorrentProperties(String torrentHash,
      {Map<String, dynamic> propertiesAndValues}) async {
    //TODO : Implement this
    throw UnimplementedError(
        'This method is not implemented. Please use the other methods that enable setting some specific properties of the torrents');
  }

  @override
  Future<void> setShareLimit(List<String> torrentHashes, double ratioLimit,
      int seedingTimeLimit) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_SHARE_LIMIT,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.ratioLimit: ratioLimit,
          Constant.seedingTimeLimit: seedingTimeLimit
        });
  }

  @override
  Future<void> setSuperSeeding(List<String> torrentHashes, bool value) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_SUPER_SEEDING,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.value: value,
        });
  }

  @override
  Future<void> setTorrentName(String torrentHash, String name) async {
    await _sendPostAndCheckResponse(QbitTorrentApiEndPoint.API_TORRENT_RENAME,
        body: {
          Constant.hash: torrentHash,
          Constant.name: name,
        });
  }

  @override
  Future<void> setTorrentUploadLimit(
      List<String> torrentHashes, int limitInBytesPerSecond) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_UPLOAD_LIMIT,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.limit: limitInBytesPerSecond,
        });
  }

  @override
  Future<void> setfilePriority(
      String torrentHash, List<String> fileIds, int priority) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_SET_FILE_PRIORITY,
        body: {
          Constant.hash: torrentHash,
          Constant.id: fileIds.join('|'),
          Constant.priority: priority,
        });
  }

  @override
  Future<void> toggleSequentialDownload(List<String> torrentHashes) async {
    await _sendPostAndCheckResponse(
        QbitTorrentApiEndPoint.API_TORRENT_TOGGLE_SEQUENTIAL_DOWNLOAD,
        body: {
          Constant.hashes: torrentHashes.join('|'),
        });
  }

  @override
  Future<void> addTorrent(String url,
      {String torrentFileContent,
        String savePath,
      String cookie,
      String category,
      bool skip_checking = false,
      bool paused = false,
      bool root_folder = false,
      String rename,
      int uploadLimit,
      int downloadLimit,
      bool useAutoTMM,
      bool sequentialDownload = false,
      bool prioritizeFirstLastPiece = false}) async {
    await addTorrents([url],
        torrentFileContent: torrentFileContent,
        savepath: savePath,
        cookie: cookie,
        category: category,
        skip_checking: skip_checking,
        paused: paused,
        root_folder: root_folder,
        rename: rename,
        uploadLimit: uploadLimit,
        downloadLimit: downloadLimit,
        useAutoTMM: useAutoTMM,
        sequentialDownload: sequentialDownload,
        prioritizeFirstLastPiece: prioritizeFirstLastPiece);
  }
}
