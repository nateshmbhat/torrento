import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:torrento/src/core/constant.dart';
import 'package:torrento/src/core/contracts/qbittorrent_controller/qbittorrent_controller.dart';
import 'package:torrento/src/core/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:torrento/src/torrent_client_controllers/qbittorrent/session.dart';
import 'package:torrento/src/torrent_client_controllers/qbittorrent/utils.dart';

enum TorrentFilter {
  all,
  downloading,
  completed,
  paused,
  active,
  inactive,
  resumed
}

// TODO : Add method  Get and set application preferences

// TODO : check if all API end points in the ApiEndPoint class are used in the implemention . Any missing end point in the implementation needs to be added to the QBitTorrentController interface

class QbitTorrentControllerImpl implements QbitTorrentController {
  /// API Doc at : https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information
  String _serverIP;
  int _serverPort;
  String _apiURL;
  Session session;

  final String API_DOC_URL =
      'https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information';

  QbitTorrentControllerImpl(this._serverIP, this._serverPort){
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
        '${_apiURL}${ApiEndPoint.API_AUTH_LOGIN}',
        body: {Constant.username: username, Constant.password: password});

    if (resp.body.trim() == "Fails.") throw InvalidCredentialsException(resp);
    _checkForInvalidParameters(resp);
  }

  @override
  Future logOut() async {
    _sendPostAndCheckResponse(ApiEndPoint.API_AUTH_LOGOUT);
  }

  @override
  Future<bool> isLoggedIn() async {
    _sendPostAndCheckResponse(ApiEndPoint.API_APP_VERSION);
    return true;
  }

  /// ====================  APP API methods ==========================

  @override
  Future<String> getVersion() async {
    Response resp =
        await session.get('${_apiURL}${ApiEndPoint.API_APP_VERSION}');
    return resp.body;
  }

  @override
  Future<dynamic> getBuildInfo() async {
    Response resp =
        await session.get('${_apiURL}${ApiEndPoint.API_APP_BUILDINFO}');
    return resp.body;
  }

  @override
  Future<String> getDefaultSavePath() async {
    Response resp =
        await session.get('${_apiURL}${ApiEndPoint.API_APP_DEFAULT_SAVE_PATH}');
    return resp.body;
  }

  @override
  Future<String> getWebApiVersion() async {
    Response resp =
        await session.get('${_apiURL}${ApiEndPoint.API_APP_WEBAPIVERSION}');
    return resp.body;
  }

  @override
  Future shutdownApplication() async {
    Response resp =
        await session.get('${_apiURL}${ApiEndPoint.API_APP_SHUTDOWN}');
    _checkForInvalidParameters(resp);
  }

  @override
  Future<dynamic> getClientSettings() async {
    Response resp =
        await session.get('${_apiURL}${ApiEndPoint.API_APP_PREFERENCES}');
    return json.decode(resp.body);
  }

  @override
  Future setClientSettings(Map<String, dynamic> jsondata) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_APP_SET_PREFERENCES}',
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
    Response resp =
        await _sendPostAndCheckResponse(ApiEndPoint.API_LOG_MAIN, body: {
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
    Response resp = await session.post('${_apiURL}${ApiEndPoint.API_LOG_PEER}',
        body: {Constant.last_known_id: last_known_id});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  /// =======================  Sync api methods ======================

  @override
  Future<dynamic> syncMainData({String responseId = Constant.zeroDigit}) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_SYNC_MAINDATA}',
        body: {Constant.rid: responseId});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> syncTorrentPeers(
      {String responseId = Constant.zeroDigit, String torrentHash}) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_SYNC_TORRENT_PEERS}',
        body: {Constant.rid: responseId, Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  /// =======================  Transfer api methods ======================
  ///

  @override
  Future<dynamic> getTransferInfo() async {
    Response resp =
        await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_INFO}');
    return json.decode(resp.body);
  }

  @override
  Future<String> getSpeedLimitsMode() async {
    Response resp = await session
        .get('${_apiURL}${ApiEndPoint.API_TRANSFER_SPEED_LIMITS_MODE}');
    return resp.body;
  }

  @override
  Future<String> toggleSpeedLimitsMode() async {
    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TRANSFER_TOGGLE_SPEED_LIMITS}');
    return resp.body;
  }

  @override
  Future<String> getGlobalDownloadLimit() async {
    Response resp = await session
        .get('${_apiURL}${ApiEndPoint.API_TRANSFER_DOWNLOAD_LIMIT}');
    return resp.body;
  }

  @override
  Future<String> setGlobalDownloadLimit(int limit) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TRANSFER_SET_DOWNLOAD_LIMIT}',
        body: {Constant.limit: limit});
    _checkForInvalidParameters(resp);
    return resp.body;
  }

  @override
  Future<String> getGlobalUploadLimit() async {
    Response resp =
        await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_UPLOAD_LIMIT}');
    return resp.body;
  }

  @override
  Future<String> setGlobalUploadLimit(int limit) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TRANSFER_SET_UPLOAD_LIMIT}',
        body: {Constant.limit: limit});
    _checkForInvalidParameters(resp);
    return resp.body;
  }

  @override
  Future<String> banPeers(List<String> peers) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TRANSFER_BAN_PEERS}',
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
    if (filter != null)
      body[Constant.filter] = filter.toString().split('.').last;
    if (category != null) body[Constant.category] = category;
    if (sort != null) body[Constant.sort] = sort;
    if (reverse != null) body[Constant.reverse] = reverse.toString();
    if (offset != null) body[Constant.offset] = offset.toString();
    if (hashes != null) body[Constant.hashes] = hashes.join('|');

    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TORRENT_INFO}', body: body);
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentProperties(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_PROPERTIES}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentTrackers(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_TRACKERS}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentWebSeeds(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_WEBSEEDS}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentContents(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_FILES}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentPieceStates(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_PIECE_STATES}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getTorrentPieceHashes(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_PIECE_HASHES}',
        body: {Constant.hash: torrentHash});
    _checkForInvalidParameters(resp);
    return json.decode(resp.body);
  }

  @override
  Future pauseMultipleTorrents(List<String> torrentHashs) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_PAUSE}',
        body: {Constant.hashes: torrentHashs.join('|')});
    _checkForInvalidParameters(resp);
  }

  @override
  Future pauseTorrent(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_PAUSE}',
        body: {Constant.hashes: torrentHash});
    _checkForInvalidParameters(resp);
  }

  @override
  Future resumeTorrent(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_RESUME}',
        body: {Constant.hashes: torrentHash});
    _checkForInvalidParameters(resp);
  }

  @override
  Future resumeMultipleTorrents(List<String> torrentHashs) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_RESUME}',
        body: {Constant.hashes: torrentHashs.join('|')});
    _checkForInvalidParameters(resp);
  }

  @override
  Future removeTorrent(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}',
        body: {Constant.hashes: torrentHash, Constant.deleteFiles: false});
    _checkForInvalidParameters(resp);
  }

  @override
  Future removeMultipleTorrents(List<String> torrentHashs) async {
    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}', body: {
      Constant.hashes: torrentHashs.join('|'),
      Constant.deleteFiles: false
    });

    _checkForInvalidParameters(resp);
  }

  @override
  Future removeMultipleTorrentsWithData(List<String> torrentHashs) async {
    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}', body: {
      Constant.hashes: torrentHashs.join('|'),
      Constant.deleteFiles: Constant.trueString
    });
    _checkForInvalidParameters(resp);
  }

  @override
  Future recheckMultipleTorrents(List<String> torrentHashs) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_RECHECK}',
        body: {Constant.hashes: torrentHashs.join('|')});
    _checkForInvalidParameters(resp);
  }

  @override
  Future recheckTorrent(String torrentHash) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_RECHECK}',
        body: {Constant.hashes: torrentHash});
    _checkForInvalidParameters(resp);
  }

  Future<String> reannounceTorrents(List<String> torrentHashs) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_REANNOUNCE}',
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

    if (torrentFileContent != null)
      body[Constant.torrents] = torrentFileContent;
    if (skip_checking != null)
      body[Constant.skip_checking] = skip_checking;
    if (paused != null) body[Constant.paused] = paused;
    if (root_folder != null)
      body[Constant.root_folder] = root_folder;
    if (sequentialDownload != null)
      body[Constant.sequentialDownload] = sequentialDownload;
    if (prioritizeFirstLastPiece != null)
      body[Constant.firstLastPiecePrio] = prioritizeFirstLastPiece;

    if (savepath != null) body[Constant.savePath] = savepath;
    if (cookie != null) body[Constant.cookie] = cookie;
    if (category != null) body[Constant.category] = category;
    if (rename != null) body[Constant.rename] = rename;
    if (uploadLimit != null) body[Constant.upLimit] = uploadLimit;
    if (downloadLimit != null)
      body[Constant.dlLimit] = downloadLimit;
    if (useAutoTMM != null) body[Constant.useAutoTMM] = useAutoTMM;
    if (torrentFileContent == null) body.remove(Constant.torrents);

    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD}', body: body);
    _checkForInvalidParameters(resp);
  }

  @override
  Future addTorrentTrackers(String torrentHash, List<String> trackers) async {
    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD_TRACKERS}', body: {
      Constant.hash: torrentHash,
      Constant.urls: trackers.join('%0A')
    });
    _checkForInvalidParameters(resp);
  }

  ///See docs for response code meaning
  @override
  Future editTorrentTrackers(String torrentHash, List<String> oldTrackers,
      List<String> newTrackers) async {
    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TORRENT_EDIT_TRACKERS}', body: {
      Constant.hash: torrentHash,
      Constant.origUrl: oldTrackers.join('%0A'),
      Constant.newUrl: newTrackers.join('%0A')
    });
    _checkForInvalidParameters(resp);
  }

  ///See docs for response code meaning
  @override
  Future removeTorrentTrackers(
      String torrentHash, List<String> trackers) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_REMOVE_TRACKERS}',
        body: {Constant.hash: torrentHash, Constant.urls: trackers.join('|')});
    _checkForInvalidParameters(resp);
  }

  /// Returns true if successfully added
  @override
  Future addTorrentPeers(List<String> torrentHashes, List<String> peers) async {
    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD_PEERS}', body: {
      Constant.hashes: torrentHashes.join('|'),
      Constant.peers: peers.join('|')
    });

    _checkForInvalidParameters(resp);
  }

  @override
  Future startTorrent(String torrentHash) async {
    resumeTorrent(torrentHash);
  }

  @override
  Future startMultipleTorrents(List<String> torrentHashes) async {
    resumeMultipleTorrents(torrentHashes);
  }

  @override
  Future stopTorrent(String torrentHash) async {
    pauseTorrent(torrentHash);
  }

  @override
  Future stopMultipleTorrents(List<String> torrentHashes) async {
    pauseMultipleTorrents(torrentHashes);
  }

  @override
  String getApiDocUrl() {
    return API_DOC_URL;
  }

  @override
  Future pauseAllTorrents() async {
    await pauseMultipleTorrents([Constant.all]);
  }

  @override
  Future recheckAllTorrents() async {
    await recheckMultipleTorrents([Constant.all]);
  }

  @override
  Future removeAllTorrents() async {
    await removeMultipleTorrents([Constant.all]);
  }

  @override
  Future resumeAllTorrents() async {
    await resumeMultipleTorrents([Constant.all]);
  }

  @override
  Future startAllTorrents() async {
    await startMultipleTorrents([Constant.all]);
  }

  @override
  Future stopAllTorrents() async {
    await stopMultipleTorrents([Constant.all]);
  }

  // TODO : TEST ALL THE BELOW METHODS

  @override
  Future addNewCategory(String category, String savePath) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_CREATE_CATEGORY}',
        body: {Constant.category: category, Constant.savePath: savePath});

    _checkForInvalidParameters(resp);
  }

  @override
  Future addTorrentTags(List<String> torrentHashes, List<String> tags) async {
    Response resp = await session
        .post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD_TAGS}', body: {
      Constant.hashes: torrentHashes.join('|'),
      Constant.tags: tags.join(',')
    });

    _checkForInvalidParameters(resp);
  }

  @override
  Future createTags(List<String> tags) async {
    Response resp = await session.post(
        '${_apiURL}${ApiEndPoint.API_TORRENT_CREATE_TAGS}',
        body: {Constant.tags: tags.join(',')});

    _checkForInvalidParameters(resp);
  }

  @override
  Future deleteTags(List<String> tags) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_DELETE_TAGS,
        body: {Constant.tags: tags.join(',')});
  }

  @override
  Future decreasePriority(List<String> torrentHashes) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_DECREASE_PRIORITY,
        body: {Constant.hashes: torrentHashes.join('|')});
  }

  @override
  Future editCategory(String category, String newSavePath) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_EDIT_CATEGORY,
        body: {Constant.category: category, Constant.savePath: newSavePath});
  }

  

  @override
  Future forceStartTorrent(String torrentHash) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_FORCE_START,
        body: {Constant.hashes: torrentHash});
  }

  @override
  Future forceStartMultipleTorrents(List<String> torrentHashes) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_FORCE_START,
        body: {Constant.hashes: torrentHashes.join('|')});
  }

  @override
  Future getAllCategories() async {
    return (await _sendGetRequestAndCheckResponse(
            ApiEndPoint.API_TORRENT_CATEGORY))
        .body;
  }

  @override
  Future<List<String>> getAllTags() async {
    return (await _sendGetRequestAndCheckResponse(ApiEndPoint.API_TORRENT_TAGS))
        .body
        ?.split(',');
  }

  @override
  Future getDownloadLimit(List<String> torrentHashes) async {
    Response resp = await _sendPostAndCheckResponse(
        ApiEndPoint.API_TORRENT_DOWNLOAD_LIMIT,
        body: {Constant.hashes: torrentHashes.join('|')});
    return resp.body;
  }

