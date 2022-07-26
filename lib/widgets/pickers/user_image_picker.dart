import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  final void Function (File pickedImg)imgPick;
  UserImagePicker(this.imgPick);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File? _pickedImgFile;
  void _pickImageByGallery() async {
    final picker = ImagePicker();
    final pickedImg = await picker.pickImage(source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 150);
    setState(() {
      _pickedImgFile = File(pickedImg!.path);
    });
    widget.imgPick(_pickedImgFile!);
    Navigator.of(context).pop();
  }
  void _pickImageByCamera() async {
    final picker = ImagePicker();
    final pickedImg = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImgFile = File(pickedImg!.path);
    });
    widget.imgPick(_pickedImgFile!);
    Navigator.of(context).pop();
  }
  Future<void> _dialogPickImage() async {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (ctx){
          return AlertDialog(
            title: const Text('Choose an avatar', textAlign: TextAlign.center,),
            actions: <Widget>[
              TextButton(onPressed: _pickImageByGallery, child: const Text('Choose from the gallery')),
              TextButton(onPressed: _pickImageByCamera, child: const Text('Take picture'))
            ],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //23_07: Add the image picker
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImgFile != null ? FileImage(_pickedImgFile!) : null,
        ),//Preview the image
        TextButton.icon(onPressed: _dialogPickImage,
          icon: const Icon(Icons.image),
          label: const Text('Choose a picture'),
          style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor
          ),
        ),
      ],
    );
  }
}
