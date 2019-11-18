import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart' ;
import 'package:torrential_lib/src/core/exceptions/exceptions.dart';
import 'package:torrential_lib/src/core/contracts/torrent_interface.dart'; 

import './session.dart';
import 'package:http/http.dart' as http;

import 'utils.dart';



enum TorrentFilter{
  all , downloading  , completed , paused , active  , inactive , resumed
}



class QbitTorrentControllerImpl implements QbitTorrentController  {
  /// API Doc at : https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information
  String _serverIP;
  int _serverPort;
  String _apiURL;
  Session session;
  final String API_DOC_URL = 'https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information' ; 


    QbitTorrentControllerImpl(this._serverIP, this._serverPort) {
    _apiURL = 'http://${_serverIP}:${_serverPort}/api/v2';
    session = Session();
  }
  
  bool _isStatusOk(http.Response response){
    return response.statusCode==200 ; 
  }

  /// ======================== AUTH methods ==========================

  @override
  Future logIn(String username, String password) async {

    var resp = await session.post('${_apiURL}${ApiEndPoint.API_AUTH_LOGIN}',
        body: {'username': username, 'password': password});
    if(!_isStatusOk(resp)) throw InvalidCredentialsException(resp);
    if(resp.body.trim()=="Fails.") throw InvalidCredentialsException(resp) ;

  }

  @override
  Future logOut() async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_AUTH_LOGOUT}');
    if(!_isStatusOk(resp)) throw InvalidRequestException(resp);
  }

  

  @override
  Future<bool> isLoggedIn() async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_APP_VERSION}');
    if(!_isStatusOk(resp)) throw UnauthorsizedAccessException;
    return true ; 
  }

  /// ====================  APP API methods ==========================
  
  @override
  Future<String> getVersion() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_VERSION}');
    return resp.body;
  }

  @override
  Future<dynamic> getBuildInfo() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_BUILDINFO}');
    return resp.body ; 
  }

  @override
  Future<String> getDefaultSavePath() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_DEFAULT_SAVE_PATH}');
    return resp.body;
  }

  @override
  Future<String> getWebApiVersion() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_WEBAPIVERSION}');
    return resp.body;
  }

  @override
  Future shutdownApplication() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_SHUTDOWN}');
    if(!_isStatusOk(resp)) throw InvalidRequestException(resp);
  }

  @override
  Future<dynamic> getPreferences() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_PREFERENCES}');
    return json.decode(resp.body);
  }

  @override
  Future setPreferences(Map<String, dynamic> jsondata) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_APP_SET_PREFERENCES}',
        body: {'json': json.encode(jsondata)});
    if(!_isStatusOk(resp)) throw InvalidParameterException(resp) ; 
  }

  /// ===========================  Log api methods  ======================

  @override
  Future<dynamic> getLog(
      {bool normal = true,
      bool info = true,
      bool warning = true,
      bool critical = true,
      int last_known_id = -1}) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_LOG_MAIN}', body: {
      'normal': json.encode(normal),
      'info': info.toString(),
      'warning': warning.toString(),
      'critical': critical.toString(),
      'last_known_id': last_known_id.toString()
    });
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> getPeerLog({int last_known_id = -1}) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_LOG_PEER}',
        body: {'last_known_id': last_known_id.toString()});
    return json.decode(resp.body);
  }

  /// =======================  Sync api methods ======================

  @override
  Future<dynamic> syncMainData({String responseId = '0'}) async {
    var resp = await session
        .post('${_apiURL}${ApiEndPoint.API_SYNC_MAINDATA}', body: {'rid': responseId});
    return json.decode(resp.body);
  }

  @override
  Future<dynamic> syncTorrentPeers(
      {String responseId = '0', String torrentHash}) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_SYNC_TORRENT_PEERS}',
        body: {'rid': responseId, 'hash': torrentHash});
    return json.decode(resp.body);
  }

  /// =======================  Transfer api methods ======================
  ///

  @override
  Future<dynamic> getTransferInfo() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_INFO}');
    return json.decode(resp.body);
  }

  @override
  Future<String> getSpeedLimitsMode() async {
    var resp =
        await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_SPEED_LIMITS_MODE}');
    return resp.body ; 
  }

  @override
  Future<String> toggleSpeedLimitsMode() async {
    var resp =
        await session.post('${_apiURL}${ApiEndPoint.API_TRANSFER_TOGGLE_SPEED_LIMITS}');
    return resp.body ;
  }

  @override
  Future<String> getTransferDownloadLimit() async {
    var resp =
        await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_DOWNLOAD_LIMIT}');
    return resp.body ; 
  }

  @override
  Future<String> setTransferDownloadLimit(int limit) async {
    var resp =
        await session.post('${_apiURL}${ApiEndPoint.API_TRANSFER_SET_DOWNLOAD_LIMIT}' , body : {
          'limit' : limit.toString()
        });
    return resp.body;
  }


  @override
  Future<String> getTransferUploadLimit() async {
    var resp =
        await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_UPLOAD_LIMIT}');
    return resp.body ; 
  }

  @override
  Future<String> setTransferUploadLimit(int limit) async {
    var resp =
        await session.post('${_apiURL}${ApiEndPoint.API_TRANSFER_SET_UPLOAD_LIMIT}' , body : {
          'limit' : limit.toString()
        });
    return resp.body;
  }


  @override
  Future<String> banPeers(List<String> peers) async {
    var resp =
        await session.post('${_apiURL}${ApiEndPoint.API_TRANSFER_BAN_PEERS}' , body : {
            'peers' : peers.join('|')
        });
    return resp.body;
  }





  /// =======================  Torrent api methods ======================

  @override
  Future<List> getTorrentsList({TorrentFilter filter , String category , String sort , bool reverse , int limit , int offset , List<String> hashes}) async {
    final Map<String,dynamic> body = {} ;
    if(filter!=null) body['filter'] = filter.toString().split('.').last; 
    if(category!=null) body['category'] = category ; 
    if(sort!=null) body['sort'] = sort ; 
    if(reverse!=null) body['reverse'] = reverse.toString() ; 
    if(offset!=null) body['offset'] = offset.toString(); 
    if(hashes!=null) body['hashes'] = hashes.join('|') ;

    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_INFO}' , body :body );
    return json.decode(resp.body) ;
  }

  @override
  Future<dynamic> getTorrentProperties(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PROPERTIES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }


  @override
  Future<dynamic> getTorrentTrackers(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_TRACKERS}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

  @override
  Future<dynamic> getTorrentWebSeeds(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_WEBSEEDS}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

  @override
  Future<dynamic> getTorrentContents(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_FILES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }


  @override
  Future<dynamic> getTorrentPieceStates(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PIECE_STATES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

  @override
Future<dynamic> getTorrentPieceHashes(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PIECE_HASHES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }


@override
Future pauseMultipleTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PAUSE}' , body :{'hashes' : torrentHashs.join('|')});
    if(!_isStatusOk(resp)) throw InvalidParameterException(resp) ; 
  }

