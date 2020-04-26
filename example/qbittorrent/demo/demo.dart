import 'package:torrento/src/qbittorrent/qbittorrent_interface/qbittorrent_controller.dart';

QbitTorrentController obj = QbitTorrentController('192.168.43.51', 8080);

void main() async {
  await obj.logIn('natesh', 'password');
}
