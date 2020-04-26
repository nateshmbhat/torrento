import 'demo.dart';

// Add NEW CATEGORY
void main() async {
  await obj.logIn('natesh', 'password');

  await obj.addNewCategory('Movies', '/Users/natesh/Desktop');

  await obj.addNewCategory('Games', '/Users/natesh/Desktop');

  await obj.addNewCategory('TV Shows', '/Users/natesh/Desktop');

  await obj.logOut();
}
