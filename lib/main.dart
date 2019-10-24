import 'package:endcard_upload_flutter/upload_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drop_zone.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(builder: (_) => UploadModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
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
            TitleBox(),
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
          ],
        ),
      )),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class TitleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //may add a vungle icon later
    //need change font
    return Container(
      child: Text('Vungle Creative QA Test',
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
    return RaisedButton(
      child: Container(
        width: 80,
        height: 40,
        child: Center(child: Text('Upload')),
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
    return Container(
      child: Text('Uploaded Success'),
    );
  }
}
