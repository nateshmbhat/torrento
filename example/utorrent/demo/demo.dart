import 'package:torrential_lib/src/torrent_client_controllers/u_torrent/u_torrent_controller.dart';
import 'package:torrential_lib/torrential_lib.dart'  ; 

UTorrentController obj = new UTorrentController(serverIp : '192.168.43.18' , serverPort :  5000) ; 

main() async {
  await obj.logIn('natesh' , 'password') ; 
}