@override
Future pauseTorrent(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PAUSE}' , body :{'hashes' : torrentHash});
    if(!_isStatusOk(resp)) throw InvalidParameterException(resp) ; 
  }



@override
Future resumeTorrent(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_RESUME}' , body :{'hashes' : torrentHash});
    if(resp.statusCode!=200) throw InvalidParameterException(resp) ; 
  }


@override
Future resumeMultipleTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_RESUME}' , body :{'hashes' : torrentHashs.join('|')});
    if(resp.statusCode!=200) throw InvalidParameterException(resp) ; 
  }

@override
Future removeTorrent(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}' , body :{
      'hashes' : torrentHash , 
    });
    if(resp.statusCode!=200) throw InvalidParameterException(resp) ; 
  }



@override
Future removeMultipleTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}' , body :{
      'hashes' : torrentHashs.join('|') , 
    });
    if(resp.statusCode!=200) throw InvalidParameterException(resp) ; 
  }

@override
Future removeMultipleTorrentsWithData(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}' , body :{
      'hashes' : torrentHashs.join('|') , 
    'deleteFiles' : 'true'
    });
    if(resp.statusCode!=200) throw InvalidParameterException(resp) ; 
  }

@override
Future recheckMultipleTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_RECHECK}' , body :{'hashes' : torrentHashs.join('|')});
    if(resp.statusCode!=200) throw InvalidParameterException(resp) ; 
}

@override
Future recheckTorrent(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_RECHECK}' , body :{'hashes' : torrentHash});
    if(resp.statusCode!=200) throw InvalidParameterException(resp) ; 
  }



Future<String> reannounceTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_REANNOUNCE}' , body :{'hashes' : torrentHashs.join('|')});
    return (resp.body) ; 
  }



///TODO : ADD TORRENT HAS TO BE REDESIGNED PROPERLY
 @override
