import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';

class ConfirmAddressPage extends StatefulWidget {
  const ConfirmAddressPage({ Key? key }) : super(key: key);

  @override
  _ConfirmAddressPageState createState() => _ConfirmAddressPageState();
}

class _ConfirmAddressPageState extends State<ConfirmAddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: Variables.app());
  }
}