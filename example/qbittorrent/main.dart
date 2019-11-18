import 'dart:io';

import 'package:torrential_lib/torrential_lib.dart';


main(List<String> args ) async{
  QbitTorrentController obj = new QbitTorrentController('192.168.0.100' , 8080) ; 
  await obj.logIn('natesh' , 'password') ; 

  var torrents = await obj.getTorrentsList() ; 

  torrents.forEach((t)=>print(t['name'])) ; 
  
  print("Stopping all torrents") ;
  await obj.stopAllTorrents() ; 

  print(await obj.getVersion()) ; 

  await obj.logOut() ; 
}