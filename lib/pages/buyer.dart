import 'package:flutter/material.dart';

class BuyerPage extends StatefulWidget {
  const BuyerPage({Key? key}) : super(key: key);

  @override
  State<BuyerPage> createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text("หน้านี้ยังไม่พร้อมใช้งาน อยู่ในระหว่างการพัฒนา", textAlign: TextAlign.center),
            ),
          ),
        )
    );
  }
}