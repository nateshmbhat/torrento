import 'package:torrent_api/torrent_api.dart';
import 'package:test/test.dart';

void main() {
  UTorrentApi uTorrentApi;

  setUpAll(() async {
    uTorrentApi = UTorrentApi(serverIp: '192.168.0.106', serverPort: 5000);

    await uTorrentApi.logIn(username: 'im_mzaink', password: 'admin');
  });

  tearDown(() {
    uTorrentApi = null;
  });
}
