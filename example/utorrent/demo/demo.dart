import 'package:torrento/src/torrent_client_controllers/u_torrent/u_torrent_controller.dart';

UTorrentController obj = new UTorrentController(serverIp : '192.168.43.18' , serverPort :  5000) ; 

main() async {
  await obj.logIn('natesh' , 'password') ; 
}