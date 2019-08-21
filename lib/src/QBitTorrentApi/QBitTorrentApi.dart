import 'dart:async';
import 'dart:convert';
import '../Session.dart';
import 'package:http/http.dart' as http;



enum TorrentFilter{
  all , downloading  , completed , paused , active  , inactive , resumed
}



class QBitTorrentAPI {
  /// API Doc at : https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information
  String _serverIP;
  int _serverPort;
  String _apiURL;
  Session session;

  final API_AUTH_LOGIN = '/auth/login';
  final API_AUTH_LOGOUT = '/auth/logout';

  final API_APP_VERSION = '/app/version';
  final API_APP_BUILDINFO = '/app/buildInfo';
  final API_APP_SHUTDOWN = '/app/shutdown';
  final API_APP_PREFERENCES = '/app/preferences';
  final API_APP_DEFAULT_SAVE_PATH = '/app/defaultSavePath';
  final API_APP_SET_PREFERENCES = '/app/setPreferences';
  final API_APP_WEBAPIVERSION = '/app/webapiVersion';

  final API_LOG_MAIN = '/log/main';
  final API_LOG_PEER = '/log/peers';

  final API_SYNC_MAINDATA = '/sync/maindata';
  final API_SYNC_TORRENT_PEERS = '/sync/torrentPeers';

  final API_TRANSFER_INFO = '/transfer/info';
  final API_TRANSFER_SPEED_LIMITS_MODE = '/transfer/speedLimitsMode';
  final API_TRANSFER_TOGGLE_SPEED_LIMITS = '/transfer/toggleSpeedLimitsMode';
  final API_TRANSFER_DOWNLOAD_LIMIT = '/transfer/downloadLimit';
  final API_TRANSFER_SET_DOWNLOAD_LIMIT = '/transfer/setDownloadLimit';
  final API_TRANSFER_UPLOAD_LIMIT = '/transfer/uploadLimit';
  final API_TRANSFER_SET_UPLOAD_LIMIT = '/transfer/setUploadLimit';
  final API_TRANSFER_BAN_PEERS= '/transfer/banPeers';

  final API_TORRENT_INFO = '/torrents/info';
  final API_TORRENT_PROPERTIES = '/torrents/properties';
  final API_TORRENT_TRACKERS = '/torrents/trackers';
  final API_TORRENT_WEBSEEDS = '/torrents/webseeds';
  final API_TORRENT_FILES = '/torrents/files';
  final API_TORRENT_PIECE_STATES = '/torrents/pieceStates';
  final API_TORRENT_PIECE_HASHES = '/torrents/pieceHashes';
  final API_TORRENT_PAUSE = '/torrents/pause';
  final API_TORRENT_RESUME = '/torrents/resume';
  final API_TORRENT_DELETE = '/torrents/delete';
  final API_TORRENT_RECHECK = '/torrents/recheck';
  final API_TORRENT_REANNOUNCE = '/torrents/reannounce';
  final API_TORRENT_ADD = '/torrents/add';
  final API_TORRENT_ADD_TRACKERS = '/torrents/addTrackers';
  final API_TORRENT_ADD_PEERS = '/torrents/addPeers';
  final API_TORRENT_EDIT_TRACKERS = '/torrents/editTracker';

  final API_TORRENT_REMOVE_TRACKERS = '/torrents/removeTrackers' ; 

