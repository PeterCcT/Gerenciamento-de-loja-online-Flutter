import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSearchSheet extends StatelessWidget {
  final Function(File) onImageSelected;
  ImageSearchSheet({this.onImageSelected});
  void imageSelected(File image) async {
    if (image != null) {
      File imagemCortada = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      );
      onImageSelected(imagemCortada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            onPressed: () async {
              File image =
                  await ImagePicker.pickImage(source: ImageSource.camera);
              imageSelected(image);
            },
            child: Text('Câmera'),
          ),
          Divider(),
          FlatButton(
              onPressed: () async {
                File image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                imageSelected(image);
              },
              child: Text('Galeria')),
        ],
      ),
    );
  }
}
