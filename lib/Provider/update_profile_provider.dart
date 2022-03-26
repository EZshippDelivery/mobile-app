import 'dart:io';
import 'dart:math';

import 'package:ezshipp/APIs/profile.dart';
import 'package:ezshipp/APIs/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../APIs/get_customerprofile.dart';
import '../utils/http_requests.dart';
import '../utils/themes.dart';
import '../utils/variables.dart';

class UpdateProfileProvider extends ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  var profile;
  int index = 0;
  DecorationImage? decorationImage;
  String name = "";
  String fullName = "";
  String plan = "";
  int orderscount = 0;

  UpdateProfileProvider() {
    getColor();
  }

  getprofile(BuildContext context,String path) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: path));
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        if (path.contains("customer")) {
          profile = CustomerDetails.fromMap(responseJson);
        } else {
          profile = Profile.fromMap(responseJson);
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  getcolor(BuildContext context, bool isdriver, {driverid = 18}) async {
    final colorIndex = await Variables.read(key: "color_index");
    index = colorIndex == null ? Random().nextInt(Colors.primaries.length) : int.parse(colorIndex);
    if (isdriver) {
      await getprofile(context, "/biker/profile/$driverid");
    } else {
      await getprofile(context, "/customer/$driverid");
      if (profile != null) plan = profile.premium ? "Premium" : "Standard";
    }
    if (profile != null) {
      decorationImage =
          profile.profileUrl!.isEmpty ? null : DecorationImage(image: MemoryImage(profile.profileUrl ?? ""));
      setName(profile.name);
      fullName = profile.name;
    }
    notifyListeners();
  }

  void setName(String? fullName) {
    if (fullName != null) {
      if (fullName.contains(RegExp(r'\s'))) {
        name = fullName.indexOf(' ') == fullName.length - 1
            ? fullName[0]
            : fullName[0] + fullName[fullName.indexOf(' ') + 1];
      } else {
        name = fullName[0];
      }
    } else {
      name = "";
    }
    notifyListeners();
  }

  updateProfile(BuildContext context, Map<String, String> update, int driverId) async {
    try {
      var json = UpdateProfile.fromMap1(profile.toMap(), update).toJson();
      final response = await HTTPRequest.putRequest(Variables.uri(path: "/biker/profile/$driverId"), json);
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        Variables.showtoast(context, "Updating profile successfull", Icons.check);
        decorationImage =
            profile.profileUrl!.isEmpty ? null : DecorationImage(image: MemoryImage(profile.profileUrl ?? ""));
        if (profile.name.contains(RegExp(r'\s'))) {
          name = profile.name[0] + profile.name[profile.name.indexOf(' ') + 1];
        } else {
          name = profile.name[0];
        }
        fullName = profile.name;
        plan = profile.premium ? "Premium" : "Standard";
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    if (profile != null) await getcolor(context, true, driverid: driverId);
    notifyListeners();
  }

  getColor() async {
    final colorIndex = await Variables.read(key: "color_index");
    index = colorIndex != null ? int.parse(colorIndex) : Random().nextInt(Colors.primaries.length);
    notifyListeners();
  }

  getProfileImage({double size = 150, bool canEdit = false, bool isNotEqual = false}) {
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
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaries[index], image: decorationImage),
              child: decorationImage == null
                  ? Stack(
                      children: [
                        Center(child: Text(name, style: Variables.font(fontSize: size / 2.5, color: Colors.white))),
                        if (canEdit)
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Palette.deepgrey,
                                    border:
                                        Border.all(width: 4, color: size < 130 ? Palette.kOrange : Colors.grey[200]!)),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(Icons.edit, color: Colors.white, size: size < 130 ? 13 : 25),
                                ),
                              ))
                      ],
                    )
                  : null),
        ),
      ),
    );
  }

  void inkwell(BuildContext context) async {
    XFile? image;
    try {
      image = await ImagePicker().pickImage(source: await showoptions(context));
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
