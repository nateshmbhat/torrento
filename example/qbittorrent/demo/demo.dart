import 'package:torrento/src/core/contracts/qbittorrent_controller/qbittorrent_controller.dart';

QbitTorrentController obj = new QbitTorrentController('192.168.43.51' , 8080) ; 

main() async {
  await obj.logIn('natesh' , 'password') ; 
}