import 'package:meta/meta.dart';
import 'package:torrential_lib/src/torrent_client_controllers/qbittorrent/qbittorrent_controller.dart';

abstract class TorrentController {
  // ! Actions
  // * To handle single torrent

  Future login(String username, String password);
  Future logout();

  Future start(String torrentHash);
  Future stop(String torrentHash);
  Future resume(String torrentHash);

  Future pause(String torrentHash);
  Future unpause(String torrentHash);

  Future forceStart(String torrentHash);

  Future remove(String torrentHash);
  Future remoteData(String torrentHash);
  Future recheck(String torrentHash);

  Future addUrl(String url);

  // * To handle multiple torrents
  
  Future startMultiple(List<String> torrentHashes);
  Future stopMultiple(List<String> torrentHashes);
  Future resumeMultiple(List<String> torrentHashes);

  Future pauseMultiple(List<String> torrentHashes);
  Future unpauseMultiple(String torrentHash);

  Future forceStartMultiple(List<String> torrentHashes);

  Future recheckMultiple(List<String> torrentHashes);
  Future removeMultiple(List<String> torrentHashes);
  Future remoteDataMultiple(List<String> torrentHash);

  // ! get and set properties of torrents
  Future getProperties(String torrentHash);

  Future setProperties(
    String torrentHash, {
    @required Map<String, dynamic> propertiesAndValues,
  });

  // ! To get a list of files under a given torrent job
  Future getListOfFilesUnderATorrentJob(String torrentHash);

  // ! To get a list of torrents and their associated properties
  Future getTorrentList();

  // ! To get or set a list of settings on the torrent client
  Future getClientSettings();

  Future setClientSettings(Map<String, dynamic> settingsAndValues);

  ///Returns the URL of the documentation for the corresponding torrent api
  String getApiDocUrl();
}

/// API Doc at : https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information
abstract class QbitTorrentController extends TorrentController {

  factory QbitTorrentController(String serverIp, int serverPort){
    return new QbitTorrentControllerImpl(serverIp , serverPort) ; 
  }


  Future stopAllTorrents();
  Future startAllTorrents();
  Future pauseAllTorrents();
  Future recheckAllTorrents();
  Future removeAllTorrents();
  Future resumeAllTorrents();

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
  Future<String> getTransferDownloadLimit();

  /// The global download speed limit to set in bytes/second
  Future<String> setTransferDownloadLimit(int limit);

  /// The response is the value of current global upload speed limit in bytes/second; this value will be zero if no limit is applied.
  Future<String> getTransferUploadLimit();

  /// The global upload speed limit to set in bytes/second
  Future<String> setTransferUploadLimit(int limit);

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

  /// Increase priority of one or more hashes or ['all'] hashes
  Future increasePriority(List<String> torrentHashes);

  /// Decrease priority of one or more hashes or ['all'] hashes
  Future decreasePriority(List<String> torrentHashes);

  /// Set max priority to specified torrents
  Future setMaxPriority(List<String> torrentHashes);

  /// Set min priority to specified torrents
  Future setMinPriority(List<String> torrentHashes);

  /// Set file priority of a specific torrent
  /// Params :
  /// [torrentHash] is the hash of torrent
  /// [fileIds] is a list of ids 0 for first file , 1 for next and so on.
  /// [priority] can take the following :
  /// Possible values of priority:
  /// Value	  Description
  /// 0	      Do not download
  /// 1	      Normal priority
  /// 6	      High priority
  /// 7	      Maximal priority
  Future setfilePriority(
      String torrentHash, List<String> fileIds, int priority);

  Future<dynamic> getDownloadLimit(List<String> torrentHashes);
  Future setDownloadLimit(
      List<String> torrentHashes, int limitInBytesPerSecond);

  Future setShareLimit(
      List<String> torrentHashes, double ratioLimit, int seedingTimeLimit);

  Future<dynamic> getUploadLimit(List<String> torrentHashes);
  Future setUploadLimit(List<String> torrentHashes, int limitInBytesPerSecond);

  Future setDownloadLocation(List<String> torrentHashes, String location);

  Future setTorrentName(String torrentHash, String name);

  Future setCategory(List<String> torrentHashes, String category);

  Future<dynamic> getAllCategories();

  Future addNewCategory(String category, String savePath);

  Future editCategory(String category, String newSavePath);

  Future removeCategories(List<String> categories);

  Future addTorrentTags(List<String> torrentHashes, List<String> tags);

  Future removeTorrentTags(List<String> torrentHashes, List<String> tags);

  Future<dynamic> getAllTags();

  Future createTags(List<String> tags);

  Future deleteTags(List<String> tags);

  Future setAutoTorrentManagement(List<String> torrentHashes, bool enable);

  Future toggleSequentialDownload(List<String> torrentHashes);

  Future setFirstOrLastPiecePriority(List<String> torrentHashes);

  Future setForceStart(List<String> torrentHashes, bool value);

  Future setSuperSeeding(List<String> torrentHashes, bool value);
}

abstract class UTorrentApiInterface extends TorrentController {}
