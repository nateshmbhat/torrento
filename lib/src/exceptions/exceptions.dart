class InvalidParameterException implements Exception{
  final String cause ; 
  InvalidParameterException(this.cause) ; 
}

class InvalidCredentialsException implements Exception{
  final String cause ; 
  InvalidCredentialsException(this.cause) ; 
}


class UnauthorsizedAccessException implements Exception{
  final String cause ; 
  UnauthorsizedAccessException(this.cause) ; 
}

class InvalidRequestException implements Exception{
  final String cause ; 
  InvalidRequestException(this.cause) ; 
}