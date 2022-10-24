import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:test_bayer/pages/forecast.dart';

int page = 0;
final List<Widget> pagesList = [
  const ForecastPage()
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PanelController panelController = PanelController();

  Widget getPanel(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
          child: MaterialButton(
            height: 45,
            minWidth: MediaQuery.of(context).size.width*0.8,
            textColor: Colors.white,
            color: Colors.blue,
            child: const Text("เปิด/ปิดเมนู"),
              onPressed: (){
                if(!panelController.isAttached){return;}
                if(panelController.isPanelClosed){
                  setState((){
                    panelController.open();
                  });
                  return;
                }
                setState((){
                  panelController.close();
                });
              }
          ),
        ),
        Expanded(child: SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: []
        )))
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Bayer"),
      ),
      body: SafeArea(
        child: SlidingUpPanel(
          controller: panelController,
          minHeight: 65,
          maxHeight: MediaQuery.of(context).size.height*0.8,
          panel: getPanel(),
          body: pagesList[page]
        )
      )
    );
  }
}