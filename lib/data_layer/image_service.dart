import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../data_layer/api_provider.dart';

/// сервис работы с изображениями
class ImageService {
  final _api = ApiProvider();

  /// метод добавления изображения возвращает url изображения
  Future<String> addImage({http.Client client, File image}) {
    return _api.addImage(client: client, image: image);
  }

  Future<void> addUserImage({
    http.Client client,
    File image,
    int id,
  }) {
    return _api.addUserImage(
      client: client,
      image: image,
      id: id,
    );
  }
}
