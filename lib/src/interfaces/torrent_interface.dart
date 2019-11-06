import '../../torrent_api.dart';

abstract class CommonTorrentFunctionsInterface {
  Future login(String username, String password);
  Future logout();

  Future start(String torrentHash);
  Future pause(String torrentHash);
  Future resume(String torrentHash);
  Future remove(String torrentHash);
  Future recheck(String torrentHash);

  Future startMultiple(List<String> torrentHashes);
  Future pauseMultiple(List<String> torrentHashes);
  Future recheckMultiple(List<String> torrentHashes);
  Future removeMultiple(List<String> torrentHashes);
  Future resumeMultiple(List<String> torrentHashes);

  ///Returns the URL of the documentation for the corresponding torrent api
  String getApiDocUrl() ; 
}

abstract class QbitTorrentApiInterface extends CommonTorrentFunctionsInterface {
  
  /// API Doc at : https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information
  Future stopAllTorrents() ;
  Future startAllTorrents() ;
  Future pauseAllTorrents() ;
  Future recheckAllTorrents() ;
  Future removeAllTorrents() ;
  Future resumeAllTorrents() ;
  
  
  Future stop(String torrentHash);

  /// param torrentHashes is an array of torrent hashes or ['all'] for all torrents
  Future stopMultiple(List<String> torrentHashes);


  Future<bool> isLoggedIn();
  Future<String> getVersion();

  ///Only supported from qbittorrent 4.2.0+
  Future<dynamic> getBuildInfo();

  Future<String> getDefaultSavePath();
  Future<String> getWebApiVersion();
  Future shutdownApplication();

  ///returns the preferences object. To see all properties obtained , see the API doc
  Future<dynamic> getPreferences();

  ///set any particular preference. Only parameters that need to be changed are to be specified (not the while prefernces )
  Future setPreferences(Map<String, dynamic> jsondata);
  Future<dynamic> getLog(
      {bool normal = true,
      bool info = true,
      bool warning = true,
      bool critical = true,
      int last_known_id = -1});
  Future<dynamic> getPeerLog({int last_known_id = -1});

  /// Sync API implements requests for obtaining changes since the last request. All Sync API methods are under "sync", e.g.: /api/v2/sync/methodName.
  Future<dynamic> syncMainData({String responseId = '0'});

  /// Get Torrent Peers data
  Future<dynamic> syncTorrentPeers(
      {String responseId = '0', String torrentHash});

  ///Get global transfer info . This method returns info you usually see in qBt status bar.
  Future<dynamic> getTransferInfo();

  /// The response is 1 if alternative speed limits are enabled, 0 otherwise.
  Future<String> getSpeedLimitsMode();
  Future<String> toggleSpeedLimitsMode();

  /// The response is the value of current global download speed limit in bytes/second; this value will be zero if no limit is applied.
  Future<String> getDownloadLimit();

  /// The global download speed limit to set in bytes/second
  Future<String> setDownloadLimit(int limit);

  /// The response is the value of current global upload speed limit in bytes/second; this value will be zero if no limit is applied.
  Future<String> getUploadLimit();

  /// The global upload speed limit to set in bytes/second
  Future<String> setUploadLimit(int limit);

  ///  The peer to ban, or multiple peers. Each peer is a colon-separated host:port
  Future<String> banPeers(List<String> peers);

  /// Get a list of torrents based on the filters and applied parameters. See api docs for more info on response object
  Future<dynamic> getTorrentList(
      {TorrentFilter filter,
      String category,
      String sort,
      bool reverse,
      int limit,
      int offset,
      List<String> hashes});

  /// Get torrent generic properties
  Future<dynamic> getTorrentProperties(String torrentHash);

  Future<dynamic> getTorrentTrackers(String torrentHash);

  Future<dynamic> getTorrentWebSeeds(String torrentHash);
  Future<dynamic> getTorrentContents(String torrentHash);
  Future<dynamic> getTorrentPieceStates(String torrentHash);
  Future<dynamic> getTorrentPieceHashes(String torrentHash);

  /// param torrentHashes is an array of torrent hashes or ['all'] for all torrents
  Future pauseMultiple(List<String> torrentHashs);

  /// param torrentHashes is an array of torrent hashes or ['all'] for all torrents
  Future removeMultipleTorrentsWithData(List<String> torrentHashs);

  /// param torrentHashes is an array of torrent hashes or ['all'] to reannounce all torrents
  Future<String> reannounceTorrents(List<String> torrentHashs);


  /// Add new torrents
  ///Params :
  /// urls : list of URLs
  ///torrents : Raw data of torrent file. torrents can be presented multiple times.
  Future addNewTorrents(List<String> urls, String torrents,
      {String savepath,
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
      bool prioritizeFirstLastPiece = false});

  Future<bool> addTorrentTrackers(String torrentHash, List<String> trackers);

  Future<int> editTorrentTrackers(
      String torrentHash, List<String> oldTrackers, List<String> newTrackers);

  Future<int> removeTorrentTrackers(String torrentHash, List<String> trackers);

  Future<bool> addTorrentPeers(List<String> torrentHashes, List<String> peers);
}

abstract class UTorrentApiInterface extends CommonTorrentFunctionsInterface {}
