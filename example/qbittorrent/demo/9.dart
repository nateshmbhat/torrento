import 'demo.dart';

// Add NEW CATEGORY 
main() async{
  await obj.logIn('natesh', 'password') ; 

  await obj.addNewCategory('Movies', '/Users/nateshmbhat/Desktop') ; 

  await obj.addNewCategory('Games', '/Users/nateshmbhat/Desktop') ; 


  await obj.addNewCategory('TV Shows', '/Users/nateshmbhat/Desktop') ; 


  await obj.logOut() ; 
}