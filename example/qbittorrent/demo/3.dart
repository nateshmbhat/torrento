import 'package:torrential_lib/src/torrent_client_controllers/qbittorrent/qbittorrent_controller.dart';
import 'package:torrential_lib/torrential_lib.dart';

QbitTorrentController obj = new QbitTorrentController('192.168.0.101', 8080);


// GET TORRENT LIST BASED ON THE APPLIED FILTER
Future getTorrents() async {
  var torrents = await obj.getTorrentsList(filter: TorrentFilter.paused   );
  torrents.forEach((t) => print('${t['name']} - ${t['hash']}'));
}

main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  getTorrents() ; 

  await obj.logOut();
}