import 'dart:async';

abstract class TorrentController {
  // * To handle single torrent

  Future logIn(String username, String password);
  Future logOut();

  Future startTorrent(String torrentHash);
  Future stopTorrent(String torrentHash);
  Future resumeTorrent(String torrentHash);

  Future pauseTorrent(String torrentHash);
  Future unpauseTorrent(String torrentHash);

  Future forceStartTorrent(String torrentHash);

  Future removeTorrent(String torrentHash);
  Future removeTorrentAndData(String torrentHash);
  Future recheckTorrent(String torrentHash);

  Future addTorrent(String torrentUrl);

  // * To handle multiple torrents

  Future startMultipleTorrents(List<String> torrentHashes);
  Future stopMultipleTorrents(List<String> torrentHashes);
  Future resumeMultipleTorrents(List<String> torrentHashes);

  Future pauseMultipleTorrents(List<String> torrentHashes);
  Future unpauseMultipleTorrents(List<String> torrentHash);

  Future forceStartMultipleTorrents(List<String> torrentHashes);

  Future recheckMultipleTorrents(List<String> torrentHashes);
  Future removeMultipleTorrents(List<String> torrentHashes);
  Future removeMultipleTorrentsAndData(List<String> torrentHash);

  // ! get and set properties of torrents
  Future getPropertiesOfTorrent(String torrentHash);

  Future setPropertiesOfTorrent(
    String torrentHash, {
    Map<String, dynamic> propertiesAndValues,
  });

  // ! To get a list of files under a given torrent job
  Future getListOfFilesUnderATorrentJob(String torrentHash);

  // ! To get a list of torrents and their associated properties
  Future getTorrentsList();

  // ! To get or set a list of settings on the torrent client
  Future getClientSettings();

  ///set any particular client setting. Only parameters that need to be changed are to be specified (not the whole prefernces )
  Future setClientSettings(Map<String, dynamic> settingsAndValues);

  ///Returns the URL of the documentation for the corresponding torrent api
  String getApiDocUrl();
}


