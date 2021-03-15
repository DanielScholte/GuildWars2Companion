class ApiException implements Exception {
  final String apiMessage;

  ApiException(this.apiMessage);
}