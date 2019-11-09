import 'package:http/http.dart';

class InvalidParameterException implements Exception{
  Response response ; 
  InvalidParameterException(this.response) ; 
}

class InvalidCredentialsException implements Exception{
  Response response  ; 
  InvalidCredentialsException(this.response) ; 
}


class UnauthorsizedAccessException implements Exception{
  Response response  = null; 
  UnauthorsizedAccessException(this.response); 
}

class InvalidRequestException implements Exception{
  Response response ; 
  InvalidRequestException(this.response) ; 
}