  final API_TORRENT_INCREASE_PRIORITY = '/torrents/increasePrio';
  final API_TORRENT_DECREASE_PRIORITY = '/torrents/decreasePrio';
  final API_TORRENT_TOP_PRIORITY = '/torrents/topPrio';
  final API_TORRENT_BOTTOM_PRIORITY = '/torrents/bottomPrio';
  final API_TORRENT_SET_FILE_PRIORITY = '/torrents/filePrio';
  final API_TORRENT_DOWNLOAD_LIMIT = '/torrents/downloadLimit';
  final API_TORRENT_UPLOAD_LIMIT = '/torrents/uploadLimit';
  final API_TORRENT_SET_DOWNLOAD_LIMIT = '/torrents/setDownloadLimit';
  final API_TORRENT_SET_UPLOAD_LIMIT = '/torrents/setUploadLimit';
  final API_TORRENT_SET_SHARE_LIMIT = '/torrents/setShareLimits';
  final API_TORRENT_SET_LOCATION = '/torrents/setLocation';
  final API_TORRENT_RENAME = '/torrents/rename';
  final API_TORRENT_CATEGORY = '/torrents/categories';
  final API_TORRENT_CREATE_CATEGORY = '/torrents/createCategory';
  final API_TORRENT_SET_CATEGORY = '/torrents/setCategory';
  final API_TORRENT_EDIT_CATEGORY = '/torrents/editCategory';
  final API_TORRENT_REMOVE_CATEGORY = '/torrents/removeCategories';
  final API_TORRENT_ADD_TAGS = '/torrents/addTags';
  final API_TORRENT_REMOVE_TAGS = '/torrents/removeTags';
  final API_TORRENT_TAGS = '/torrents/tags';
  final API_TORRENT_CREATE_TAGS = '/torrents/createTags';
  final API_TORRENT_DELETE_TAGS = '/torrents/deleteTags';
  final API_TORRENT_SET_AUTOMANAGEMENT = '/torrents/setAutoManagement';
  final API_TORRENT_TOGGLE_SEQUENTIAL_DOWNLOAD =
      '/torrents/toggleSequentialDownload';
  final API_TORRENT_TOGGLE_FIRST_LAST_PRIO =
      '/torrents/toggleFirstLastPiecePrio';
  final API_TORRENT_SET_FORCE_START = '/torrents/setForceStart';
  final API_TORRENT_SET_SUPER_SEEDING = '/torrents/setSuperSeeding';

  final API_RSS_ADD_FOLDER = '/rss/addFolder';
  final API_RSS_ADD_FEED = '/rss/addFeed';
  final API_RSS_REMOVE_ITEM = '/rss/removeItem';
  final API_RSS_MOVE_ITEM = '/rss/moveItem';
  final API_RSS_ITEMS = '/rss/items';
  final API_RSS_SET_RULE = '/rss/setRule';
  final API_RSS_RENAME_RULE = '/rss/renameRule';
  final API_RSS_REMOVE_RULE = '/rss/removeRule';
  final API_RSS_RULES = '/rss/rules';

  final API_SEARCH_START = '/search/start';
  final API_SEARCH_STOP = '/search/stop';
  final API_SEARCH_STATUS = '/search/status';
  final API_SEARCH_RESULTS = '/search/results';
  final API_SEARCH_DELETE = '/search/delete';
  final API_SEARCH_CATEGORIES = '/search/categories';
  final API_SEARCH_PLUGINS = '/search/plugins';
  final API_SEARCH_INSTALL_PLUGIN = '/search/installPlugin';
  final API_SEARCH_UNINSTALL_PLUGIN = '/search/uninstallPlugin';
  final API_SEARCH_ENABLE_PLUGIN = '/search/enablePlugin';
  final API_SEARCH_UPDATE_PLUGINS = '/search/updatePlugins';

  QBitTorrentAPI(this._serverIP, this._serverPort) {
    _apiURL = 'http://${_serverIP}:${_serverPort}/api/v2';
    session = Session();
  }

  /// ======================== AUTH methods ==========================

  /// Login to qbittorrent
  ///   return true if login success else false
  Future<bool> login(String username, String password) async {
    var resp = await session.post('${_apiURL}${API_AUTH_LOGIN}',
        body: {'username': username, 'password': password});
    return resp.statusCode == 200;
  }

  /// Logout from qbittorrent
  Future<bool> logout() async {
    var resp = await session.post('${_apiURL}${API_AUTH_LOGOUT}');
    return resp.statusCode == 200;
  }

  /// return true if you are currently logged in
  Future<bool> isLoggedIn() async {
    var resp = await session.post('${_apiURL}${API_APP_VERSION}');
    return resp.statusCode == 200;
  }

