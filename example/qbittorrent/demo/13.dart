import 'dart:io';

import 'demo.dart';

// SET Global Download and Upload Limit
main() async{
  await obj.logIn('natesh', 'password') ; 

  print(await obj.getAllTags()) ; 

  await obj.createTags(['tag1' , 'tag2' , 'tag3']) ; 

  sleep(Duration(seconds: 10)) ; 

  await obj.deleteTags(['tag1' , 'tag3']) ; 

  await obj.logOut() ; 
}