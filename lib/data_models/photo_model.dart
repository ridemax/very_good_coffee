import 'dart:io';

import 'package:path/path.dart' as p;

class PhotoModel {
  PhotoModel(this.remoteUrl, {this.localFileName, this.image});

  PhotoModel.fromJson(Map<String, dynamic> json) {
    remoteUrl = json['file'] as String?;
    localFileName = json['localFileName'] as String?;
  }

  String? localFileName;
  String? remoteUrl;
  File? image;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['file'] = remoteUrl;
    data['localFileName'] = localFileName;
    return data;
  }

  // Create a new filename for the local file if the name doesn't already exist.
  // Use the same file extension as the remote Url
  String? get localFileNameResolved {
    if (localFileName != null) {
      return localFileName;
    } else if (remoteUrl == null) {
      return null;
    } else {
      return localFileName = _idGenerator() + p.extension(remoteUrl!);
    }
  }

  String _idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
}
