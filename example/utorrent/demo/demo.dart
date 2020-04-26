import 'package:torrento/src/utorrent/u_torrent_controller.dart';

UTorrentController obj =
    UTorrentController(serverIp: '192.168.43.18', serverPort: 5000);

void main() async {
  await obj.logIn('natesh', 'password');
}