// TODO : Implement this 
  @override
  Future getListOfFilesUnderATorrentJob(String torrentHash) async {

  }

  @override
  Future getPropertiesOfTorrent(String torrentHash) async {
    return getTorrentProperties(torrentHash);
  }

  @override
  Future getUploadLimit(List<String> torrentHashes) async {
    Response resp = await _sendPostAndCheckResponse(
        ApiEndPoint.API_TORRENT_UPLOAD_LIMIT,
        body: {Constant.hashes: torrentHashes.join('|')});
    return resp.body;
  }

  @override
  Future increasePriority(List<String> torrentHashes) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_INCREASE_PRIORITY,
        body: {Constant.hashes: torrentHashes.join('|')});
  }

  @override
  Future removeTorrentAndData(String torrentHash) async {
    removeMultipleTorrentsAndData([torrentHash]);
  }

  @override
  Future removeMultipleTorrentsAndData(List<String> torrentHashes) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_DELETE, body: {
      Constant.hashes: torrentHashes.join('|'),
      Constant.deleteFiles: Constant.trueString
    });
  }

// TODO : Test and check if "\n" works or should be replaced by "%0A"
  @override
  Future removeCategories(List<String> categories) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_REMOVE_CATEGORY, body: {
      Constant.categories: categories.join('\n'),
    });
  }

  @override
  Future removeTorrentTags(
      List<String> torrentHashes, List<String> tags) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_DELETE_TAGS, body: {
      Constant.tags: tags.join(','),
    });
  }

  @override
  Future setAutoTorrentManagement(
      List<String> torrentHashes, bool enable) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_AUTOMANAGEMENT,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.enable: enable
        });
  }

  @override
  Future setCategory(List<String> torrentHashes, String category) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_CATEGORY, body: {
      Constant.hashes: torrentHashes.join('|'),
      Constant.category: category
    });
  }

  @override
  Future setTorrentDownloadLimit(
      List<String> torrentHashes, int limitInBytesPerSecond) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_DOWNLOAD_LIMIT,
        body: {
          Constant.hashes: torrentHashes.join('|'),
          Constant.limit: limitInBytesPerSecond
        });
  }

  @override
  Future setFirstOrLastPiecePriority(List<String> torrentHashes) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_TOGGLE_FIRST_LAST_PRIO,
        body: {
          Constant.hashes: torrentHashes.join('|'),
        });
  }

  @override
  Future setForceStart(List<String> torrentHashes, bool value) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_FORCE_START, body: {
      Constant.hashes: torrentHashes.join('|'),
      Constant.value: value
    });
  }

  @override
  Future setMaxPriority(List<String> torrentHashes) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_TOP_PRIORITY, body: {
      Constant.hashes: torrentHashes.join('|'),
    });
  }

  @override
  Future setMinPriority(List<String> torrentHashes) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_BOTTOM_PRIORITY, body: {
      Constant.hashes: torrentHashes.join('|'),
    });
  }

