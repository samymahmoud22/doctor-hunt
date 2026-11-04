class ServerException implements Exception {
  final String message;

  const ServerException([this.message = 'A server error occurred. Please try again later.']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'No internet connection. Please check your network and try again.']);

  @override
  String toString() => message;
}

