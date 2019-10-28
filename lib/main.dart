import 'dart:html';

import 'package:endcard_upload_flutter/upload_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drop_zone.dart';
import 'dart:js' as js;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = 'Vungle Creative QA';
    return MultiProvider(
      providers: [ChangeNotifierProvider(builder: (_) => UploadModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'vungle',
            accentColor: Color(0xFF3C2869)),
        home: MyHomePage(title: title),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color(0xFFF0F2F5),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TitleBox(widget.title),
            SizedBox(
              height: 50,
            ),
            DropZoneBox(dropZoneColor: Color(0xFFF0F2F5)),
            SizedBox(
              height: 20,
            ),
            UploadButton(),
            SizedBox(
              height: 20,
            ),
            InfoBox(),
            SizedBox(
              height: 20,
            ),
            HelpButtonBox(),
          ],
        ),
      )),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class TitleBox extends StatelessWidget {
  final String title;
  TitleBox(this.title);

  @override
  Widget build(BuildContext context) {
    //may add a vungle icon later
    //need change font
    return Container(
      child: Text(title,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    );
  }
}

class UploadButton extends StatefulWidget {
  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  void _onUploadPressed() {
    final model = Provider.of<UploadModel>(context);
    if (model.canUpload) {
      Provider.of<UploadModel>(context).upload();
    }
  }

  @override
  Widget build(BuildContext context) {
    //Widget content;
    // if (Provider.of<UploadModel>(context).uploadState ==
    //     UploadState.uploading) {
    //   content = SizedBox(
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.white,
    //     ),
    //     width: 30,
    //     height: 30,
    //   );
    // } else {
    //   content = Text('Upload');
    // }
    bool isUploading =
        Provider.of<UploadModel>(context).uploadState == UploadState.uploading;
    return RaisedButton(
      color: Colors.blue,
      textColor: Colors.white,
      child: Container(
        width: 80,
        height: 40,
        child: Center(
          child: Text(
            isUploading ? 'Uploading...' : "Upload",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onPressed: _onUploadPressed,
    );
  }
}

class InfoBox extends StatefulWidget {
  @override
  _InfoBoxState createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<UploadModel>(context);
    if (model.uploadState == UploadState.uploaded ||
        model.uploadState == UploadState.uploadFailed) {
      bool failed = model.uploadState == UploadState.uploadFailed;
      return Container(
        //color: Colors.yellow,
        height: 50,
        child: Text(
          model.uploadResultMessage,
          style: TextStyle(
              color: failed ? Colors.red : Colors.green, fontSize: 18),
        ),
      );
    } else {
      return Container(
        height: 50,
      );
    }
  }
}

class HelpButtonBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          //document.window.location.href = "https://www.google.com";
          js.context.callMethod("open", [
            "https://bitbucket.org/vungle_creative_labs/vcl-templates/src/master/"
          ]);
        },
        child: Text('HELP',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            )),
      ),
    );
  }
}
