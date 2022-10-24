import 'package:flutter/material.dart';

class ProfitCalculatorPage extends StatefulWidget {
  const ProfitCalculatorPage({Key? key}) : super(key: key);

  @override
  State<ProfitCalculatorPage> createState() => _ProfitCalculatorPageState();
}

class _ProfitCalculatorPageState extends State<ProfitCalculatorPage> {

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