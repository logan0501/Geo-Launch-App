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
  String _landmark = "";
  String _identity = "";
  dynamic _possibility = 0;
  bool _loading = false;
  bool _error = false;

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
      _loading = true;
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
      setState(() {
        _loading = false;
        _error = false;
        _landmark = list.first.landmark;
        _identity = list.first.landmarkId;
        _possibility = list.first.possibility;
      });
      print("data" + list.first.landmark + list.first.possibility.toString());
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _setApiKey();
    _checkPermissions();
    super.initState();
  }

  _setApiKey() {
    MLApplication()
      ..setApiKey(
          apiKey:
              "DAEDABuQsxc69ORIjtCEgqA6U+c6jKehbKjsmmDoSpI2RM2YHirS/qSmWLJkZi7guhfXoNvpdCB/OM5g95hMmlftG3A69Abg526NVQ==");
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
        backgroundColor: Color(0xff161616),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
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
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_image!.path),
                        height: 270,
                        width: 270,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xff161616)),
                  onPressed: _imgFromGallery,
                  child: Text(
                    "Pick Image from Gallery",
                    style: TextStyle(color: Color(0xffFBAA27)),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xff161616)),
                  onPressed: _imgFromCamera,
                  child: Text(
                    "Open Camera",
                    style: TextStyle(color: Color(0xffFBAA27)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            _loading == false
                ? (_error == false
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Details About the Place",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Landmark : ${_landmark}"),
                              Text("Landmark Id : ${_identity}"),
                              Text("Landmark Possibility : ${_possibility}"),
                            ]),
                      )
                    : Center(
                        child: Text(
                        "Picture cannot be Recognized",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 20),
                      )))
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
