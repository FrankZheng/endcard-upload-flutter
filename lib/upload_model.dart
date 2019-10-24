import 'dart:async';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http_parser/http_parser.dart';

const int DEBUG_PORT = 8091; //for local server

Future<void> doUpload(UploadModel model) {
  final reader = new FileReader();
  final file = model.fileToUpload;
  model.uploading = true;
  reader.onLoadEnd.listen((_) async {
    Timer(Duration(microseconds: 100), () async {
      var data = reader.result;
      var formData = FormData.fromMap({
        'bundle': MultipartFile.fromBytes(data,
            filename: file.name, contentType: MediaType.parse(file.type))
      });
      try {
        var response = await model.dio.post('/upload', data: formData);
        print(response.runtimeType);
        print('response:${response.data}');
        model.uploading = false;
      } catch (e) {
        print('Failed to upload file, ${e.toString()}');
        model.uploading = false;
      }
    });
  });
  reader.readAsArrayBuffer(model.fileToUpload);
  return Future.value(null);
}

class UploadModel with ChangeNotifier {
  File _fileToUpload;
  bool _uploading = false;
  String uploadResultMessage;
  Dio dio;

  bool get canUpload => _fileToUpload != null;

  File get fileToUpload => _fileToUpload;

  set uploading(bool value) {
    _uploading = value;
    notifyListeners();
  }

  UploadModel() {
    dio = new Dio();
    // dio.options.connectTimeout = 3000;
    // dio.options.receiveTimeout = 3000;

    Location location = document.window.location;
    String baseUrl = kReleaseMode
        ? 'http://${location.host}'
        : 'http://${location.hostname}:$DEBUG_PORT';
    dio.options.baseUrl = baseUrl;
  }

  void upload() {
    //Start to upload the file
    //Set the uploading = true;
    //set the uploadResultMessage when upload success or failed
    assert(canUpload);
    compute(doUpload, this);

    // final reader = new FileReader();
    // final file = _fileToUpload;
    // uploading = true;
    // reader.onLoadEnd.listen((_) async {
    //   var data = reader.result;

    //   var formData = FormData.fromMap({
    //     'bundle': MultipartFile.fromBytes(data,
    //         filename: file.name, contentType: MediaType.parse(file.type))
    //   });
    //   try {
    //     var response = await dio.post('/upload', data: formData);
    //     print(response.runtimeType);
    //     print('response:${response.data}');
    //     uploading = false;
    //   } catch (e) {
    //     print('Failed to upload file, ${e.toString()}');
    //     uploading = false;
    //   }
    // });
    // reader.readAsArrayBuffer(_fileToUpload);
  }

  bool setUploadFile(File file) {
    //check if file's type is zip or file limit size
    _fileToUpload = file;

    notifyListeners();
    return true;
  }
}
