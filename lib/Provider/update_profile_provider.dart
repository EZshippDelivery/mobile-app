import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/themes.dart';
import '../utils/variables.dart';
import 'customer_controller.dart';

class UpdateProfileProvider extends CustomerController {
  UpdateProfileProvider() {
    getColor();
  }

  getColor() async {
    final colorIndex = await Variables.read(key: "color_index");
    index = colorIndex != null ? int.parse(colorIndex) : Random().nextInt(Colors.primaries.length);
    notifyListeners();
  }

  getProfileImage({double size = 150, bool canEdit = false, bool isNotEqual = false}) {
    // ignore: unused_local_variable
    var split = fullName.split(" ");
    return Material(
        shape: const CircleBorder(),
        elevation: 2,
        child: CircleAvatar(
            radius: size / 2,
            backgroundColor: isNotEqual ? Colors.white : Colors.primaries[index],
            child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                    height: size,
                    width: size,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: Colors.primaries[index], image: decorationImage),
                    child: decorationImage == null
                        ? Stack(children: [
                            Center(child: Text(name, style: Variables.font(fontSize: size / 2.5, color: Colors.white))),
                            if (canEdit)
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Palette.deepgrey,
                                          border: Border.all(
                                              width: 4, color: size < 130 ? Palette.kOrange : Colors.grey[200]!)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(Icons.edit, color: Colors.white, size: size < 130 ? 13 : 25),
                                      )))
                          ])
                        : null))));
  }

  void inkwell(BuildContext context, {bool showOptions = true}) async {
    XFile? image;
    try {
      if (showOptions) image = await ImagePicker().pickImage(source: await showoptions(context));
    } catch (e) {
      Variables.showtoast(context, "removed profile image", Icons.check);
    } finally {
      if (image != null) {
        decorationImage = DecorationImage(image: FileImage(File(image.path)), fit: BoxFit.cover);
      } else {
        decorationImage = null;
      }
    }
    notifyListeners();
  }

  showoptions(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          "Choose",
          style: Variables.font(fontSize: 23, color: Palette.deepgrey),
        ),
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
            title: Text("Camera", style: Variables.font(fontSize: 18)),
          ),
          ListTile(
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            title: Text("Gallery", style: Variables.font(fontSize: 18)),
          ),
          ListTile(
            onTap: () => Navigator.of(context).pop(),
            title: Text("None", style: Variables.font(fontSize: 18)),
          )
        ],
      ),
    );
  }
}
