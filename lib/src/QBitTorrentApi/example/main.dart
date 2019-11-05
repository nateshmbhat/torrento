import 'package:torrent_api/src/QBitTorrentApi/QBitTorrentApi.dart';

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
