import 'package:auto_size_text/auto_size_text.dart';
import 'package:endcard_upload_flutter/upload_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html';
import 'package:provider/provider.dart';

class DropZoneBox extends StatefulWidget {
  final Color dropZoneColor;
  final double width;
  DropZoneBox({this.dropZoneColor, this.width});

  @override
  _DropZoneBoxState createState() => _DropZoneBoxState();
}

class _DropZoneBoxState extends State<DropZoneBox> {
  final GlobalKey _dropZoneKey = new GlobalKey();
  bool _dropZoneDragOvered = false;
  InputElement _uploadInput;

  void _onTapToUpload() async {
    debugPrint('onTapToUpload');
    //set the accept file extension
    //set the multiple
    _uploadInput = FileUploadInputElement();
    _uploadInput.click();

    _uploadInput.onChange.listen((e) {
      debugPrint('on change');
      _onSelectFile(_uploadInput.files);
    });
  }

  void _onSelectFile(List<File> files) {
    if (files.length == 1) {
      final file = files[0];
      //check the file extension, make sure it's a zip
      //final reader = new FileReader();
      debugPrint('${file.name}, ${file.type}, ${file.size}');
      if (!Provider.of<UploadModel>(context).setUploadFile(file)) {
        //show alert
      }
    }
  }

  @override
  void initState() {
    document.body.onDragOver.listen(_onDragOver);
    document.body.onDrop.listen(_onDrop);
    document.body.onDragLeave.listen(_onDragLeave);
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
    }
    e.stopPropagation();
    e.preventDefault();
  }

  void _onDrop(MouseEvent e) {
    debugPrint('_onDrop');
    Offset pos = Offset(e.layer.x.toDouble(), e.layer.y.toDouble());
    if (_inDropZone(pos)) {
      debugPrint('drop in');
      _dropZoneDragOvered = false;
      _onSelectFile(e.dataTransfer.files);
    }
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
    return Container(
      key: _dropZoneKey,
      color: Colors.white,
      child: GestureDetector(
        onTap: _onTapToUpload,
        child: Container(
          decoration: BoxDecoration(
              color: widget.dropZoneColor,
              border: Border.all(
                  width: 2,
                  color: _dropZoneDragOvered ? Colors.blue : Colors.grey)),
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(10),
          child: Stack(
            //fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              _StaticContent(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _FileBoxInfo(),
                ],
              )
            ],
          ),
        ),
      ),
      height: 300,
      width: widget.width,
    );
  }
}

class _StaticContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Icon(
        Icons.cloud_upload,
        size: 40,
        color: Colors.blue,
      ),
      SizedBox(height: 10),
      Text('Drag a Zip bundle here'),
      SizedBox(height: 10),
      Text('or Browser to upload'),
    ]);
  }
}

class _FileBoxInfo extends StatefulWidget {
  @override
  __FileBoxInfoState createState() => __FileBoxInfoState();
}

class __FileBoxInfoState extends State<_FileBoxInfo> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<UploadModel>(context);
    AutoSizeText text = AutoSizeText(
        model.canUpload ? model.fileToUpload.name : '',
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.clip,
        style: TextStyle(fontSize: 18, color: Colors.blue));

    return text;
  }
}
