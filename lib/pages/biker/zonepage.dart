import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ZonedPage extends StatefulWidget {
  static String routeName = "/set-zone";
  const ZonedPage({Key? key}) : super(key: key);

  @override
  ZonedPageState createState() => ZonedPageState();
}

class ZonedPageState extends State<ZonedPage> {
  int temp = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(),
      body: Column(
        children: [
          SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Zone Centers".toUpperCase(),
                    style: Variables.font(color: Palette.kOrange, fontWeight: FontWeight.bold, fontSize: 19)),
              )),
          Consumer<UpdateScreenProvider>(builder: (context, snapshot, data) {
            return Flexible(
                child: ListView.separated(
                    itemCount: Variables.centers.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            snapshot.updateScreen();
                            if (temp == -1) {
                              temp = index;
                            } else {
                              Variables.centers[temp][2] = false;
                              temp = index;
                            }
                            Variables.centers[temp][2] = true;
                          },
                          title: Text(Variables.centers[index][0], style: Variables.font(fontSize: 16)),
                          subtitle: Text(Variables.centers[index][1],
                              style: Variables.font(color: Colors.grey[600], fontSize: 15)),
                          trailing: Variables.centers[index][2]
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Palette.kOrange,
                                )
                              : null,
                        )));
          })
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text(
          "Drop",
          style: Variables.font(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
