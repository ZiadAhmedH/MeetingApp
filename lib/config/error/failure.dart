class Failure {
  final String message;
  final String? source;

  Failure(this.message, {this.source});

  @override
  String toString() => source != null ? '[$source] $message' : message;
}
