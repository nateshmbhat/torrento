import 'dart:async';
import 'dart:convert';
import 'package:torrent_api/src/exceptions/exceptions.dart';
import 'package:torrent_api/src/qbittorrent_api/session.dart';
import 'package:torrent_api/src/interfaces/torrent_interface.dart';

import './session.dart';
import 'package:http/http.dart' as http;

import 'utils.dart';



enum TorrentFilter{
  all , downloading  , completed , paused , active  , inactive , resumed
}



class QBitTorrentAPI implements IQbitTorrentApi  {
  /// API Doc at : https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information
  String _serverIP;
  int _serverPort;
  String _apiURL;
  Session session;

    QBitTorrentAPI(this._serverIP, this._serverPort) {
    _apiURL = 'http://${_serverIP}:${_serverPort}/api/v2';
    session = Session();
  }
  
  bool isStatusOk(http.Response response){
    return response.statusCode==200 ; 
  }

  /// ======================== AUTH methods ==========================

  /// Login to qbittorrent
  ///   return true if login success else false
  @override
  Future login(String username, String password) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_AUTH_LOGIN}',
        body: {'username': username, 'password': password});
    if(!isStatusOk(resp)) throw InvalidCredentialsException;
  }

  /// Logout from qbittorrent
  @override
  Future logout() async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_AUTH_LOGOUT}');
    if(!isStatusOk(resp)) throw InvalidRequestException;
  }

  

  /// return true if you are currently logged in
  @override 
  Future<bool> isLoggedIn() async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_APP_VERSION}');
    if(!isStatusOk(resp)) throw UnauthorsizedAccessException;
  }

  /// ====================  APP API methods ==========================

  Future<String> getVersion() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_VERSION}');
    return resp.body;
  }

  ///Only supported from qbittorrent 4.2.0+
  Future<dynamic> getBuildInfo() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_BUILDINFO}');
    print(resp.body);
  }

  Future<String> getDefaultSavePath() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_DEFAULT_SAVE_PATH}');
    return resp.body;
  }

  Future<String> getWebApiVersion() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_WEBAPIVERSION}');
    return resp.body;
  }

  ///return true on successful shutdown else false
  Future shutdownApplication() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_SHUTDOWN}');
    if(!isStatusOk(resp)) throw InvalidRequestException;
  }

  ///returns the preferences object. To see all properties obtained , see the API doc
  Future<dynamic> getPreferences() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_APP_PREFERENCES}');
    return json.decode(resp.body);
  }

  ///set any particular preference. Only parameters that need to be changed are to be specified (not the while prefernces )
  Future<bool> setPreferences(Map<String, dynamic> jsondata) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_APP_SET_PREFERENCES}',
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
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_LOG_MAIN}', body: {
      'normal': json.encode(normal),
      'info': info.toString(),
      'warning': warning.toString(),
      'critical': critical.toString(),
      'last_known_id': last_known_id.toString()
    });
    return json.decode(resp.body);
  }

  Future<dynamic> getPeerLog({int last_known_id = -1}) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_LOG_PEER}',
        body: {'last_known_id': last_known_id.toString()});
    return json.decode(resp.body);
  }

  /// =======================  Sync api methods ======================
  /// Sync API implements requests for obtaining changes since the last request. All Sync API methods are under "sync", e.g.: /api/v2/sync/methodName.

  Future<dynamic> syncMainData({String responseId = '0'}) async {
    var resp = await session
        .post('${_apiURL}${ApiEndPoint.API_SYNC_MAINDATA}', body: {'rid': responseId});
    return json.decode(resp.body);
  }

/// Get Torrent Peers data
  Future<dynamic> syncTorrentPeers(
      {String responseId = '0', String torrentHash}) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_SYNC_TORRENT_PEERS}',
        body: {'rid': responseId, 'hash': torrentHash});
    return json.decode(resp.body);
  }

  /// =======================  Transfer api methods ======================
  ///

  ///Get global transfer info . This method returns info you usually see in qBt status bar.
  Future<dynamic> getTransferInfo() async {
    var resp = await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_INFO}');
    return json.decode(resp.body);
  }

  /// The response is 1 if alternative speed limits are enabled, 0 otherwise.
  Future<String> getSpeedLimitsMode() async {
    var resp =
        await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_SPEED_LIMITS_MODE}');
    return resp.body ; 
  }

  Future<String> toggleSpeedLimitsMode() async {
    var resp =
        await session.post('${_apiURL}${ApiEndPoint.API_TRANSFER_TOGGLE_SPEED_LIMITS}');
    return resp.body ;
  }

/// The response is the value of current global download speed limit in bytes/second; this value will be zero if no limit is applied.
  Future<String> getDownloadLimit() async {
    var resp =
        await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_DOWNLOAD_LIMIT}');
    return resp.body ; 
  }

/// The global download speed limit to set in bytes/second
  Future<String> setDownloadLimit(int limit) async {
    var resp =
        await session.post('${_apiURL}${ApiEndPoint.API_TRANSFER_SET_DOWNLOAD_LIMIT}' , body : {
          'limit' : limit.toString()
        });
    return resp.body;
  }


/// The response is the value of current global upload speed limit in bytes/second; this value will be zero if no limit is applied.
  Future<String> getUploadLimit() async {
    var resp =
        await session.get('${_apiURL}${ApiEndPoint.API_TRANSFER_UPLOAD_LIMIT}');
    return resp.body ; 
  }