  /// ====================  APP API methods ==========================

  Future<String> getVersion() async {
    var resp = await session.get('${_apiURL}${API_APP_VERSION}');
    return resp.body;
  }

  ///Only supported from qbittorrent 4.2.0+
  Future<dynamic> getBuildInfo() async {
    var resp = await session.get('${_apiURL}${API_APP_BUILDINFO}');
    print(resp.body);
  }

  Future<String> getDefaultSavePath() async {
    var resp = await session.get('${_apiURL}${API_APP_DEFAULT_SAVE_PATH}');
    return resp.body;
  }

  Future<String> getWebApiVersion() async {
    var resp = await session.get('${_apiURL}${API_APP_WEBAPIVERSION}');
    return resp.body;
  }

  ///return true on successful shutdown else false
  Future<bool> shutdownApplication() async {
    var resp = await session.get('${_apiURL}${API_APP_SHUTDOWN}');
    return resp.statusCode == 200;
  }

  ///returns the preferences object. To see all properties obtained , see the API doc
  Future<dynamic> getPreferences() async {
    var resp = await session.get('${_apiURL}${API_APP_PREFERENCES}');
    return json.decode(resp.body);
  }

  ///set any particular preference. Only parameters that need to be changed are to be specified (not the while prefernces )
  Future<bool> setPreferences(Map<String, dynamic> jsondata) async {
    var resp = await session.post('${_apiURL}${API_APP_SET_PREFERENCES}',
        body: {'json': json.encode(jsondata)});
    return resp.statusCode == 200;
  }

  /// ===========================  Log api methods  ======================

  Future<dynamic> getLog(
      {bool normal = true,
      bool info = true,
      bool warning = true,
      bool critical = true,
      int last_known_id = -1}) async {
    var resp = await session.post('${_apiURL}${API_LOG_MAIN}', body: {
      'normal': json.encode(normal),
      'info': info.toString(),
      'warning': warning.toString(),
      'critical': critical.toString(),
      'last_known_id': last_known_id.toString()
    });
    return json.decode(resp.body);
  }

  Future<dynamic> getPeerLog({int last_known_id = -1}) async {
    var resp = await session.post('${_apiURL}${API_LOG_PEER}',
        body: {'last_known_id': last_known_id.toString()});
    return json.decode(resp.body);
  }

  /// =======================  Sync api methods ======================
  /// Sync API implements requests for obtaining changes since the last request. All Sync API methods are under "sync", e.g.: /api/v2/sync/methodName.

  Future<dynamic> syncMainData({String responseId = '0'}) async {
    var resp = await session
        .post('${_apiURL}${API_SYNC_MAINDATA}', body: {'rid': responseId});
    return json.decode(resp.body);
  }

/// Get Torrent Peers data
  Future<dynamic> syncTorrentPeers(
      {String responseId = '0', String torrentHash}) async {
    var resp = await session.post('${_apiURL}${API_SYNC_TORRENT_PEERS}',
        body: {'rid': responseId, 'hash': torrentHash});
    return json.decode(resp.body);
  }

  /// =======================  Transfer api methods ======================
  ///

  ///Get global transfer info . This method returns info you usually see in qBt status bar.
  Future<dynamic> getTransferInfo() async {
    var resp = await session.get('${_apiURL}${API_TRANSFER_INFO}');
    return json.decode(resp.body);
  }

  /// The response is 1 if alternative speed limits are enabled, 0 otherwise.
  Future<String> getSpeedLimitsMode() async {
    var resp =
        await session.get('${_apiURL}${API_TRANSFER_SPEED_LIMITS_MODE}');
    return resp.body ; 
  }

