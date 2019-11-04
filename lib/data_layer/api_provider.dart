import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import '../models/models.dart';
import '../models/serializers.dart';

/// класс предоставляющий доступ к API приложения
class ApiProvider {
  final _storage = FlutterSecureStorage();

  static const String _baseUrl = '82.146.46.168';
  static const String _hashKey = 'nova_hash';
  static const int _retryCount = 5;

  /// метод выхода из приложения
  Future<void> logout() async {
    await _storage.delete(key: _hashKey);
  }

  /// метод возвращающий состояние аутентификации
  Future<bool> isAuthenticated() async {
    final hash = await _storage.read(key: _hashKey);
    return hash != null;
  }

  Future<void> addUserImage({http.Client client, File image, int id}) async {
    final uri = Uri.http(_baseUrl, '/users/$id/add-photo/');
    final request = http.MultipartRequest('POST', uri);
    final imageStream = http.ByteStream(
      DelegatingStream.typed(image.openRead()),
    );
    final imageLength = await image.length();
    final extension = image.path.split('.').last;
    request.files.add(
      http.MultipartFile(
        'profile_pic',
        imageStream,
        imageLength,
        filename: image.path.split('/').last,
      ),
    );
    final response = await retry(
      () => client.send(request),
      maxAttempts: _retryCount,
    );
    final r = await http.Response.fromStream(response);
    print(r.request.toString());
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
  }

  /// метод добавления изображения
  Future<String> addImage({http.Client client, File image}) async {
    final uri = Uri.http(_baseUrl, '/images/upload');
    final request = http.Request('POST', uri);
    final bytes = await image.readAsBytes();
    request.bodyBytes = bytes;
    final streamedResponse = await retry(
      () => client.send(request),
      maxAttempts: _retryCount,
    );
    if (streamedResponse.statusCode != 200) {
      throw HttpException(
        '${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}',
        uri: uri,
      );
    }
    final response = await http.Response.fromStream(streamedResponse);
    final imageUri = Uri.http(
      _baseUrl,
      '/images/${response.body}',
    );
    return imageUri.toString();
  }

  /// метод аутентификации
  Future<void> authenticate({
    http.Client client,
    String email,
    String password,
  }) async {
    final uri = Uri.http(_baseUrl, '/auth/$email');
    final hash = base64.encode(utf8.encode('$email:$password'));
    final response = await retry(
      () => client.get(
        uri,
        headers: {HttpHeaders.authorizationHeader: 'Basic $hash'},
      ),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw AccountActivationException();
    }
    await _storage.write(key: _hashKey, value: hash);
  }

