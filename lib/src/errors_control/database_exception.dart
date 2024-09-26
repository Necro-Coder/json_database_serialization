class DatabaseException implements Exception {
  final String message;
  final dynamic source;

  DatabaseException(this.message, [this.source]);


  @override
  String toString() {
    if (source == null) {
      return 'DatabaseException: $message';
    } else {
      return 'DatabaseException: $message. Source: $source';
    }
  }
}