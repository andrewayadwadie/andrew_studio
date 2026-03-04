import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(body: {'status': 'Andrew Studio API running', 'version': '1.0.0'});
}
