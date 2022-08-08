import 'package:ezshipp/Provider/auth_controller.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController? controller;
  ValueNotifier<bool>? valueNotifier = ValueNotifier<bool>(false);
  TextFields(
      {Key? key,
      required this.title,
      required this.icon,
      this.type = TextInputType.name,
      this.hidepass = false,
      this.radius = 8,
      this.onchange,
      this.controller,
      this.valueNotifier})
      : super(key: key);

  @override
  TextFieldsState createState() => TextFieldsState();
}

class TextFieldsState extends State<TextFields> {
  bool hidepass2 = true;

  bool verifyPhone = false;

  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Provider.of<AuthController>(context, listen: false);
    if (widget.title == "Username") {
      widget.controller!.addListener(() {
        widget.valueNotifier!.value =
            widget.controller!.text.contains(RegExp(r'\d')) && !widget.controller!.text.contains(RegExp(r'[a-zA-Z]'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    if (widget.title == "Username") {
      title = "Email id";
    } else if (widget.title == "New Password") {
      title = "Password";
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: widget.controller,
          inputFormatters: [FilteringTextInputFormatter(RegExp(r'[\S]'), allow: true)],
          obscureText: widget.hidepass && hidepass2,
          keyboardType: widget.type,
          onChanged: (value) {
            TextFields.data[title] = value;
            if (TextFields.data["First Name"]!.isNotEmpty &&
                TextFields.data["Last Name"]!.isNotEmpty &&
                widget.onchange != null) {
              widget.onchange!
                  .setName(("${TextFields.data["First Name"]!} ${TextFields.data["Last Name"]!}").toUpperCase());
            } else if (TextFields.data["First Name"]!.isNotEmpty && widget.onchange != null) {
              widget.onchange!.setName(TextFields.data["First Name"]!.toUpperCase());
            } else if (widget.onchange != null) {
              widget.onchange!.setName(null);
            }
          },
          validator: (value) {
            String title = widget.title;
            if (value!.isEmpty) {
              if (title == "Confirm Password") {
                return title;
              }
              return "Please enter $title";
            } else {
              switch (title) {
                case "First Name":
                case "Last Name":
                  if (value.length < 3 || value.length > 16) {
                    return "$title should be in range of 3 to 16 character ";
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
                    return "Password should be in range of 7 to 16 character ";
                  }
                  break;
                case "Confirm Password":
                  if (TextFields.data['Password'] != value || value.isEmpty) {
                    return "Password isn't matched";
                  }
                  break;
                // case "Username":
                case "Email id":
                  if (value.contains(RegExp(r"\s")) ||
                      !value.contains(RegExp("@")) ||
                      !value.contains(RegExp(r".+@.+\..+"))) {
                    return "Enter valid Email id";
                  }
                  break;
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
}
