import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
//Caution: Only works on Android & iOS platforms
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

// contains code from:
// https://medium.com/codechai/uploading-image-to-firebase-storage-in-flutter-app-android-ios-31ddd66843fc
class UploadImageScreen extends StatelessWidget {
  static const routeName = 'UploadImageScreen';
  final navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: UploadingImageToFirebaseStorage(),
    );
  }
}

class UploadingImageToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  File _imageFile;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    // Camera is 0 and Gallery is 1
    final pickedFile = isSelected[0] == true
        ? await picker.getImage(source: ImageSource.camera)
        : await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<String> uploadImageToFirebase(BuildContext context) async {
    String url;
    String fileName = basename(_imageFile.path) + DateTime.now().toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uploads/$fileName');
    UploadTask uploadTask = ref.putFile(_imageFile);
    await uploadTask.whenComplete(() async => url = await ref.getDownloadURL());
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Card(
                child: Text(
                  'Select An Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
            ), // container

            // Camera icon
            Card(
              child: ClipRRect(
                child: _imageFile != null
                    ? SizedBox(
                        child: Image.file(_imageFile),
                        height: 350,
                        width: 350,
                      )
                    : TextButton(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 100,
                        ),
                        onPressed: pickImage,
                      ),
              ),
            ),

            // toggle button
            Card(
              child: ToggleButtons(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Camera',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Gallery',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    // index is the selected toggle button
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                },
                isSelected: isSelected,
              ), /* toggle buttons */
            ),

            Card(
              child: Container(
                child: ElevatedButton(
                  onPressed: () async {
                    String url = await uploadImageToFirebase(context);
                    print('Got image URL: $url');
                    Navigator.pop(context, url);
                  },
                  child: Text(
                    "Upload Image",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
