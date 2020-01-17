import 'demo.dart' ;

// GET TORRENT LIST
Future getTorrents() async {
  var torrents = await obj.getTorrentsList();

  torrents.forEach((t) => print('${t['name']}    -    ${t['hash']}'));
}

main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  getTorrents() ; 

  await obj.logOut();
}