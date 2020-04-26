import 'demo.dart';

// REMOVE A PARTICULAR TORRENT
void main(List<String> args) async {
  await obj.logIn('natesh', 'password');

  await obj.removeTorrent(
      '0d18397945bcc9f495818aa2c823ab167dc8da5c'); // Torrent hash of LION KING

  await obj.logOut();
}
