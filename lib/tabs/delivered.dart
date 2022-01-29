import 'package:ezshipp/pages/orderpage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Provider/update_order_povider.dart';

class Delivered extends StatefulWidget {
  const Delivered({Key? key}) : super(key: key);

  @override
  State<Delivered> createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  ScrollController scrollController = ScrollController();
  late UpdateOrderProvider updateOrderProvider;
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    updateOrderProvider = Provider.of<UpdateOrderProvider>(context, listen: false);
    updateOrderProvider.delivered(
        18, pageNumber, updateOrderProvider.start.toString(), updateOrderProvider.end.toString());
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (!updateOrderProvider.islastpageloaded) {
          pageNumber += 1;
          updateOrderProvider.delivered(
              18, pageNumber, updateOrderProvider.start.toString(), updateOrderProvider.end.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateOrderProvider>(builder: (context, reference, child) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("From:", style: Variables.font(fontSize: 16)),
              ElevatedButton(
                  onPressed: () => showDatePicker(
                          context: context,
                          initialDate: reference.start,
                          firstDate: DateTime(2017),
                          lastDate: DateTime.now().subtract(const Duration(days: 1)))
                      .then((value) => reference.setTime(value, false, pageNumber)),
                  child: Text(
                    DateFormat("dd/MM/yyyy").format(reference.start),
                  )),
              Text("Until:", style: Variables.font(fontSize: 16)),
              ElevatedButton(
                  onPressed: () => showDatePicker(
                          context: context,
                          initialDate: reference.end,
                          firstDate: DateTime(2017),
                          lastDate: DateTime.now())
                      .then((value) => reference.setTime(value, false, pageNumber)),
                  child: Text(
                    DateFormat("dd/MM/yyyy").format(reference.end),
                  ))
            ],
          ),
          if (reference.deliveredList.isEmpty)
            Expanded(
                child: Center(
              child: SizedBox.fromSize(
                size: Size.square(MediaQuery.of(context).size.width * 0.5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "In range of your dates, there is no orders that are delivered",
                    style: Variables.font(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )),
          if (reference.deliveredList.isNotEmpty)
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemCount: reference.deliveredList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        tileColor: Colors.white,
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Order(index: index))),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Variables.text(head: "Order ID: ", value: reference.deliveredList[index].orderSeqId),
                            Text(Variables.datetime(reference.deliveredList[index].acceptedTime.isEmpty
                                ? reference.deliveredList[index].orderCreatedTime
                                : reference.deliveredList[index].acceptedTime))
                          ],
                        ),
                        subtitle: Variables.text(
                            head: "Status: ",
                            value: reference.deliveredList[index].status,
                            valueColor: Palette.kOrange),
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}
