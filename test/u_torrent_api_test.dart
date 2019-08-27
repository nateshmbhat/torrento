import 'package:torrent_api/torrent_api.dart';
import 'package:test/test.dart';

void main() {
  UTorrentApi uTorrentApi;

  setUpAll(() async {
    uTorrentApi = UTorrentApi(serverIp: '192.168.0.106', serverPort: 5000);

    await uTorrentApi.logIn(username: 'im_mzaink', password: 'admin');
  });

  group('Authentication', () {
    test('LogIn Pass', () async {
      UTorrentApi logInPassObject =
          UTorrentApi(serverIp: '192.168.0.106', serverPort: 5000);
      expect(
          await logInPassObject.logIn(username: 'im_mzaink', password: 'admin'),
          isTrue);
    });

    test('LogIn Fail', () async {
      UTorrentApi logInFailObject =
          UTorrentApi(serverIp: '192.168.0.106', serverPort: 5000);
      expect(
          await logInFailObject.logIn(
              username: 'im_mzaink', password: 'wrong-password'),
          isFalse);
    });
  });

  group('Actions', () {
    test('Start', () async {});
    test('Stop', () async {});
    test('Pause', () async {});

    test('Force-Start', () async {});

    test('Unpause', () async {});

    test('Recheck', () async {});

    test('Remove', () async {});

    test('Remove-data', () async {});
  });

  group('Torrent List', () {
    test('List All Torrents', () async {
      expect(await uTorrentApi.torrentsList, isNotNull);
    });
  });

  tearDown(() {
    uTorrentApi = null;
  });
}
