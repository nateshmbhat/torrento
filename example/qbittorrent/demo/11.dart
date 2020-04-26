import 'demo.dart';

// SET Global Download and Upload Limit
void main() async {
  await obj.logIn('natesh', 'password');

  await obj.setGlobalDownloadLimit(50000);

  await obj.setGlobalUploadLimit(9000);

  await obj.logOut();
}
