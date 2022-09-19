//circular image picker for profile picture and room avatar

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../Common/constant.dart';

Widget circleImagePicker(
    {required BuildContext context,
    required File? imageFile,
    required ValueChanged onImageChange,
    bool isProfile = true}) {
  void takePhoto(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    //copy the file to a app directory
    final appDirectory =
        await getApplicationDocumentsDirectory();
    final fileName = pickedFile!.path.split('/').last;
    final savedImage = await File(pickedFile.path)
        .copy('${appDirectory.path}/$fileName');
    onImageChange(savedImage);
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => {
                          takePhoto(ImageSource.camera),
                          Navigator.pop(context)
                        },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: const [
                          Icon(Icons.camera),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Camera"),
                        ],
                      ),
                    )),
                ElevatedButton(
                    onPressed: () => {
                          takePhoto(ImageSource.gallery),
                          Navigator.pop(context)
                        },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: const [
                          Icon(Icons.image),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Gallery"),
                        ],
                      ),
                    )),
              ])
        ],
      ),
    );
  }

  return Center(
    child: Stack(children: <Widget>[
      CircleAvatar(
        radius: 60.0,
        backgroundImage: imageFile == null && isProfile
            ? const AssetImage("assets/images/profile.png")
            : imageFile == null && !isProfile
                ? const AssetImage("assets/images/room.png")
                : FileImage(File(imageFile!.path))
                    as ImageProvider,
      ),

      //give black shade to profile image
      Positioned.fill(
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              context: context,
              builder: ((builder) => bottomSheet(context)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.04),
                  Colors.black.withOpacity(0.04),
                ],
              ),
            ),
          ),
        ),
      ),

      const Positioned(
        bottom: 20.0,
        right: 0.0,
        child: Icon(
          Icons.camera_alt,
          color: kPrimaryColor,
          size: 28.0,
        ),
      ),
    ]),
  );
}