  Future<void> addToTeam(
      {http.Client client, int projectId, int userId}) async {
    final uri = Uri.http(
      _baseUrl,
      '/project/$projectId/add-new-member/',
      {'user': userId.toString()},
    );
    final response = await retry(
      () => client.post(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
  }

  Future<void> saveConversation({
    http.Client client,
    List<int> participants,
    String message,
  }) async {
    final uri = Uri.http(_baseUrl, '/conversation');
    final body = '{"participants":$participants,'
        '"message":"${base64.encode(utf8.encode(message))}"}';
    final response = await retry(
      () => client.post(uri, body: body),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 201) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
  }

  Future<List<String>> getConverstion({
    http.Client client,
    List<int> participants,
    int page,
  }) async {
    final uri = Uri.http(
      _baseUrl,
      '/conversation',
      {
        'participants': participants.length == 1
            ? '${participants.first},${participants.first}'
            : participants.join(',')
      },
    );
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return (json.decode(response.body) as List<dynamic>).cast<String>();
  }

  /// метод возвращающий текущего залогиненого пользователя
  Future<User> getCurrentUser({http.Client client}) async {
    final hash = await _storage.read(key: _hashKey);
    final uri = Uri.http(_baseUrl, '/auth/userinfo/');
    final response = await retry(
      () {
        return client.get(
          uri,
          headers: {HttpHeaders.authorizationHeader: 'Basic $hash'},
        );
      },
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return _parseUser(utf8.decode(response.bodyBytes));
  }

  /// метод возвразающий лист [Project]'ов
  Future<BuiltList<Project>> getProjects({
    http.Client client,
    int offset,
    int quantity,
  }) async {
    final uri = Uri.http(_baseUrl, 'projects/limit/$offset-$quantity');
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseProjects, response.body);
  }

  /// метод возвращающий [Project] с id равным [id]
  Future<Project> getProject({http.Client client, int id}) async {
    final uri = Uri.http(_baseUrl, 'projects/$id');
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseProject, response.body);
  }

  /// метод добавления проекта
  Future<void> addProject({
    http.Client client,
    Map<String, String> data,
  }) async {
    final creator = await getCurrentUser(client: client);
    final hash = await _storage.read(key: _hashKey);
    final uri = Uri.http(
      _baseUrl,
      '/projects/create',
      data..addAll({'creator_id': creator.id.toString()}),
    );
    final response = await retry(
      () {
        return client.post(
          uri,
          // headers: {HttpHeaders.authorizationHeader: 'Basic $hash'},
        );
      },
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
  }

  /// метод увеличивающий колличество лайков у проекта с id равным [projectId]
  Future<void> likeProject({http.Client client, int projectId}) async {
    final hash = await _storage.read(key: _hashKey);
    final userId = (await getCurrentUser(client: client)).id;
    final checkUri = Uri.http(_baseUrl, '/project-likes/$projectId/$userId');
    final checkResponse = await retry(
      () => client.get(checkUri),
      maxAttempts: _retryCount,
    );
    if (checkResponse.statusCode != 200) {
      throw HttpException(
        '${checkResponse.statusCode} - ${checkResponse.reasonPhrase}',
        uri: checkUri,
      );
    }
    final checkResult = await compute(_parseLikes, checkResponse.body);
    if (checkResult.isEmpty) {
      final likeUri = Uri.http(_baseUrl, '/project/$projectId/like');
      final likeResponse = await retry(
        () {
          return client.put(
            likeUri,
            headers: {HttpHeaders.authorizationHeader: 'Basic $hash'},
          );
        },
        maxAttempts: _retryCount,
      );
      if (likeResponse.statusCode != 200) {
        throw HttpException(
          '${likeResponse.statusCode} - ${likeResponse.reasonPhrase}',
          uri: likeUri,
        );
      }
      final insertUri = Uri.http(
        _baseUrl,
        'project-likes/insert',
        {
          'project-id': projectId.toString(),
          'app-user-id': userId.toString(),
        },
      );
      final insertResponse = await retry(
        () => client.post(insertUri),
        maxAttempts: _retryCount,
      );
      if (insertResponse.statusCode != 200) {
        throw HttpException(
          '${insertResponse.statusCode} - ${insertResponse.reasonPhrase}',
          uri: insertUri,
        );
      }
    } else {
      final unlikeUri = Uri.http(_baseUrl, '/project/$projectId/unlike');
      final unlikeResponse = await retry(
        () {
          return client.put(
            unlikeUri,
            headers: {HttpHeaders.authorizationHeader: 'Basic $hash'},
          );
        },
        maxAttempts: _retryCount,
      );
      if (unlikeResponse.statusCode != 200) {
        throw HttpException(
          '${unlikeResponse.statusCode} - ${unlikeResponse.reasonPhrase}',
          uri: unlikeUri,
        );
      }
      final removeResponse = await retry(
        () => client.delete(checkUri),
        maxAttempts: _retryCount,
      );
      if (removeResponse.statusCode != 200) {
        throw HttpException(
          '${removeResponse.statusCode} - ${removeResponse.reasonPhrase}',
          uri: checkUri,
        );
      }
    }
  }

  /// метод редактирования проекта с id равным [id]
  Future<void> updateProject({
    http.Client client,
    int id,
    Map<String, String> data,
  }) async {
    final hash = await _storage.read(key: _hashKey);
    final uri = Uri.http(_baseUrl, '/projects/$id', data);
    final response = await retry(
      () {
        return client.put(
          uri,
          headers: {'Authorization': 'Basic $hash'},
        );
      },
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
  }

  /// метод возвращающий лист [User]'ов
  Future<BuiltList<User>> getUsers({
    http.Client client,
    int page,
  }) async {
    final uri = Uri.http(_baseUrl, '/app-users/', {
      'page': page.toString(),
      'format': 'json',
    });
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseUsers, utf8.decode(response.bodyBytes));
  }

  /// метод возвращающий [User]'а с id равным [id]
  Future<User> getUser({http.Client client, int id}) async {
    final uri = Uri.http(_baseUrl, '/app-users/info/$id');
    final hash = await _storage.read(key: _hashKey);
    final response = await retry(
      () {
        return client.get(
          uri,
          headers: {HttpHeaders.authorizationHeader: 'Basic $hash'},
        );
      },
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseUser, utf8.decode(response.bodyBytes));
  }

  /// метод добавляющий дорожную карту с названием [title], возвращает id созданной дорожной карты
  Future<int> addRoadmap({http.Client client, String title}) async {
    final hash = await _storage.read(key: _hashKey);
    final uri = Uri.http(
      _baseUrl,
      '/roadmap/create',
      {'title': title},
    );
    final response = await retry(
      () {
        return client.post(
          uri,
          headers: {'Authorization': 'Basic $hash'},
        );
      },
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return int.parse(response.body);
  }

  /// метод добавляющий [User]'а
  Future<void> addUser({
    http.Client client,
    Map<String, String> data,
    File image,
  }) async {
    final uri = Uri.http(
      _baseUrl,
      '/users/',
    );
    final response = await retry(
      () => client.post(
        uri,
        body: jsonEncode(data),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      ),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    final user = await compute(_parseUser, response.body);
    await addUserImage(client: client, image: image, id: user.id);
  }

  /// метод возвращающий лист [Chapter]'ов [Roadmap]'а с id равным [id]
  Future<BuiltList<Chapter>> getChapters({http.Client client, int id}) async {
    final uri = Uri.http(_baseUrl, '/roadmap/$id');
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseChapters, response.body);
  }

  /// метод добавляющий [Chapter] в [Roadmap] с id равным [id]
  Future<void> addChapter({
    http.Client client,
    int id,
    Map<String, String> data,
  }) async {
    final hash = await _storage.read(key: _hashKey);
    final uri = Uri.http(
      _baseUrl,
      '/roadmap/$id/chapter/add',
      {
        'title': data['title'],
        'description': data['description'],
        'date-to': data['date-to'],
        'date-from': data['date-from'],
        'is-active': data['is-active'],
      },
    );
    final response = await retry(
      () {
        return client.post(
          uri,
          headers: {'Authorization': 'Basic $hash'},
        );
      },
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
  }

  /// метод возвращающий [Vacancy] с id равным [id]
  Future<Vacancy> getVacancy({http.Client client, int id}) async {
    final uri = Uri.http(_baseUrl, '/vacancies/$id');
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseVacancy, response.body);
  }

  /// метод возвращающий лист [Vacancy]
  Future<BuiltList<Vacancy>> getVacancies({
    http.Client client,
    int offset,
    int quantity,
  }) async {
    final uri = Uri.http(_baseUrl, '/vacancies/limit/$offset-$quantity');
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseVacancies, response.body);
  }

  /// метод добавления вакансии
  Future<void> addVacancy({
    http.Client client,
    Map<String, String> data,
  }) async {
    final hash = await _storage.read(key: _hashKey);
    final uri = Uri.http(
      _baseUrl,
      '/vacancies/project-${data['id']}',
      {
        'title': data['title'],
        'description': data['description'],
        'skills': data['skills'],
      },
    );
    final response = await retry(
      () {
        return client.post(
          uri,
          headers: {'Authorization': 'Basic $hash'},
        );
      },
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
  }

  /// метод обновления вакансии с id равным [id]
  Future<void> updateVacancy({
    http.Client client,
    int id,
    String title,
    String description,
    String skills,
  }) async {
    final hash = await _storage.read(key: _hashKey);
    final uri = Uri.http(
      _baseUrl,
      '/vacancies/project-$id',
      {
        'title': title,
        'description': description,
        'skills': skills,
      },
    );
    final response = await retry(
      () {
        return client.put(
          uri,
          headers: {'Authorization': 'Basic $hash'},
        );
      },
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
  }

  /// метод возвращающий лист [Vacancy] относящихся к [Project]'у с id равным [id]
  Future<BuiltList<Vacancy>> getProjectVacancies({
    http.Client client,
    int id,
  }) async {
    final uri = Uri.http(_baseUrl, '/projects/$id/vacancies');
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseVacancies, response.body);
  }

  /// метод возвращающий колличество лайков [Project]'а с id равным [id]
  Future<int> getProjectLikes({http.Client client, int id}) async {
    final uri = Uri.http(_baseUrl, '/projects/$id/get_likes');
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return int.parse(response.body);
  }

  /// метод возвращающий лист [Project]'ов созданных [User]'ом с id равным [id]
  Future<BuiltList<Project>> getUsersProjects({
    http.Client client,
    int id,
  }) async {
    final uri = Uri.http(_baseUrl, '/app-users/$id/projects');
    final response = await retry(
      () => client.get(uri),
      maxAttempts: _retryCount,
    );
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} - ${response.reasonPhrase}',
        uri: uri,
      );
    }
    return compute(_parseProjects, response.body);
  }

