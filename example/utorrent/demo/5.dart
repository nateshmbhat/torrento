import 'demo.dart';

// RESUME A PARTICULAR TORRENT
void main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  var files =
      await obj.getFilesOfTorrent('1B3C0A0203DC252B4C551BC2B8584EE7603B4EDE');
  print(files);

  await obj.logOut();
}
