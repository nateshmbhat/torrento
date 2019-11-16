import 'dart:io';

import 'package:torrent_api/torrent_api.dart';


main(List<String> args ) async{
  QbitTorrentController obj = new QbitTorrentController('192.168.0.100' , 8080) ; 
  await obj.login('natesh' , 'password') ; 

  await obj.startAllTorrents() ; 
  print("Started all torrents.\nSleeping for 5 seconds before stopping them all ..zzzZZzzzZZ ") ; 

  sleep(Duration(seconds: 5)) ; 

  await obj.stopAllTorrents() ; 
  print("Stopped all torrents") ;

  print(await obj.getVersion()) ; 

  await obj.logout() ; 

}