  /// метод возвращающий лист [Vacancy] созданных [User]'ом с id равным [id]
  Future<BuiltList<Vacancy>> getUsersVacancies({
    http.Client client,
    int id,
  }) async {
    final projects = await getUsersProjects(id: id, client: client);
    final futures = projects.map(
      (project) {
        return getProjectVacancies(
          client: client,
          id: project.id,
        );
      },
    );
    final v = await Future.wait(futures);
    final vacancies = BuiltList<Vacancy>(v.expand((i) => i));
    return vacancies;
  }

  /// метод сброса пароля
  Future<void> resetPassword({http.Client client, String email}) async {
    final uri = Uri.http(_baseUrl, '/app-users/pass-reset', {'email': email});
    final response = await client.post(uri);
    if (response.statusCode != 200) {}
  }
}

BuiltList<Project> _parseProjects(String response) {
  final parsed = jsonDecode(response);
  final projects = deserializeListOf<Project>(parsed);
  return projects;
}

Project _parseProject(String response) {
  final parsed = jsonDecode(response);
  final projects = deserializeListOf<Project>(parsed);
  return projects[0];
}

BuiltList<User> _parseUsers(String response) {
  final parsed = jsonDecode(response);
  final users = deserializeListOf<User>(parsed).toList();
  for (var i = 0; i < users.length; i++) {
    if (users[i].profilePic == null) continue;
    users[i] = users[i].rebuild(
      (b) => b
        ..profilePic = Uri.http(
          ApiProvider._baseUrl,
          b.profilePic,
        ).toString(),
    );
  }
  return BuiltList<User>(users);
}

User _parseUser(String response) {
  final parsed = jsonDecode(response);
  var user = deserialize<User>(parsed);
  if (user.profilePic != null) {
    user = user.rebuild(
      (b) => b
        ..profilePic = Uri.http(
          ApiProvider._baseUrl,
          b.profilePic,
        ).toString(),
    );
  }
  return user;
}

BuiltList<Chapter> _parseChapters(String response) {
  final parsed = jsonDecode(response);
  final chapters = deserializeListOf<Chapter>(parsed);
  return chapters;
}

BuiltList<Vacancy> _parseVacancies(String response) {
  final parsed = jsonDecode(response);
  final vacancies = deserializeListOf<Vacancy>(parsed);
  return vacancies;
}

Vacancy _parseVacancy(String response) {
  final parsed = jsonDecode(response);
  final vacancies = deserializeListOf<Vacancy>(parsed);
  return vacancies[0];
}

BuiltList<LikeResult> _parseLikes(String response) {
  final parsed = jsonDecode(response);
  final likes = deserializeListOf<LikeResult>(parsed);
  return likes;
}

class AccountActivationException implements Exception {
  String get message => 'Внимание: Активируйте аккаунт';

  @override
  String toString() => message;
}
