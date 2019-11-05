import 'package:http/http.dart';

class InvalidParameterException implements Exception{
  String cause ; 
  Response response ; 
  InvalidParameterException.fromCause(this.cause) ; 
  InvalidParameterException(this.response) ; 
}

class InvalidCredentialsException implements Exception{
  String cause ; 
  Response response  ; 
  InvalidCredentialsException.fromCause(this.cause) ; 
  InvalidCredentialsException(this.response) ; 
}


class UnauthorsizedAccessException implements Exception{
  String cause ; 
  Response response  = null; 
  UnauthorsizedAccessException.fromCause(this.cause) ; 
  UnauthorsizedAccessException(this.response); 
}

class InvalidRequestException implements Exception{
  Response response ; 
  String cause  ;
  InvalidRequestException(this.response) ; 
  InvalidRequestException.fromCause(this.cause) ; 
}