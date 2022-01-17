import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:huawei_ml/huawei_ml.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  XFile? _image;
  ImagePicker picker = ImagePicker();

  _imgFromCamera() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      getImageResult();
    });
  }

  void getImageResult() async {
    MLLandmarkAnalyzer analyzer = MLLandmarkAnalyzer();

// Configure the recognition settings.
    final setting = MLLandmarkAnalyzerSetting();
    setting.path = _image!.path;
       setting.patternType = MLLandmarkAnalyzerSetting.STEADY_PATTERN;    
     setting.largestNumberOfReturns = 5;   
// Get recognition result asynchronously.
    try {
      List<MLLandmark> list = await analyzer.asyncAnalyzeFrame(setting);

// After the recognition ends, stop analyzer.
      // bool result = await analyzer.stopLandmarkDetection();
      print(list.first.landmark);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _setApiKey();
    _checkPermissions();
    super.initState();
  }

  _setApiKey() async {
    String API_KEY = Uri.encodeComponent(
        "DAEDABuQsxc69ORIjtCEgqA6U+c6jKehbKjsmmDoSpI2RM2YHirS/qSmWLJkZi7guhfXoNvpdCB/OM5g95hMmlftG3A69Abg526NVQ==");

    await MLApplication().setApiKey(apiKey: API_KEY);
  }

  _checkPermissions() async {
    await MLPermissionClient()
        .requestPermission([MLPermission.camera]).then((v) {
      if (!v) {
        _checkPermissions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Based Place Search"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              height: 300,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 1.5)),
              child: _image == null
                  ? Icon(
                      Icons.photo_camera,
                      size: 80,
                    )
                  : Image.file(
                      File(_image!.path),
                      height: 270,
                      width: 270,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: _imgFromGallery,
                  child: Text("Pick Image from Gallery")),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: _imgFromCamera, child: Text("Open Camera")),
            ),
          ],
        ),
      ),
    );
  }
}
