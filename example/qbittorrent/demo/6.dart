import 'package:torrential_lib/src/torrent_client_controllers/qbittorrent/qbittorrent_controller.dart';
import 'package:torrential_lib/torrential_lib.dart';

QbitTorrentController obj = new QbitTorrentController('192.168.0.101', 8080);


// PAUSE A PARTICULAR TORRENT
main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  await obj.pauseTorrent('0d18397945bcc9f495818aa2c823ab167dc8da5c') ;  // Torrent hash of Lion King

  await obj.logOut();
}