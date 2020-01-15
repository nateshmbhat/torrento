import 'package:torrential_lib/src/core/contracts/qbittorrent_controller/qbittorrent_controller.dart';
import 'package:torrential_lib/torrential_lib.dart';

QbitTorrentController obj = new QbitTorrentController('192.168.0.101', 8080);


// STOP ALL TORRENTS
main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  await obj.stopAllTorrents() ; 

  await obj.logOut();
}