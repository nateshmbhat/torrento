import 'package:torrential_lib/src/core/contracts/qbittorrent_controller/qbittorrent_controller.dart';

QbitTorrentController obj = new QbitTorrentController('192.168.0.104' , 8080) ; 

main() async {
  await obj.logIn('natesh' , 'password') ; 
}