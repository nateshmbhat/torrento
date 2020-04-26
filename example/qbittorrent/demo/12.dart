import 'demo.dart';

// SET Global Download and Upload Limit
void main() async {
  await obj.logIn('natesh', 'password');

  await obj.setTorrentDownloadLimit(
      ['0d18397945bcc9f495818aa2c823ab167dc8da5c'], 9000);

  await obj.logOut();
}
