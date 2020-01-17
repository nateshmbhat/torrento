import 'demo.dart';

// SET Global Download and Upload Limit
main() async{
  await obj.logIn('natesh', 'password') ; 


  await obj.setGlobalDownloadLimit(1000) ; 


  await obj.setGlobalUploadLimit(1000) ; 

  await obj.logOut() ; 
}