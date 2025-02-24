import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "package:path/path.dart" as path;
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class ImagePickerWidget extends StatefulWidget {
  File? imageFile;
  final Function(String) onImageSelected;
  ImagePickerWidget({super.key, this.imageFile, required this.onImageSelected});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  // Future<void> _pickImage(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     final File file = File(pickedFile.path);
  //     final savedImage = await saveImage(file);
  //     setState(() {
  //       widget.imageFile = savedImage;
  //     });
  //     widget.onImageSelected(savedImage.path);
  //   }
  // }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final savedImage = await saveImage(file);
      setState(() {
        widget.imageFile = savedImage;
      });
      widget.onImageSelected(savedImage.path);
    }
  }

  Future<File> saveImage(File imageFile) async {
    final externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      throw Exception("Impossible d'accéder au stockage externe");
    }

    final extension = path.extension(imageFile.path);
    final fileName = "${DateTime.now().millisecondsSinceEpoch}$extension";
    final savedImage = await imageFile.copy("${externalDir.path}/$fileName");
    return savedImage;
  }

  Future<String> getDefaultImagePath() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception("Impossible d'accéder au stockage externe");
    }
    return "${directory.path}/t-shirt.png";
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choisir depuis la galerie"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Prendre une photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_sharp),
              title: const Text("Image par défaut"),
              onTap: () async {
                Navigator.pop(context);
                // final path = await getDefaultImagePath();
                // final defaultFile = File(path);

                // if (!defaultFile.existsSync()) {
                //   ByteData data =
                //       await rootBundle.load("lib/assets/images/t-shirt.png");
                //   List<int> bytes = data.buffer.asUint8List();
                //   await defaultFile.writeAsBytes(bytes);
                // }
                // setState(() {
                //   widget.imageFile = defaultFile;
                // });
                // widget.onImageSelected(defaultFile.path);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImagePickerOptions,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                  image: widget.imageFile != null
                      ? DecorationImage(
                          image: FileImage(widget.imageFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.imageFile == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: 50.0,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
