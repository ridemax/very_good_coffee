// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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

  Future<PhotoModel?> fetchAndCacheSinglePhotoFromNetwork(String cacheName, {bool replaceCacheContents = false}) async {
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
      throw PhotoRepositoryException('Repository: network error');
    }
    if (replaceCacheContents) {
      await deleteAllPhotosFromPersistentCache(cacheName);
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

  Image getImageFromPhoto(PhotoModel photoModel) {
    return Image.file(key: Key(photoModel.localFileName!), photoModel.image!);
  }

  Future<void> moveCachedPhoto(String sourceCacheName, String destinationCacheName, PhotoModel photo) async {
    try {
      final sourceList = await getPhotosFromPersistentCache(sourceCacheName);
      final destinationList = await getPhotosFromPersistentCache(destinationCacheName);

      sourceList.removeWhere((element) => element.localFileName == photo.localFileName);
      destinationList.insert(0, photo);

      var cacheFile = await _fileFromDocsDir('$sourceCacheName.json');
      var updatedCache = json.encode(sourceList.map((p) => p.toJson()).toList());
      cacheFile.writeAsStringSync(updatedCache);

      cacheFile = await _fileFromDocsDir('$destinationCacheName.json');
      updatedCache = json.encode(destinationList.map((p) => p.toJson()).toList());
      cacheFile.writeAsStringSync(updatedCache);
    } catch (_) {
      throw PhotoRepositoryException('Repository: json parse error');
    }
  }

  Future<void> deleteAllPhotosFromPersistentCache(String cacheName) async {
    for (final photo in await getPhotosFromPersistentCache(cacheName)) {
      try {
        final photoFile = await _fileFromDocsDir(photo.localFileName!);
        await photoFile.delete();
      } catch (_) {} // We're going to ignore any exceptions when attempting to delete individual photo files,
      // since there isn't anything useful the user could do in this case anyway
      // TODO: Handle this case in Cubit to make this more explicit and not buried down here in the repository
    }

    final cacheFile = await _fileFromDocsDir('$cacheName.json');
    if (cacheFile.existsSync()) {
      cacheFile.deleteSync();
    }
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
