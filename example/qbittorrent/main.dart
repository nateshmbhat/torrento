import 'package:torrento/torrento.dart';

void main(List<String> args) async {
  QbitTorrentController obj = QbitTorrentController('192.168.0.101', 8080);
  await obj.logIn('natesh', 'password');

  await obj.addTorrent(
      'magnet:?xt=urn:btih:0d18397945bcc9f495818aa2c823ab167dc8da5c&dn=The.Lion.King.2019.1080p.BluRay.H264.AAC-RARBG');

  var torrents = await obj.getTorrentsList(filter: TorrentFilter.paused);

  torrents.forEach((t) => print('${t['name']} : ${t['hash']}'));

  print('Starting all torrents');
  await obj.startAllTorrents();

  print(await obj.getVersion());

  await obj.logOut();
}

/**
 * SAMPLE TORRENT URLS 

  magnet:?xt=urn:btih:0d18397945bcc9f495818aa2c823ab167dc8da5c&dn=The.Lion.King.2019.1080p.BluRay.H264.AAC-RARBG 

  magnet:?xt=urn:btih:d370b1e1923f01008389a98f1fecf800dc78cc2c&dn=Jurassic%20Park%20The%20Lost%20World%20(1997)%20%5b1080p%5d&tr=udp%3a%2f%2fexodus.desync.com%3a6969%2fannounce&tr=udp%3a%2f%2ftracker.openbittorrent.com%3a80%2fannounce&tr=udp%3a%2f%2ftracker.1337x.org%3a80%2fannounce&tr=http%3a%2f%2fexodus.desync.com%3a6969%2fannounce&tr=udp%3a%2f%2ftracker.yify-torrents.com%2fannounce


  magnet:?xt=urn:btih:fb71eea2959ea406b0feeca4c28cf1c15495e80f&dn=Godzilla.King.of.the.Monsters.2019.1080p.WEBRip.x264-RARBG


  magnet:?xt=urn:btih:1b3c0a0203dc252b4c551bc2b8584ee7603b4ede&dn=Back%20to%20the%20Future%20Part%203%20(1990)%20%5b1080p%5d&tr=udp%3a%2f%2fexodus.desync.com%3a6969%2fannounce&tr=udp%3a%2f%2ftracker.openbittorrent.com%3a80%2fannounce&tr=udp%3a%2f%2ftracker.1337x.org%3a80%2fannounce&tr=http%3a%2f%2fexodus.desync.com%3a6969%2fannounce&tr=udp%3a%2f%2ftracker.yify-torrents.com%2fannounce
  
 */
