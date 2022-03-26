import 'package:ezshipp/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/update_order_povider.dart';
import '../pages/orderpage.dart';
import '../utils/variables.dart';

class Accepted extends StatefulWidget {
  const Accepted({Key? key}) : super(key: key);

  @override
  _AcceptedState createState() => _AcceptedState();
}

class _AcceptedState extends State<Accepted> {
  ScrollController scrollController = ScrollController();
  late UpdateOrderProvider updateOrderProvider;
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    updateOrderProvider = Provider.of<UpdateOrderProvider>(context, listen: false);

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (!updateOrderProvider.islastpageloaded1) {
          pageNumber += 1;
          updateOrderProvider.accepted(context, pageNumber, false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateOrderProvider>(builder: (context, reference, child) {
      return Column(
        children: [
          if (reference.acceptedList.isEmpty)
            Expanded(
                child: Center(
              child: SizedBox.fromSize(
                size: Size.square(MediaQuery.of(context).size.width * 0.5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "There is no new orders that are accepted",
                    style: Variables.font(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )),
          if (reference.acceptedList.isNotEmpty)
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemCount: reference.acceptedList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        tileColor: Colors.white,
                        onTap: () {
                          Variables.index1 = index;
                          Variables.push(context,"/${reference.acceptedList[index].id}/true" +Order.routeName);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Variables.text(head: "Order ID: ", value: reference.acceptedList[index].orderSeqId),
                            Text(Variables.datetime(reference.acceptedList[index].acceptedTime.isEmpty
                                ? reference.acceptedList[index].orderCreatedTime
                                : reference.acceptedList[index].acceptedTime))
                          ],
                        ),
                        subtitle: Variables.text(
                            head: "Status: ", value: reference.acceptedList[index].status, valueColor: Palette.kOrange),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
