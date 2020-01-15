
import 'package:torrential_lib/src/core/contracts/qbittorrent_controller/qbittorrent_controller.dart';

QbitTorrentController obj = new QbitTorrentController('192.168.0.101', 8080);


// GET TORRENT LIST
Future getTorrents() async {
  var torrents = await obj.getTorrentsList();

  torrents.forEach((t) => print('${t['name']}    -    ${t['hash']}'));
}

main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  getTorrents() ; 

  await obj.logOut();
}