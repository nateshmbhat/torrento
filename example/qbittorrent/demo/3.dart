import 'demo.dart' ; 
import 'package:torrento/torrento.dart';

// GET TORRENT LIST BASED ON THE APPLIED FILTER
Future getTorrents() async {
  var torrents = await obj.getTorrentsList(filter: TorrentFilter.paused   );
  torrents.forEach((t) => print('${t['name']} - ${t['hash']}'));
}

main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  getTorrents() ; 

  await obj.logOut();
}