// TODO : Propose change of name in the interface to setTorrentProperties 
  @override
  Future setPropertiesOfTorrent(String torrentHash,
      {Map<String, dynamic> propertiesAndValues}) async {

  }

  @override
  Future setShareLimit(
      List<String> torrentHashes, double ratioLimit, int seedingTimeLimit) async {

        _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_SHARE_LIMIT , 
        body : {
          Constant.hashes : torrentHashes.join('|') , 
          Constant.ratioLimit : ratioLimit , 
          Constant.seedingTimeLimit : seedingTimeLimit 
        });
  }

  @override
  Future setSuperSeeding(List<String> torrentHashes, bool value) async {
        _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_SUPER_SEEDING, 
        body : {
          Constant.hashes : torrentHashes.join('|') , 
          Constant.value : value , 
        });
  }

  @override
  Future setTorrentName(String torrentHash, String name) async {
_sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_RENAME, 
        body : {
          Constant.hash : torrentHash , 
          Constant.name : name , 
        });
  }

  @override
  Future setTorrentUploadLimit(List<String> torrentHashes, int limitInBytesPerSecond) async {
_sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_UPLOAD_LIMIT, 
        body : {
          Constant.hashes : torrentHashes.join('|') , 
          Constant.limit : limitInBytesPerSecond, 
        });
  }

  @override
  Future setfilePriority(
      String torrentHash, List<String> fileIds, int priority) async {

_sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_SET_FILE_PRIORITY, 
        body : {
          Constant.hash : torrentHash , 
          Constant.id : fileIds.join('|'), 
          Constant.priority : priority , 
        });
  }

  @override
  Future toggleSequentialDownload(List<String> torrentHashes) async {
    _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_TOGGLE_SEQUENTIAL_DOWNLOAD, 
        body : {
          Constant.hashes : torrentHashes.join('|') , 
        });
  }


  // @override
  // Future (List<String> torrentHashes) async {
  //   _sendPostAndCheckResponse(ApiEndPoint.API_TORRENT_RESUME, 
  //       body : {
  //         Constant.hashes : torrentHashes.join('|'), 
  //       });
  // }

  @override
  Future addTorrent(String url,
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
    addTorrents([url],
        torrentFileContent: torrentFileContent,
        savepath: savepath,
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
