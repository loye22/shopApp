


class HttpExption implements Exception {
  final String msg ;
  HttpExption({this.msg});

  @override
  String toString() {
    return msg ;
  }
}