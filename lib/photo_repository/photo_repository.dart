// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:very_good_coffee/data_models/photo_model.dart';

const String _photoDownloadURL = 'https://coffee.alexflipnote.dev/random.json';

class PhotoRepositoryException implements Exception {
  PhotoRepositoryException([this.message]);

  String? message;
}

class PhotoRepository {
  PhotoRepository();

  Directory? _appDocsDir;

  Future<PhotoModel?> fetchAndCacheSinglePhotoFromNetwork(
    String cacheName,
  ) async {
    PhotoModel? newPhoto;
    final docPath = await _getAppDocsDir();
    http.Response response;

    try {
      response = await http.get(Uri.parse(_photoDownloadURL));
    } catch (e) {
      throw PhotoRepositoryException('Network error');
    }
    // Download the new photo and save it in local storage
    // TODO: Handle possible exception from json parse error
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      newPhoto = PhotoModel.fromJson(data);
      final localFileName = newPhoto.localFileNameResolved;

      if (localFileName != null) {
        final localFileNameWithFullPath = path.join(docPath.path, localFileName);
        http.Response photoResponse;

        try {
          photoResponse = await http.get(Uri.parse(newPhoto.remoteUrl!));
        } catch (e) {
          throw PhotoRepositoryException('Network error');
        }
        if (photoResponse.statusCode == 200) {
          // TODO: Handle possible OOM exception as json error?
          final imageFile = File(localFileNameWithFullPath);
          newPhoto.image = await imageFile.writeAsBytes(photoResponse.bodyBytes);
        }
      }
    } else {
      throw PhotoRepositoryException('Network error');
    }
    await _addPhotoToPersistentCache(cacheName, newPhoto);
    return newPhoto;
  }

  Future<void> _addPhotoToPersistentCache(String cacheName, PhotoModel photo) async {
    final photoList = await getPhotosFromPersistentCache(cacheName)
      ..insert(0, photo);

    final updatedCache = json.encode(photoList.map((p) => p.toJson()).toList());
    final cacheFile = await _fileFromDocsDir('$cacheName.json');
    cacheFile.writeAsStringSync(updatedCache);
  }

  Future<void> deletePhotoFromPersistentCache(String cacheName, PhotoModel photo) async {}

  Future<void> moveCachedPhoto(String sourceCacheName, String destinationCacheName, PhotoModel photo) async {}

  Future<void> deleteAllPhotosFromPersistentCache(String cacheName) async {}

  Future<int> getPersistentCachePhotoCount(String cacheName) async {
    return 0;
  }

  Future<List<PhotoModel>> getPhotosFromPersistentCache(String cacheName) async {
    List<PhotoModel>? photoList;

    final cacheFile = await _fileFromDocsDir('$cacheName.json');

    if (cacheFile.existsSync()) {
      final contents = await cacheFile.readAsString();
      // TODO: Handle possible exception from json parse errors
      final rawList = await jsonDecode(contents) as List<dynamic>;
      final docPath = await _getAppDocsDir();
      // ignore: implicit_dynamic_parameter
      photoList = rawList.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>)).toList()
        ..forEach((photo) async {
          final localFileNameWithFullPath = path.join(docPath.path, photo.localFileName!);
          photo.image = File(localFileNameWithFullPath);
        });
    }

    return photoList ?? <PhotoModel>[];
  }

  Future<File> _fileFromDocsDir(String filename) async {
    final dir = await _getAppDocsDir();
    final pathName = path.join(dir.path, filename);
    return File(pathName);
  }

  Future<Directory> _getAppDocsDir() async {
    return _appDocsDir ?? (_appDocsDir = await path_provider.getApplicationDocumentsDirectory());
  }
}