Future addTorrents(List<String> urls , {
String torrentFileContent  , 
  String savepath , String cookie, String category , bool skip_checking =false , bool paused = false , bool root_folder = false , String rename , int uploadLimit , int downloadLimit , bool useAutoTMM , bool sequentialDownload = false , bool prioritizeFirstLastPiece = false
}) async {
    final Map<String,dynamic> body = {
      'urls' : urls.join('%0A'), 'torrents' : torrentFileContent,
      'skip_checking':skip_checking , 'paused':paused , 'root_folder':root_folder , 'sequentialDownload':sequentialDownload , 'prioritizeFirstLastPiece':prioritizeFirstLastPiece} ; 

    if(savepath!=null)body['savepath'] =savepath ; 
    if(cookie!=null)body['cookie'] =cookie; 
    if(category!=null)body['category'] =category; 
    if(rename!=null)body['rename'] =rename; 
    if(uploadLimit!=null)body['upLimit'] =uploadLimit.toString(); 
    if(downloadLimit!=null)body['dlLimit'] =downloadLimit.toString(); 
    if(useAutoTMM!=null)body['useAutoTMM'] =useAutoTMM.toString(); 

    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD}' , body :body) ; 
    if(!_isStatusOk(resp)) throw InvalidParameterException(resp) ; 
  }





  @override
Future<bool> addTorrentTrackers(String torrentHash , List<String> trackers) async{
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'urls' : trackers.join('%0A')
    }) ;
    return resp.statusCode==200;
}

///See docs for response code meaning 
  @override
Future<int> editTorrentTrackers(String torrentHash , List<String> oldTrackers ,List<String> newTrackers ) async{
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_EDIT_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'origUrl' : oldTrackers.join('%0A'),
      'newUrl' : newTrackers.join('%0A')
    }) ; 
    return resp.statusCode; 
}

///See docs for response code meaning 
  @override
Future<int> removeTorrentTrackers(String torrentHash , List<String> trackers) async{
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_REMOVE_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'urls' : trackers.join('|')
    }) ;
    return resp.statusCode;
}


/// Returns true if successfully added
  @override
