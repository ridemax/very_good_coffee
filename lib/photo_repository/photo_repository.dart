import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:very_good_coffee/data_models/photo_model.dart';

const String _photoDownloadURL = 'https://coffee.alexflipnote.dev/random.json';
const String _favoritesFileName = 'favorites.json';

class PhotoRepositoryException implements Exception {
  PhotoRepositoryException([this.message]);

  String? message;
}

class PhotoRepository {
  PhotoRepository();

  Directory? _appDocsDir;

  Future<PhotoModel?> fetchAndCacheSinglePhotoFromNetwork(
    String cacheID, {
    bool deleteCurrentCache = false,
  }) async {
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
        final imageFile = File(localFileNameWithFullPath);
        newPhoto.image = NetworkToFileImage(
          url: newPhoto.remoteUrl,
          file: imageFile,
        );
        // NEXT: Delete previously-cached image if deleteCurrentCache is true.
        // Also replace contents of cached json with new image.
      }
    } else {
      throw PhotoRepositoryException('Network error');
    }
    return newPhoto;
  }

  Future<File> fileFromDocsDir(String filename) async {
    final dir = await _getAppDocsDir();
    final pathName = path.join(dir.path, filename);
    return File(pathName);
  }

  Future<Directory> _getAppDocsDir() async {
    return _appDocsDir ?? (_appDocsDir = await path_provider.getApplicationDocumentsDirectory());
  }
}
