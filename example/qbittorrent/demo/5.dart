import 'demo.dart' ; 

// START ALL TORRENTS
main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  await obj.startAllTorrents() ; 

  await obj.logOut();
}