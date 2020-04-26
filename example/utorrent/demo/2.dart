import 'demo.dart';

// GET TORRENT LIST
Future getTorrents() async {
  var torrents = await obj.getTorrentsList();

  torrents.forEach((t) => print(t));
}

void main() async {
  await obj.logIn('natesh', 'password');

  await getTorrents();

  await obj.logOut();
}
