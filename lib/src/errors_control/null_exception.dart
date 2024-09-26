class NullException {
  final String message;
  final dynamic source;

  NullException(this.message, [this.source]);

  @override
  String toString() {
    if (source == null) {
      return 'NullException: $message';
    } else {
      return 'NullException: $message. Source: $source';
    }
  }
}