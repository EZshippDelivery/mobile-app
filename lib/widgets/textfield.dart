import 'package:ezshipp/Provider/update_login_provider.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TextFields extends StatefulWidget {
  static Map<String, String> data = {
    "Password": "",
    "First Name": "",
    "Last Name": "",
    "Phone number": "",
    "Confirm Password": "",
    "Email id": ""
  };
  TextInputType type;
  Icon icon;
  String title;
  bool hidepass;
  double radius;
  UpdateProfileProvider? onchange;
  bool verify;
  TextEditingController? controller;
  TextFields(
      {Key? key,
      required this.title,
      required this.icon,
      this.type = TextInputType.name,
      this.hidepass = false,
      this.radius = 8,
      this.onchange,
      this.verify = false,
      this.controller})
      : super(key: key);

  @override
  _TextFieldsState createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  bool hidepass2 = true;

  bool verifyPhone = false;

  late UpdateLoginProvider updateLoginProvider;

  @override
  void initState() {
    super.initState();
    updateLoginProvider = Provider.of<UpdateLoginProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    if (widget.title == "Username") {
      title = "Phone number";
    } else if (widget.title == "New Password") {
      title = "Password";
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: widget.controller,
          obscureText: widget.hidepass && hidepass2,
          keyboardType: widget.type,
          onChanged: (value) {
            TextFields.data[title] = value;
            if (TextFields.data["First Name"]!.isNotEmpty &&
                TextFields.data["Last Name"]!.isNotEmpty &&
                widget.onchange != null) {
              widget.onchange!
                  .setName((TextFields.data["First Name"]![0] + TextFields.data["Last Name"]![0]).toUpperCase());
            } else if (TextFields.data["First Name"]!.isNotEmpty && widget.onchange != null) {
              widget.onchange!.setName((TextFields.data["First Name"]![0]).toUpperCase());
            }
          },
          validator: (value) {
            String title = widget.title;
            if (value!.isEmpty) {
              if (title == "Confirm Password") {
                return title;
              }
              return "Enter $title";
            } else {
              switch (title) {
                case "First Name":
                case "Last Name":
                  if (value.length <= 3 || value.length > 16) {
                    return "Full name should be in range of 3 to 16 character ";
                  }
                  break;
                case "New Password":
                case "Password":
                  if (value.length > 6 && value.length < 16) {
                    if (value.contains(RegExp(r"\s"))) {
                      return "Password should not contain whitespaces";
                    } else if (!value.contains(RegExp(r"[a-z]")) ||
                        !value.contains(RegExp(r"[A-Z]")) ||
                        !value.contains(RegExp(r"[0-9]")) ||
                        !value.contains(RegExp(r"\W"))) {
                      var temp = MediaQuery.of(context).size.width < 600.0 ? "\n\t" : "";
                      return "Password should contain Lower Alphabet, Upper Alphabet,$temp number and special character";
                    } else if (!value.contains(RegExp(r"\w"))) {
                      var temp = MediaQuery.of(context).size.width < 600.0 ? "\n\t" : "";
                      return "Password should contain Lower Alphabet, Upper Alphabet,$temp number and special character";
                    }
                  } else {
                    return "Password should be in range of 6 to 16 character ";
                  }
                  break;
                case "Confirm Password":
                  if (TextFields.data['Password'] != value || value.isEmpty) {
                    return "Password isn't matched";
                  }
                  break;
                case "Email id":
                  if (value.contains(RegExp(r"\s")) || !value.contains(RegExp("@"))) {
                    return "Enter valid Email id";
                  }
                  break;
                case "Username":
                case "Phone number":
                  if (value.length != 10) {
                    return "Enter valid Phone number";
                  }
                  break;
              }
            }
            return null;
          },
          decoration: InputDecoration(
              prefixIcon: Icon(widget.icon.icon),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(widget.radius * 3)),
              contentPadding: const EdgeInsets.all(5),
              suffixIcon: widget.hidepass
                  ? IconButton(
                      icon: hidepass2 ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                      onPressed: () => setState(() => hidepass2 = !hidepass2))
                  : null,
              labelText: widget.title,
              hintText: widget.title != title
                  ? "Enter $title"
                  : title == "Confirm Password"
                      ? title
                      : "Enter ${widget.title}")),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