  Future<String> toggleSpeedLimitsMode() async {
    var resp =
        await session.post('${_apiURL}${API_TRANSFER_TOGGLE_SPEED_LIMITS}');
    return resp.body ;
  }

/// The response is the value of current global download speed limit in bytes/second; this value will be zero if no limit is applied.
  Future<String> getDownloadLimit() async {
    var resp =
        await session.get('${_apiURL}${API_TRANSFER_DOWNLOAD_LIMIT}');
    return resp.body ; 
  }

/// The global download speed limit to set in bytes/second
  Future<String> setDownloadLimit(int limit) async {
    var resp =
        await session.post('${_apiURL}${API_TRANSFER_SET_DOWNLOAD_LIMIT}' , body : {
          'limit' : limit.toString()
        });
    return resp.body;
  }


/// The response is the value of current global upload speed limit in bytes/second; this value will be zero if no limit is applied.
  Future<String> getUploadLimit() async {
    var resp =
        await session.get('${_apiURL}${API_TRANSFER_UPLOAD_LIMIT}');
    return resp.body ; 
  }

/// The global upload speed limit to set in bytes/second
  Future<String> setUploadLimit(int limit) async {
    var resp =
        await session.post('${_apiURL}${API_TRANSFER_SET_UPLOAD_LIMIT}' , body : {
          'limit' : limit.toString()
        });
    return resp.body;
  }


///  The peer to ban, or multiple peers. Each peer is a colon-separated host:port
  Future<String> banPeers(List<String> peers) async {
    var resp =
        await session.post('${_apiURL}${API_TRANSFER_BAN_PEERS}' , body : {
            'peers' : peers.join('|')
        });
    return resp.body;
  }





  /// =======================  Torrent api methods ======================

  /// Get a list of torrents based on the filters and applied parameters. See api docs for more info on response object
  Future<dynamic> getTorrentList({TorrentFilter filter , String category , String sort , bool reverse , int limit , int offset , List<String> hashes}) async {
    final Map<String,dynamic> body = {} ;
    if(filter!=null) body['filter'] = filter.toString().split('.').last; 
    if(category!=null) body['category'] = category ; 
    if(sort!=null) body['sort'] = sort ; 
    if(reverse!=null) body['reverse'] = reverse.toString() ; 
    if(offset!=null) body['offset'] = offset.toString(); 
    if(hashes!=null) body['hashes'] = hashes.join('|') ;
    print('body  = ${body}');

    var resp = await session.post('${_apiURL}${API_TORRENT_INFO}' , body :body );
    return json.decode(resp.body) ;
  }

/// Get torrent generic properties
  Future<dynamic> getTorrentProperties(String torrentHash) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_PROPERTIES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }


  Future<dynamic> getTorrentTrackers(String torrentHash) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_TRACKERS}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

  Future<dynamic> getTorrentWebSeeds(String torrentHash) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_WEBSEEDS}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

  Future<dynamic> getTorrentContents(String torrentHash) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_FILES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }


  Future<dynamic> getTorrentPieceStates(String torrentHash) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_PIECE_STATES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

Future<dynamic> getTorrentPieceHashes(String torrentHash) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_PIECE_HASHES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }



/// pause some or all torrents . 
/// param torrentHashes is an array of torrent hashes or ['all'] to pause all torrents
Future<String> pauseTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_PAUSE}' , body :{'hashes' : torrentHashs.join('|')});
    return (resp.body) ; 
  }


/// param torrentHashes is an array of torrent hashes or ['all'] to resume all torrents
Future<String> resumeTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_RESUME}' , body :{'hashes' : torrentHashs.join('|')});
    return (resp.body) ; 
  }


/// param torrentHashes is an array of torrent hashes or ['all'] to delete all torrents
Future<String> deleteTorrents(List<String> torrentHashs , { bool deleteFilesOnDisk =false }) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_DELETE}' , body :{
      'hashes' : torrentHashs.join('|') , 
    'deleteFiles' : deleteFilesOnDisk.toString()
    });
    return (resp.body) ; 
  }


/// param torrentHashes is an array of torrent hashes or ['all'] to recheck all torrents
Future<String> recheckTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_RECHECK}' , body :{'hashes' : torrentHashs.join('|')});
    return (resp.body) ; 
  }

