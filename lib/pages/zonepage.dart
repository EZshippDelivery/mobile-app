import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';

class ZonedPage extends StatefulWidget {
  const ZonedPage({Key? key}) : super(key: key);

  @override
  _ZonedPageState createState() => _ZonedPageState();
}

class _ZonedPageState extends State<ZonedPage> {
  int temp = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(),
      body: Column(
        children: [
          SizedBox(height: 50, child: Text("Zone Centers", style: Variables.font(fontSize: 18))),
          Flexible(
              child: ListView.separated(
                  itemCount: Variables.centers.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          setState(() {
                            if (temp == -1) {
                              temp = index;
                            } else {
                              Variables.centers[temp][2] = false;
                              temp = index;
                            }
                            Variables.centers[temp][2] = true;
                          });
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
                      )))
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
