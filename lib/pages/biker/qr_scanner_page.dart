import "dart:io";

import 'package:ezshipp/Provider/order_controller.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import "package:qr_code_scanner/qr_code_scanner.dart" as qr;

// ignore: must_be_immutable
class QRScanerPage extends StatefulWidget {
  static String routeName = "/qrscanner";
  bool flash = true;
  QRScanerPage({Key? key}) : super(key: key);

  @override
  State<QRScanerPage> createState() => _QRScanerPageState();
}

class _QRScanerPageState extends State<QRScanerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: "QR");
  qr.QRViewController? _controller;
  late OrderController orderController;

  @override
  void initState() {
    super.initState();
    orderController = Provider.of<OrderController>(context, listen: false);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Variables.app(),
        body: Stack(children: [qrViewer(size), iconButtons(size)]));
  }

  Widget qrViewer(Size size) {
    return qr.QRView(
      key: _qrKey,
      overlay: qr.QrScannerOverlayShape(
          borderRadius: 20,
          borderColor: Colors.black54,
          borderLength: (size.width * 0.7) / 2,
          cutOutSize: size.width * 0.7,
          cutOutBottomOffset: (size.height * 0.5) * 0.2),
      onQRViewCreated: (p0) {
        _controller = p0;
        _controller!.scannedDataStream.listen((event) async {
          if (event.code != null) {
            Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
            if (event.code!.length == 6) await orderController.findOrderbyBarcode(mounted, context, event.code!, 9);
            if (!mounted) return;
            await orderController.getAcceptedAndinProgressOrders(mounted, context);
            if (!mounted) return;
            Navigator.pop(context);
            Navigator.pop(context);
          }
        });
      },
    );
  }

  Widget iconButtons(Size size) {
    return Positioned(
        bottom: size.width / 2,
        left: size.width / 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer<UpdateScreenProvider>(builder: (context, snapshot, child) {
              return customContainer(
                  child: IconButton(
                onPressed: () async {
                  widget.flash = !widget.flash;
                  await _controller!.toggleFlash();
                  snapshot.updateScreen();
                },
                icon: Icon(
                  widget.flash ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded,
                  color: Colors.white,
                ),
              ));
            }),
            SizedBox(width: size.width / 3.5),
            customContainer(
                child: IconButton(
                    onPressed: () async {
                      final textRecognizer = GoogleMlKit.vision.barcodeScanner([BarcodeFormat.all]);
                      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        final inputImage = InputImage.fromFilePath(image.path);
                        final recognisedText = await textRecognizer.processImage(inputImage);
                        for (var barcode in recognisedText) {
                          debugPrint(barcode.displayValue!.toString());
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.image_rounded,
                      color: Colors.white,
                    )))
          ],
        ));
  }

  Widget customContainer({Widget? child}) {
    return Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 49, 48, 48)), child: child);
  }
}