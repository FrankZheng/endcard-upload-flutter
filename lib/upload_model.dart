import 'dart:async';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http_parser/http_parser.dart';

const int DEBUG_PORT = 8091; //for local server

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
    dio.options.connectTimeout = 3000;
    dio.options.receiveTimeout = 3000;

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

    final reader = new FileReader();
    reader.onLoadEnd.listen((_) {
      //seems the callback has been called in a main(ui) thread, maybe within the browser native thread.
      //so do anything here will block the UI interaction.
      //so here we use a timer to do the real uploading.
      Timer(Duration(milliseconds: 100),
          () => this._doUpload(_fileToUpload, reader));
    });
    uploading = true;
    reader.readAsArrayBuffer(_fileToUpload);
  }

  void _doUpload(File file, FileReader reader) async {
    var data = reader.result;
    var formData = FormData.fromMap({
      'bundle': MultipartFile.fromBytes(data,
          filename: file.name, contentType: MediaType.parse(file.type))
    });
    try {
      var response = await dio.post('/upload', data: formData);
      debugPrint(response.data.runtimeType.toString());
      debugPrint('response:${response.data}');
      uploading = false;
    } catch (e) {
      print('Failed to upload file, ${e.toString()}');
      uploading = false;
    }
  }

  bool setUploadFile(File file) {
    //check if file's type is zip or file limit size
    _fileToUpload = file;

    notifyListeners();
    return true;
  }
}
