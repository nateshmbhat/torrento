import 'demo.dart';

// PAUSE A PARTICULAR TORRENT
void main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  await obj.resumeTorrent(
      '0d18397945bcc9f495818aa2c823ab167dc8da5c'); // Torrent hash of Lion King

  await obj.logOut();
}
