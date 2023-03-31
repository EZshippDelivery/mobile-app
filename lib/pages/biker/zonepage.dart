import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/biker/qr_scanner_page.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ZonedPage extends StatefulWidget {
  static String routeName = "/set-zone";
  int id = 0;
  ZonedPage(this.id, {Key? key}) : super(key: key);

  @override
  ZonedPageState createState() => ZonedPageState();
}

class ZonedPageState extends State<ZonedPage> {
  int temp = -1;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Variables.centers.map((e) => e[2] = false).toList();
  }

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
                            if (temp == -1) {
                              temp = index;
                            } else {
                              Variables.centers[temp][2] = false;
                              temp = index;
                            }
                            Variables.centers[temp][2] = true;
                            snapshot.updateScreen();
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
        onPressed: () async {
          // Variables.updateOrderMap.barcode = await Variables.scantext(context, controller);
          // Variables.updateOrderMap.zoneId = temp + 1;
          // if (!mounted) return;
          // Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
          // await Variables.updateOrder(mounted, context, widget.id, 8);
          // Variables.updateOrderMap.barcode = "";
          // Variables.updateOrderMap.zoneId = 0;
          // if (!mounted) return;
          // Variables.pop(context);
          // Variables.pop(context);
          QRScanerPage.zoned = false;
          Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanerPage(id: widget.id, zonedId: temp)));
        },
        child: Text(
          "Drop",
          style: Variables.font(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