Future<bool> addTorrentPeers(List<String> torrentHashes , List<String> peers) async{
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD_PEERS}' , body :{
      'hashes' : torrentHashes.join('|'), 
      'peers' : peers.join('|')
    }) ;
    return resp.statusCode==200;
}

  @override
  Future startTorrent(String torrentHash) async {
    resumeTorrent(torrentHash) ; 
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
    pauseMultipleTorrents(torrentHashes) ; 
  }

  @override
  String getApiDocUrl() {
    return API_DOC_URL ; 
  }

  @override
  Future pauseAllTorrents() async {
    await pauseMultipleTorrents(['all']) ;
  }

  @override
  Future recheckAllTorrents() async {
    await recheckMultipleTorrents(['all']) ;
  }

  @override
  Future removeAllTorrents() async {
    await removeMultipleTorrents(['all']) ;
  }

  @override
  Future resumeAllTorrents() async {
    await resumeMultipleTorrents(['all']) ;
  }

  @override
  Future startAllTorrents() async {
    await startMultipleTorrents(['all']) ;
  }

  @override
  Future stopAllTorrents() async {
    await stopMultipleTorrents(['all']) ;
  }



  @override
  Future addNewCategory(String category, String savePath) {
    // TODO: implement addNewCategory
    return null;
  }

  @override
  Future addTorrentTags(List<String> torrentHashes, List<String> tags) {
    // TODO: implement addTorrentTags
    return null;
  }

  @override
  Future createTags(List<String> tags) {
    // TODO: implement createTags
    return null;
  }

  @override
  Future decreasePriority(List<String> torrentHashes) {
    // TODO: implement decreasePriority
    return null;
  }

  @override
  Future deleteTags(List<String> tags) {
    // TODO: implement deleteTags
    return null;
  }

  @override
  Future editCategory(String category, String newSavePath) {
    // TODO: implement editCategory
    return null;
  }

  @override
  Future forceStartTorrent(String torrentHash) {
    // TODO: implement forceStart
    return null;
  }

  @override
  Future forceStartMultipleTorrents(List<String> torrentHashes) {
    // TODO: implement forceStartMultiple
    return null;
  }

  @override
  Future getAllCategories() {
    // TODO: implement getAllCategories
    return null;
  }

  @override
  Future getAllTags() {
    // TODO: implement getAllTags
    return null;
  }

  @override
  Future getClientSettings() {
    // TODO: implement getClientSettings
    return null;
  }

  @override
  Future getDownloadLimit(List<String> torrentHashes) {
    // TODO: implement getDownloadLimit
    return null;
  }

  @override
  Future getListOfFilesUnderATorrentJob(String torrentHash) {
    // TODO: implement getListOfFilesUnderATorrentJob
    return null;
  }

  @override
  Future getPropertiesOfTorrent(String torrentHash) {
    // TODO: implement getProperties
    return null;
  }

  @override
  Future getUploadLimit(List<String> torrentHashes) {
    // TODO: implement getUploadLimit
    return null;
  }

  @override
  Future increasePriority(List<String> torrentHashes) {
    // TODO: implement increasePriority
    return null;
  }

  @override
  Future removeTorrentAndData(String torrentHash) {
    // TODO: implement remoteData
    return null;
  }

  @override
  Future removeMultipleTorrentsAndData(List<String> torrentHash) {
    // TODO: implement remoteDataMultiple
    return null;
  }

  @override
  Future removeCategories(List<String> categories) {
    // TODO: implement removeCategories
    return null;
  }

  @override
  Future removeTorrentTags(List<String> torrentHashes, List<String> tags) {
    // TODO: implement removeTorrentTags
    return null;
  }

  @override
  Future setAutoTorrentManagement(List<String> torrentHashes, bool enable) {
    // TODO: implement setAutoTorrentManagement
    return null;
  }

  @override
  Future setCategory(List<String> torrentHashes, String category) {
    // TODO: implement setCategory
    return null;
  }

  @override
  Future setClientSettings(Map<String, dynamic > settingsAndValues) {
    // TODO: implement setClientSettings
    return null;
  }

  @override
  Future setDownloadLimit(List<String> torrentHashes, int limitInBytesPerSecond) {
    // TODO: implement setDownloadLimit
    return null;
  }

  @override
  Future setDownloadLocation(List<String> torrentHashes, String location) {
    // TODO: implement setDownloadLocation
    return null;
  }

  @override
  Future setFirstOrLastPiecePriority(List<String> torrentHashes) {
    // TODO: implement setFirstOrLastPiecePriority
    return null;
  }

  @override
  Future setForceStart(List<String> torrentHashes, bool value) {
    // TODO: implement setForceStart
    return null;
  }

  @override
  Future setMaxPriority(List<String> torrentHashes) {
    // TODO: implement setMaxPriority
    return null;
  }

  @override
  Future setMinPriority(List<String> torrentHashes) {
    // TODO: implement setMinPriority
    return null;
  }

  @override
  Future setPropertiesOfTorrent(String torrentHash, {Map<String, dynamic > propertiesAndValues}) {
    // TODO: implement setProperties
    return null;
  }

  @override
  Future setShareLimit(List<String> torrentHashes, double ratioLimit, int seedingTimeLimit) {
    // TODO: implement setShareLimit
    return null;
  }

  @override
  Future setSuperSeeding(List<String> torrentHashes, bool value) {
    // TODO: implement setSuperSeeding
    return null;
  }

  @override
  Future setTorrentName(String torrentHash, String name) {
    // TODO: implement setTorrentName
    return null;
  }

  @override
  Future setUploadLimit(List<String> torrentHashes, int limitInBytesPerSecond) {
    // TODO: implement setUploadLimit
    return null;
  }

  @override
  Future setfilePriority(String torrentHash, List<String> fileIds, int priority) {
    // TODO: implement setfilePriority
    return null;
  }

  @override
  Future toggleSequentialDownload(List<String> torrentHashes) {
    // TODO: implement toggleSequentialDownload
    return null;
  }

  @override
  Future unpauseTorrent(String torrentHash) {
    // TODO: implement unpause
    return null;
  }

  @override
  Future unpauseMultipleTorrents(List<String> torrentHashes) {
    // TODO: implement unpauseMultiple
    return null;
  }

  @override
  Future addTorrent(String url, {String torrentFileContent, String savepath, String cookie, String category, bool skip_checking = false, bool paused = false, bool root_folder = false, String rename, int uploadLimit, int downloadLimit, bool useAutoTMM, bool sequentialDownload = false, bool prioritizeFirstLastPiece = false}) {
    addTorrents([url] , torrentFileContent: torrentFileContent , savepath:  savepath , cookie: cookie , category: category , skip_checking: skip_checking, paused: paused , root_folder:  root_folder , rename: rename , uploadLimit: uploadLimit , downloadLimit:  downloadLimit , useAutoTMM:  useAutoTMM , sequentialDownload:  sequentialDownload , prioritizeFirstLastPiece: prioritizeFirstLastPiece ); 
  }
}
