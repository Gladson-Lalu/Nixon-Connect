//cloudinary file upload and download
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import dio
import 'package:dio/dio.dart';
import 'package:nixon_connect/Common/validator.dart';

//import open file
import 'package:open_file/open_file.dart';

//import path provider
import 'package:path_provider/path_provider.dart';

//Singleton class for cloudinary
class FileService {
  static final FileService _instance =
      FileService._internal();
  factory FileService() => _instance;
  FileService._internal();
  static FileService get instance => _instance;

  final String cloudName = dotenv.env['CLOUDINARY_NAME']!;
  final String preset = dotenv.env['CLOUDINARY_PRESET']!;

  Future<String> uploadFile(
      {required String filePath,
      ValueChanged? onProgress}) async {
    final cloudinary =
        CloudinaryPublic(cloudName, preset, cache: false);
    final response = await cloudinary
        .uploadFile(
          CloudinaryFile.fromFile(filePath,
              resourceType: CloudinaryResourceType.Auto),
          onProgress: ((count, total) => {
                if (onProgress != null)
                  {onProgress(count / total)}
              }),
        )
        .catchError((e) {});
    return response.secureUrl;
  }

  //open file after download with dio and open_file
  Future<void> downloadAndOpenFile({
    required String url,
    required String fileName,
  }) async {
    print('downloading file');
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);
    if (await file.exists()) {
      await OpenFile.open(filePath);
    } else {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
        onReceiveProgress: (received, total) {
          if (received == total) {
            showToast("Download Complete");
          }
        },
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      await OpenFile.open(filePath);
    }
  }
}
