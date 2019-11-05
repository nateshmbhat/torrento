
class ApiEndPoint{
  static final API_AUTH_LOGIN = '/auth/login';
  static final API_AUTH_LOGOUT = '/auth/logout';

  static final API_APP_VERSION = '/app/version';
  static final API_APP_BUILDINFO = '/app/buildInfo';
  static final API_APP_SHUTDOWN = '/app/shutdown';
  static final API_APP_PREFERENCES = '/app/preferences';
  static final API_APP_DEFAULT_SAVE_PATH = '/app/defaultSavePath';
  static final API_APP_SET_PREFERENCES = '/app/setPreferences';
  static final API_APP_WEBAPIVERSION = '/app/webapiVersion';

  static final API_LOG_MAIN = '/log/main';
  static final API_LOG_PEER = '/log/peers';

  static final API_SYNC_MAINDATA = '/sync/maindata';
  static final API_SYNC_TORRENT_PEERS = '/sync/torrentPeers';

  static final API_TRANSFER_INFO = '/transfer/info';
  static final API_TRANSFER_SPEED_LIMITS_MODE = '/transfer/speedLimitsMode';
  static final API_TRANSFER_TOGGLE_SPEED_LIMITS = '/transfer/toggleSpeedLimitsMode';
  static final API_TRANSFER_DOWNLOAD_LIMIT = '/transfer/downloadLimit';
  static final API_TRANSFER_SET_DOWNLOAD_LIMIT = '/transfer/setDownloadLimit';
  static final API_TRANSFER_UPLOAD_LIMIT = '/transfer/uploadLimit';
  static final API_TRANSFER_SET_UPLOAD_LIMIT = '/transfer/setUploadLimit';
  static final API_TRANSFER_BAN_PEERS= '/transfer/banPeers';

  static final API_TORRENT_INFO = '/torrents/info';
  static final API_TORRENT_PROPERTIES = '/torrents/properties';
  static final API_TORRENT_TRACKERS = '/torrents/trackers';
  static final API_TORRENT_WEBSEEDS = '/torrents/webseeds';
  static final API_TORRENT_FILES = '/torrents/files';
  static final API_TORRENT_PIECE_STATES = '/torrents/pieceStates';
  static final API_TORRENT_PIECE_HASHES = '/torrents/pieceHashes';
  static final API_TORRENT_PAUSE = '/torrents/pause';
  static final API_TORRENT_RESUME = '/torrents/resume';
  static final API_TORRENT_DELETE = '/torrents/delete';
  static final API_TORRENT_RECHECK = '/torrents/recheck';
  static final API_TORRENT_REANNOUNCE = '/torrents/reannounce';
  static final API_TORRENT_ADD = '/torrents/add';
  static final API_TORRENT_ADD_TRACKERS = '/torrents/addTrackers';
  static final API_TORRENT_ADD_PEERS = '/torrents/addPeers';
  static final API_TORRENT_EDIT_TRACKERS = '/torrents/editTracker';

  static final API_TORRENT_REMOVE_TRACKERS = '/torrents/removeTrackers' ; 

  static final API_TORRENT_INCREASE_PRIORITY = '/torrents/increasePrio';
  static final API_TORRENT_DECREASE_PRIORITY = '/torrents/decreasePrio';
  static final API_TORRENT_TOP_PRIORITY = '/torrents/topPrio';
  static final API_TORRENT_BOTTOM_PRIORITY = '/torrents/bottomPrio';
  static final API_TORRENT_SET_FILE_PRIORITY = '/torrents/filePrio';
  static final API_TORRENT_DOWNLOAD_LIMIT = '/torrents/downloadLimit';
  static final API_TORRENT_UPLOAD_LIMIT = '/torrents/uploadLimit';
  static final API_TORRENT_SET_DOWNLOAD_LIMIT = '/torrents/setDownloadLimit';
  static final API_TORRENT_SET_UPLOAD_LIMIT = '/torrents/setUploadLimit';
  static final API_TORRENT_SET_SHARE_LIMIT = '/torrents/setShareLimits';
  static final API_TORRENT_SET_LOCATION = '/torrents/setLocation';
  static final API_TORRENT_RENAME = '/torrents/rename';
  static final API_TORRENT_CATEGORY = '/torrents/categories';
  static final API_TORRENT_CREATE_CATEGORY = '/torrents/createCategory';
  static final API_TORRENT_SET_CATEGORY = '/torrents/setCategory';
  static final API_TORRENT_EDIT_CATEGORY = '/torrents/editCategory';
  static final API_TORRENT_REMOVE_CATEGORY = '/torrents/removeCategories';
  static final API_TORRENT_ADD_TAGS = '/torrents/addTags';
  static final API_TORRENT_REMOVE_TAGS = '/torrents/removeTags';
  static final API_TORRENT_TAGS = '/torrents/tags';
  static final API_TORRENT_CREATE_TAGS = '/torrents/createTags';
  static final API_TORRENT_DELETE_TAGS = '/torrents/deleteTags';
  static final API_TORRENT_SET_AUTOMANAGEMENT = '/torrents/setAutoManagement';
  static final API_TORRENT_TOGGLE_SEQUENTIAL_DOWNLOAD =
      '/torrents/toggleSequentialDownload';
  static final API_TORRENT_TOGGLE_FIRST_LAST_PRIO =
      '/torrents/toggleFirstLastPiecePrio';
  static final API_TORRENT_SET_FORCE_START = '/torrents/setForceStart';
  static final API_TORRENT_SET_SUPER_SEEDING = '/torrents/setSuperSeeding';

  static final API_RSS_ADD_FOLDER = '/rss/addFolder';
  static final API_RSS_ADD_FEED = '/rss/addFeed';
  static final API_RSS_REMOVE_ITEM = '/rss/removeItem';
  static final API_RSS_MOVE_ITEM = '/rss/moveItem';
  static final API_RSS_ITEMS = '/rss/items';
  static final API_RSS_SET_RULE = '/rss/setRule';
  static final API_RSS_RENAME_RULE = '/rss/renameRule';
  static final API_RSS_REMOVE_RULE = '/rss/removeRule';
  static final API_RSS_RULES = '/rss/rules';

  static final API_SEARCH_START = '/search/start';
  static final API_SEARCH_STOP = '/search/stop';
  static final API_SEARCH_STATUS = '/search/status';
  static final API_SEARCH_RESULTS = '/search/results';
  static final API_SEARCH_DELETE = '/search/delete';
  static final API_SEARCH_CATEGORIES = '/search/categories';
  static final API_SEARCH_PLUGINS = '/search/plugins';
  static final API_SEARCH_INSTALL_PLUGIN = '/search/installPlugin';
  static final API_SEARCH_UNINSTALL_PLUGIN = '/search/uninstallPlugin';
  static final API_SEARCH_ENABLE_PLUGIN = '/search/enablePlugin';
  static final API_SEARCH_UPDATE_PLUGINS = '/search/updatePlugins';



}