/// The global upload speed limit to set in bytes/second
  Future<String> setUploadLimit(int limit) async {
    var resp =
        await session.post('${_apiURL}${ApiEndPoint.API_TRANSFER_SET_UPLOAD_LIMIT}' , body : {
          'limit' : limit.toString()
        });
    return resp.body;
  }


///  The peer to ban, or multiple peers. Each peer is a colon-separated host:port
  Future<String> banPeers(List<String> peers) async {
    var resp =
        await session.post('${_apiURL}${ApiEndPoint.API_TRANSFER_BAN_PEERS}' , body : {
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

    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_INFO}' , body :body );
    return json.decode(resp.body) ;
  }

/// Get torrent generic properties
  Future<dynamic> getTorrentProperties(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PROPERTIES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }


  Future<dynamic> getTorrentTrackers(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_TRACKERS}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

  Future<dynamic> getTorrentWebSeeds(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_WEBSEEDS}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

  Future<dynamic> getTorrentContents(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_FILES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }


  Future<dynamic> getTorrentPieceStates(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PIECE_STATES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }

Future<dynamic> getTorrentPieceHashes(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PIECE_HASHES}' , body :{'hash' : torrentHash});
    if(resp.statusCode==404) return null ; 
    return json.decode(resp.body) ; 
  }


/// pause some or all torrents . 
/// param torrentHashes is an array of torrent hashes or ['all'] to pause all torrents
@override
Future pauseMultiple(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PAUSE}' , body :{'hashes' : torrentHashs.join('|')});
    if(!isStatusOk(resp)) throw InvalidParameterException ; 
  }

@override
Future pause(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_PAUSE}' , body :{'hashes' : torrentHash});
    if(!isStatusOk(resp)) throw InvalidParameterException ; 
  }



@override
Future resume(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_RESUME}' , body :{'hashes' : torrentHash});
    if(resp.statusCode!=200) throw InvalidParameterException ; 
  }




/// param torrentHashes is an array of torrent hashes or ['all'] to resume all torrents
@override
Future resumeMultiple(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_RESUME}' , body :{'hashes' : torrentHashs.join('|')});
    if(resp.statusCode!=200) throw InvalidParameterException ; 
  }

@override
Future remove(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}' , body :{
      'hashes' : torrentHash , 
    });
    if(resp.statusCode!=200) throw InvalidParameterException ; 
  }



/// param torrentHashes is an array of torrent hashes or ['all'] to delete all torrents
@override
Future removeMultiple(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}' , body :{
      'hashes' : torrentHashs.join('|') , 
    });
    if(resp.statusCode!=200) throw InvalidParameterException ; 
  }

@override
Future removeMultipleTorrentsWithData(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_DELETE}' , body :{
      'hashes' : torrentHashs.join('|') , 
    'deleteFiles' : 'true'
    });
    if(resp.statusCode!=200) throw InvalidParameterException ; 
  }

/// param torrentHashes is an array of torrent hashes or ['all'] to recheck all torrents
@override
Future recheckMultiple(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_RECHECK}' , body :{'hashes' : torrentHashs.join('|')});
    if(resp.statusCode!=200) throw InvalidParameterException ; 
}

@override
Future recheck(String torrentHash) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_RECHECK}' , body :{'hashes' : torrentHash});
    if(resp.statusCode!=200) throw InvalidParameterException ; 
  }



/// param torrentHashes is an array of torrent hashes or ['all'] to reannounce all torrents
Future<String> reannounceTorrents(List<String> torrentHashs) async {
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_REANNOUNCE}' , body :{'hashes' : torrentHashs.join('|')});
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

    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD}' , body :body) ; 
    return resp.statusCode==200 ;
  }





Future<bool> addTorrentTrackers(String torrentHash , List<String> trackers) async{
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'urls' : trackers.join('%0A')
    }) ;
    return resp.statusCode==200;
}

///See docs for response code meaning 
Future<int> editTorrentTrackers(String torrentHash , List<String> oldTrackers ,List<String> newTrackers ) async{
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_EDIT_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'origUrl' : oldTrackers.join('%0A'),
      'newUrl' : newTrackers.join('%0A')
    }) ; 
    return resp.statusCode; 
}

///See docs for response code meaning 
Future<int> removeTorrentTrackers(String torrentHash , List<String> trackers) async{
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_REMOVE_TRACKERS}' , body :{
      'hash' : torrentHash , 
      'urls' : trackers.join('|')
    }) ;
    return resp.statusCode;
}


/// Returns true if successfully added
Future<bool> addTorrentPeers(List<String> torrentHashes , List<String> peers) async{
    var resp = await session.post('${_apiURL}${ApiEndPoint.API_TORRENT_ADD_PEERS}' , body :{
      'hashes' : torrentHashes.join('|'), 
      'peers' : peers.join('|')
    }) ;
    return resp.statusCode==200;
}

  @override
  Future start(String torrentHash) async {
    resume(torrentHash) ; 
  }

  @override
  Future startMultiple(List<String> torrentHashes) async {
    resumeMultiple(torrentHashes);
  }

  @override
  Future stop(String torrentHash) async {
    pause(torrentHash);
  }

  @override
  Future stopMultiple(List<String> torrentHashes) async {
    pauseMultiple(torrentHashes) ; 
  }

}
