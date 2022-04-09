import 'package:ezshipp/APIs/get_customerprofile.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/textfield.dart';

class CustomerEditProfilePage extends StatefulWidget {
  static String routeName = "/cedit";
  static GlobalKey<FormState> formkey3 = GlobalKey<FormState>();
  const CustomerEditProfilePage({Key? key}) : super(key: key);

  @override
  _CustomerEditProfilePageState createState() => _CustomerEditProfilePageState();
}

class _CustomerEditProfilePageState extends State<CustomerEditProfilePage> {
  DecorationImage? decorationImage;
  String userType = "Driver";
  ValueNotifier<String> name = ValueNotifier<String>("");
  late UpdateProfileProvider updateProfileProvider;
  final email = TextEditingController(),
      firstname = TextEditingController(),
      lastname = TextEditingController(),
      phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    email.text = updateProfileProvider.profile.email;
    phone.text = updateProfileProvider.profile.phone.toString();
    if (updateProfileProvider.profile is CustomerDetails) {
      firstname.text = updateProfileProvider.profile.firstName;
      lastname.text = updateProfileProvider.profile.lastName;
    } else {
      List name = updateProfileProvider.profile.name.split(" ");
      firstname.text = name[0];
      lastname.text = name[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          child: Stack(
            children: [
              Form(
                key: CustomerEditProfilePage.formkey3,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () => updateProfileProvider.inkwell(context),
                      child: updateProfileProvider.getProfileImage(),
                    ),
                  ),
                  TextFields(
                      title: "First Name",
                      icon: const Icon(Icons.person_outline_rounded),
                      onchange: updateProfileProvider,
                      controller: firstname),
                  TextFields(
                      title: "Last Name",
                      icon: const Icon(Icons.person_outline_rounded),
                      onchange: updateProfileProvider,
                      controller: lastname),
                  TextFields(
                      title: "Email id",
                      icon: const Icon(Icons.email_rounded),
                      type: TextInputType.emailAddress,
                      controller: email),
                  TextFields(
                      title: "Phone number",
                      icon: const Icon(Icons.phone_enabled_rounded),
                      type: TextInputType.number,
                      controller: phone)
                ]),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 73) * 0.5,
                bottom: 15,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                      heroTag: "save_@",
                      onPressed: () {
                        if (CustomerEditProfilePage.formkey3.currentState!.validate()) {
                          updateProfileProvider.updateProfile(context, TextFields.data, Variables.driverId, true);
                          Navigator.of(context).pop();
                        }
                      },
                      label: Text(
                        "Save",
                        style: Variables.font(color: Colors.white),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {
      //       if (EditProfilePage.formkey3.currentState!.validate()) {
      //         updateProfileProvider.updateProfile(TextFields.data, 18);
      //         Navigator.of(context).pop();
      //       }
      //     },
      //     label: Text(
      //       "Save",
      //       style: Variables.font(color: Colors.white),
      //     )),
    );
  }

  @override
  void dispose() {
    email.dispose();
    phone.dispose();
    firstname.dispose();
    lastname.dispose();
    updateProfileProvider.dispose();
    name.dispose();
    super.dispose();
  }
}