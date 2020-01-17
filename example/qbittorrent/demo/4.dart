import 'demo.dart' ; 

// STOP ALL TORRENTS
main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  await obj.stopAllTorrents() ; 

  await obj.logOut();
}