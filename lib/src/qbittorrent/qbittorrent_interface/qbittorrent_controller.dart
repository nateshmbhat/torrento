import 'dart:async';
import 'package:torrento/src/core/torrent_interface.dart';
import 'package:torrento/src/qbittorrent/qbittorrent_controller.dart';

enum TorrentFilter {
  all,
  downloading,
  completed,
  paused,
  active,
  inactive,
  resumed
}

// API Doc at : https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation#general-information
abstract class QbitTorrentController extends TorrentController {
  factory QbitTorrentController(String serverIp, int serverPort) {
    return QbitTorrentControllerImpl(serverIp, serverPort);
  }

  Future stopAllTorrents();
  Future startAllTorrents();
  Future pauseAllTorrents();
  Future recheckAllTorrents();
  Future removeAllTorrents();
  Future resumeAllTorrents();

  @override
  Future stopTorrent(String torrentHash);

  /// param torrentHashes is an array of torrent hashes or ['all'] for all torrents
  @override
  Future stopMultipleTorrents(List<String> torrentHashes);

  Future<bool> isLoggedIn();
  Future<String> getVersion();

  ///Only supported from qbittorrent 4.2.0+
  Future<dynamic> getBuildInfo();

  Future<String> getDefaultSavePath();
  Future<String> getWebApiVersion();
  Future shutdownApplication();

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
  Future<String> getGlobalDownloadLimit();

  /// The global download speed limit to set in bytes/second
  Future<String> setGlobalDownloadLimit(int limit);

  /// The response is the value of current global upload speed limit in bytes/second; this value will be zero if no limit is applied.
  Future<String> getGlobalUploadLimit();

  /// The global upload speed limit to set in bytes/second
  Future<String> setGlobalUploadLimit(int limit);

  ///  The peer to ban, or multiple peers. Each peer is a colon-separated host:port
  Future<String> banPeers(List<String> peers);

  /// Get a list of torrents based on the filters and applied parameters. See api docs for more info on response object
  @override
  Future<List> getTorrentsList(
      {TorrentFilter filter,
      String category,
      String sort,
      bool reverse,
      int limit,
      int offset,
      List<String> hashes});

  /// Get torrent generic properties
  @override
  Future<dynamic> getTorrentProperties(String torrentHash);

  Future<dynamic> getTorrentTrackers(String torrentHash);

  Future<dynamic> getTorrentWebSeeds(String torrentHash);
  Future<dynamic> getTorrentContents(String torrentHash);
  Future<dynamic> getTorrentPieceStates(String torrentHash);
  Future<dynamic> getTorrentPieceHashes(String torrentHash);

  /// param torrentHashes is an array of torrent hashes or ['all'] for all torrents
  @override
  Future pauseMultipleTorrents(List<String> torrentHashs);

  /// param torrentHashes is an array of torrent hashes or ['all'] for all torrents
  Future removeMultipleTorrentsWithData(List<String> torrentHashs);

  /// param torrentHashes is an array of torrent hashes or ['all'] to reannounce all torrents
  Future<String> reannounceTorrents(List<String> torrentHashs);

  /// Add new torrent
  //Params :
  /// urls : list of URLs
  ///torrents : Raw data of torrent file. torrents can be presented multiple times.
  @override
  Future addTorrent(String url,
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
      bool prioritizeFirstLastPiece = false});

  /// Add new torrents
  ///Params :
  /// urls : list of URLs
  ///torrents : Raw data of torrent file. torrents can be presented multiple times.
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
      bool prioritizeFirstLastPiece = false});

  Future addTorrentTrackers(String torrentHash, List<String> trackers);

  Future editTorrentTrackers(
      String torrentHash, List<String> oldTrackers, List<String> newTrackers);

  Future removeTorrentTrackers(String torrentHash, List<String> trackers);

  Future addTorrentPeers(List<String> torrentHashes, List<String> peers);

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
  Future setTorrentDownloadLimit(
      List<String> torrentHashes, int limitInBytesPerSecond);

  Future setShareLimit(
      List<String> torrentHashes, double ratioLimit, int seedingTimeLimit);

  Future<dynamic> getUploadLimit(List<String> torrentHashes);
  Future setTorrentUploadLimit(
      List<String> torrentHashes, int limitInBytesPerSecond);

  Future setTorrentName(String torrentHash, String name);

  Future setCategory(List<String> torrentHashes, String category);

  Future<dynamic> getAllCategories();

  Future addNewCategory(String category, String savePath);

  Future editCategory(String category, String newSavePath);

  Future removeCategories(List<String> categories);

  Future addTorrentTags(List<String> torrentHashes, List<String> tags);

  Future removeTorrentTags(List<String> torrentHashes, List<String> tags);

  Future<List<String>> getAllTags();

  Future createTags(List<String> tags);

  Future deleteTags(List<String> tags);

  Future setAutoTorrentManagement(List<String> torrentHashes, bool enable);

  Future toggleSequentialDownload(List<String> torrentHashes);

  Future setFirstOrLastPiecePriority(List<String> torrentHashes);

  Future setForceStart(List<String> torrentHashes, bool value);

  Future setSuperSeeding(List<String> torrentHashes, bool value);
}
