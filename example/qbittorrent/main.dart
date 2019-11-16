import 'dart:io';

import 'package:torrent_api/src/qbittorrent_api/qbittorrent_api.dart' ; 

main(List<String> args ) async{
  QBitTorrentAPI obj = new QBitTorrentAPI('192.168.0.100' , 8080) ; 
  await obj.login('natesh' , 'password') ; 

  await obj.startAllTorrents() ; 
  print("Started all torrents. Sleeping for 5 seconds before stopping them all ..zzzZZzzzZZ ") ; 

  sleep(Duration(seconds: 5)) ; 

  await obj.stopAllTorrents() ; 
  print("Stopped all torrents") ;

  print(await obj.getVersion()) ; 

  await obj.logout() ; 

}