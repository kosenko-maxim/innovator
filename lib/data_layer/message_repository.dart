import 'package:http/http.dart' as http;

import 'api_provider.dart';

class MessageRepository {
  final _api = ApiProvider();

  Future<void> save({
    http.Client client,
    List<int> participants,
    String message,
  }) {
    return _api.saveConversation(
      client: client,
      participants: participants,
      message: message,
    );
  }

  Future<List<String>> get({
    http.Client client,
    List<int> participants,
    int page,
  }) {
    return _api.getConverstion(
      client: client,
      participants: participants,
      page: page,
    );
  }
}
