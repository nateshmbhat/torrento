class InvalidParameterException implements Exception{
  final String cause ; 
  InvalidParameterException(this.cause) ; 
}

class InvalidCredentialsException implements Exception{
  final String cause ; 
  InvalidCredentialsException(this.cause) ; 
}