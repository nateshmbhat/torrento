import 'package:torrent_api/torrent_api.dart';
import 'package:test/test.dart';

void main() {
  UTorrentApi uTorrentApi;
  String torrentHash;
  List<String> torrentHashes;

  setUpAll(() async {
    uTorrentApi = UTorrentApi(serverIp: '192.168.0.106', serverPort: 5000);

    await uTorrentApi.logIn(username: 'im_mzaink', password: 'admin');

    torrentHash = 'A27E0CF95EE4F1D5CE32E39F4874B0B7BFEDE5DA';

    torrentHashes = [
      'A27E0CF95EE4F1D5CE32E39F4874B0B7BFEDE5DA',
      'E5340FB5C061E4E53618F41B48D7E1CEA445BB02',
    ];
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
    test('Start One', () async {
      expect((await uTorrentApi.startTorrent(torrentHash)).statusCode,
          equals(200));
    });

    test('Start Many', () async {
      expect((await uTorrentApi.startTorrents(torrentHashes)).statusCode,
          equals(200));
    });

    test('Stop', () async {
      expect(
          (await uTorrentApi.stopTorrent(torrentHash)).statusCode, equals(200));
    });

    test('Stop Many', () async {
      expect((await uTorrentApi.stopTorrents(torrentHashes)).statusCode,
          equals(200));
    });

    test('Pause', () async {
      expect((await uTorrentApi.pauseTorrent(torrentHash)).statusCode,
          equals(200));
    });

    test('Pause Many', () async {
      expect((await uTorrentApi.pauseTorrents(torrentHashes)).statusCode,
          equals(200));
    });

    test('Force-Start', () async {
      expect((await uTorrentApi.forceStartTorrent(torrentHash)).statusCode,
          equals(200));
    });

    test('Force-Start Many', () async {
      expect((await uTorrentApi.forceStartTorrents(torrentHashes)).statusCode,
          equals(200));
    });

    test('Unpause', () async {
      expect((await uTorrentApi.unpauseTorrent(torrentHash)).statusCode,
          equals(200));
    });

    test('Unpause Many', () async {
      expect((await uTorrentApi.unpauseTorrents(torrentHashes)).statusCode,
          equals(200));
    });

    test('Recheck', () async {
      expect((await uTorrentApi.recheckTorrent(torrentHash)).statusCode,
          equals(200));
    });

    test('Recheck Many', () async {
      expect((await uTorrentApi.recheckTorrents(torrentHashes)).statusCode,
          equals(200));
    });

    test('Remove', () async {
      expect((await uTorrentApi.removeTorrent(torrentHash)).statusCode,
          equals(200));
    });

    test('Remove Many', () async {
      expect((await uTorrentApi.removeTorrents(torrentHashes)).statusCode,
          equals(200));
    });

    test('Remove-Data', () async {
      expect((await uTorrentApi.removeTorrentAndData(torrentHash)).statusCode,
          equals(200));
    });

    test('Remove-Data Many', () async {
      expect(
          (await uTorrentApi.removeTorrentsAndData(torrentHashes)).statusCode,
          equals(200));
    });

    test('Add Torrent URL', () async {
      String torrentLink =
          'magnet:?xt=urn:btih:e5340fb5c061e4e53618f41b48d7e1cea445bb02&dn=Captain+Marvel+2019+NEW+HD-TS+X264+AC3-SeeHD&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Fopen.demonii.com%3A1337&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Fexodus.desync.com%3A69699';
      ;
      expect((await uTorrentApi.addTorrentUrl(torrentLink)).statusCode,
          equals(200));
    });

    test('Add Torrent File', () async {
      String torrentFilePath =
          'C:\\Users\\Mohammed\ Sadiq\\Downloads\\Google\ Chrome\ Downloads\\The\ Matrix\ (1999)\ [BluRay]\ [1080p]\ [YTS.LT].torrent';
      expect(
          (await uTorrentApi.addTorrentFile(filePath: torrentFilePath))
              .statusCode,
          equals(200));
    });
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
