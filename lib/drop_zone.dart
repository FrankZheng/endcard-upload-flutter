import 'package:dio/dio.dart';
import 'package:endcard_upload_flutter/upload_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

class DropZoneBox extends StatefulWidget {
  final Color dropZoneColor;
  DropZoneBox({this.dropZoneColor});

  @override
  _DropZoneBoxState createState() => _DropZoneBoxState();
}

class _DropZoneBoxState extends State<DropZoneBox> {
  final GlobalKey _dropZoneKey = new GlobalKey();
  bool _dropZoneDragOvered = false;
  InputElement _uploadInput;
  //String baseUrl;

  void _onTapToUpload() async {
    debugPrint('onTapToUpload');
    //set the accept file extension
    //set the multiple
    _uploadInput = FileUploadInputElement();
    _uploadInput.click();

    _uploadInput.onChange.listen((e) {
      debugPrint('on change');
      // read file content as dataURL
      final files = _uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        //check the file extension, make sure it's a zip
        //final reader = new FileReader();
        debugPrint('${file.name}, ${file.type}, ${file.size}');
        if (!Provider.of<UploadModel>(context).setUploadFile(file)) {
          //show alert
        }

        // reader.onLoadEnd.listen((e) {
        //   debugPrint('onLoadEnd');
        //   var data = reader.result;
        //   //debugPrint('${data.runtimeType}');
        //   //need check the reader.result type
        //   //if (data is String) {
        //   _handleResult(file, data);
        //   //}
        // });
        // //reader.readAsDataUrl(file);
        // reader.readAsArrayBuffer(file);
      }
    });
  }

  // void _handleResult(File file, List<int> data) async {
  //   debugPrint('handleResult, size:${data.length}');

  //   var formData = FormData.fromMap({
  //     'bundle': MultipartFile.fromBytes(data,
  //         filename: file.name, contentType: MediaType.parse(file.type))
  //   });
  //   Dio dio = new Dio();
  //   dio.options.baseUrl = baseUrl;
  //   var uploadUrl = '/upload';
  //   print('uploadUrl: $uploadUrl');
  //   try {
  //     var response = await dio.post(uploadUrl, data: formData);
  //     print('response:${response.data}');
  //   } catch (e) {
  //     print('Failed to upload file, ${e.toString()}');
  //   }
  // }

  @override
  void initState() {
    document.body.onDragOver.listen(_onDragOver);
    document.body.onDrop.listen(_onDrop);
    document.body.onDragLeave.listen(_onDragLeave);
    // Location location = document.window.location;
    // if (!kReleaseMode) {
    //   //for debug mode, we connect to a local mock server
    //   baseUrl = 'http://${location.hostname}:8091';
    //   print('base url: $baseUrl');
    // } else {
    //   //for release mode, the web files hosted on the same host with the backend api
    //   baseUrl = 'http://${location.host}';
    // }

    super.initState();
  }

  void _onDragOver(MouseEvent e) {
    debugPrint('_onDragOver');
    Offset pos = Offset(e.layer.x.toDouble(), e.layer.y.toDouble());
    if (_inDropZone(pos)) {
      if (!_dropZoneDragOvered) {
        setState(() {
          this._dropZoneDragOvered = true;
        });
      }
    } else {
      if (_dropZoneDragOvered) {
        setState(() {
          this._dropZoneDragOvered = false;
        });
      }
      e.stopPropagation();
      e.preventDefault();
    }
  }

  void _onDrop(MouseEvent e) {
    debugPrint('_onDrop');
    Offset pos = Offset(e.layer.x.toDouble(), e.layer.y.toDouble());
    _inDropZone(pos);
    e.stopPropagation();
    e.preventDefault();
  }

  void _onDragLeave(MouseEvent e) {
    debugPrint('_onDragLeave');
    e.stopPropagation();
    e.preventDefault();
  }

  bool _inDropZone(Offset posIn) {
    final RenderBox renderBoxDropZone =
        _dropZoneKey.currentContext.findRenderObject();
    final size = renderBoxDropZone.size;
    final pos = renderBoxDropZone.localToGlobal(Offset.zero);
    Rect rect = Rect.fromLTWH(pos.dx, pos.dy, size.width, size.height);
    //debugPrint('size:$size, pos:$pos, in:${rect.contains(posIn)}');
    return rect.contains(posIn);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<UploadModel>(context);

    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            color: widget.dropZoneColor,
            border: Border.all(
                width: 1,
                color: _dropZoneDragOvered ? Colors.blue : Colors.grey)),
        margin: EdgeInsets.all(20),
        //color: Color(0xFFF0F2F5),
        child: GestureDetector(
          onTap: _onTapToUpload,
          child: Column(
            key: _dropZoneKey,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cloud_upload,
                size: 40,
                color: Colors.blue,
              ),
              SizedBox(height: 10),
              Text('Drag a Zip bundle here'),
              SizedBox(height: 10),
              Text('or Browser to upload'),
              if (model.canUpload) Text(model.fileToUpload.name),
            ],
          ),
        ),
      ),
      height: 300,
      width: 640,
    );
  }
}
