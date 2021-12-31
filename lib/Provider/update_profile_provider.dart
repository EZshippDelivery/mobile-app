import 'dart:io';
import 'dart:math';

import 'package:ezshipp/APIs/profile.dart';
import 'package:ezshipp/APIs/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs/get_customerprofile.dart';
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

  getprofile(String path) async {
    try {
      final response = await get(Variables.uri(path: path));
      var responseJson = Variables.returnResponse(response);
      if (responseJson != null) {
        if (path.contains("customer")) {
          profile = CustomerDetails.fromMap(responseJson);
        } else {
          profile = Profile.fromMap(responseJson);
        }
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  getcolor(bool isdriver, {driverid = 18}) async {
    var pref = await SharedPreferences.getInstance();
    index = pref.getInt("color_index") ?? Random().nextInt(Colors.primaries.length);
    if (isdriver) {
      await getprofile("/biker/profile/$driverid");
    } else {
      await getprofile("/customer/$driverid");
      if (profile != null) plan = profile.premium ? "Premium" : "Standard";
    }
    if (profile != null) {
      decorationImage =
          profile.profileUrl!.isEmpty ? null : DecorationImage(image: NetworkImage(profile.profileUrl ?? ""));
      setName(profile.name);
      fullName = profile.name;
    }
    notifyListeners();
  }

  void setName(String fullName) {
    if (fullName.contains(RegExp(r'\s'))) {
      name = fullName[0] + profile.name[fullName.indexOf(' ') + 1];
    } else {
      name = fullName[0];
    }
    notifyListeners();
  }

  updateProfile(Map<String, String> update, int driverId) async {
    try {
      var json = UpdateProfile.fromMap1(profile.toMap(), update).toJson();
      final response =
          await put(Variables.uri(path: "/biker/profile/$driverId"), body: json, headers: Variables.headers);
      var responseJson = Variables.returnResponse(response);
      if (responseJson != null) {
        Variables.showtoast("Updating profile successfull");
        decorationImage =
            profile.profileUrl!.isEmpty ? null : DecorationImage(image: NetworkImage(profile.profileUrl ?? ""));
        if (profile.name.contains(RegExp(r'\s'))) {
          name = profile.name[0] + profile.name[profile.name.indexOf(' ') + 1];
        } else {
          name = profile.name[0];
        }
        fullName = profile.name;
        plan = profile.premium ? "Premium" : "Standard";
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    if (profile != null) await getcolor(true, driverid: driverId);
    notifyListeners();
  }

  getColor() async {
    index = (await SharedPreferences.getInstance()).getInt("color_index") ?? Random().nextInt(Colors.primaries.length);
    notifyListeners();
  }

  getProfileImage({double size = 150, bool canEdit = false}) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaries[index], image: decorationImage),
        child: decorationImage == null
            ? Stack(
                children: [
                  Center(child: Text(name, style: const TextStyle(fontSize: 65, color: Colors.white))),
                  if (canEdit)
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Palette.deepgrey,
                              border: Border.all(width: 4, color: size == 100 ? Palette.kOrange : Colors.grey[200]!)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(Icons.edit, color: Colors.white, size: size == 100 ? 13 : 25),
                          ),
                        ))
                ],
              )
            : null);
  }

  void inkwell(BuildContext context) async {
    XFile? image;
    try {
      image = await ImagePicker().pickImage(source: await showoptions(context));
    } catch (e) {
      Variables.showtoast("removed profile image");
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