/// param torrentHashes is an array of torrent hashes or ['all'] to reannounce all torrents
Future<String> reannounceTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${API_TORRENT_REANNOUNCE}' , body :{'hashes' : torrentHashs.join('|')});
    return (resp.body) ; 
  }



/// Add new torrents
///Params : 
/// urls : list of URLs  
///torrents : Raw data of torrent file. torrents can be presented multiple times.
///Returns true if torrents added successfully else false
Future<bool> addNewTorrents(List<String> urls , String torrents , {
  String savepath , String cookie, String category , bool skip_checking =false , bool paused = false , bool root_folder = false , String rename , int uploadLimit , int downloadLimit , bool useAutoTMM , bool sequentialDownload = false , bool prioritizeFirstLastPiece = false
}) async {
    final Map<String,dynamic> body = {
      'urls' : urls.join('%0A'), 'torrents' : torrents ,
      'skip_checking':skip_checking , 'paused':paused , 'root_folder':root_folder , 'sequentialDownload':sequentialDownload , 'prioritizeFirstLastPiece':prioritizeFirstLastPiece} ; 

    if(savepath!=null)body['savepath'] =savepath ; 
    if(cookie!=null)body['cookie'] =cookie; 
    if(category!=null)body['category'] =category; 
    if(rename!=null)body['rename'] =rename; 
    if(uploadLimit!=null)body['upLimit'] =uploadLimit.toString(); 
    if(downloadLimit!=null)body['dlLimit'] =downloadLimit.toString(); 
    if(useAutoTMM!=null)body['useAutoTMM'] =useAutoTMM.toString(); 

    var resp = await session.post('${_apiURL}${API_TORRENT_ADD}' , body :body) ; 
    return resp.statusCode==200 ;
  }





Future<bool> addTorrentTrackers(String torrentHash , List<String> trackers) async{
    var resp = await session.post('${_apiURL}${API_TORRENT_ADD_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'urls' : trackers.join('%0A')
    }) ;
    return resp.statusCode==200;
}

///See docs for response code meaning 
Future<int> editTorrentTrackers(String torrentHash , List<String> oldTrackers ,List<String> newTrackers ) async{
    var resp = await session.post('${_apiURL}${API_TORRENT_EDIT_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'origUrl' : oldTrackers.join('%0A'),
      'newUrl' : newTrackers.join('%0A')
    }) ; 
    return resp.statusCode; 
}

///See docs for response code meaning 
Future<int> removeTorrentTrackers(String torrentHash , List<String> trackers) async{
    var resp = await session.post('${_apiURL}${API_TORRENT_REMOVE_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'urls' : trackers.join('|')
    }) ;
    return resp.statusCode;
}


/// Returns true if successfully added
Future<bool> addTorrentPeers(List<String> torrentHashes , List<String> peers) async{
    var resp = await session.post('${_apiURL}${API_TORRENT_ADD_PEERS}' , body :{
      'hashes' : torrentHashes.join('|'), 
      'peers' : peers.join('|')
    }) ;
    return resp.statusCode==200;
}






}

main(List<String> args) async {
  QBitTorrentAPI obj = QBitTorrentAPI('192.168.0.100', 8080);
  print(await obj.login('natesh', 'password') ? 'Login Success' : '');
  print(await obj.getVersion());
  print(await obj.getDefaultSavePath());
  print(await obj.getWebApiVersion());
  // print(await obj.getPreferences());
  print(await obj.setPreferences({'max_active_downloads': 10}));
  print(await obj.getTransferInfo());
  print(await obj.getSpeedLimitsMode());
  print(await obj.toggleSpeedLimitsMode());
  print(await obj.getDownloadLimit());
  print(await obj.getTorrentList(filter: TorrentFilter.downloading)) ; 
  print(await obj.getTorrentContents('038caafe66d920547062d25245456d88c2715895')) ; 


  print(await obj.logout() ? 'Logout Success' : '');
  print(await obj.getVersion());
}
