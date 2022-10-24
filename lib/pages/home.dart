import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:test_bayer/pages/buyer.dart';
import 'package:test_bayer/pages/forecast.dart';
import 'package:test_bayer/pages/profitCalculator.dart';

int page = 0;
final List<Widget> pagesList = [
  const ForecastPage(),
  const BuyerPage(),
  const ProfitCalculatorPage()
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool isMenuOpened = false;

  @override
  void initState(){

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Bayer"),
      ),
      body: pagesList[page],
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionBubble(
          backGroundColor: Colors.blue,
          iconColor: Colors.white,
            iconData: isMenuOpened?Icons.close:Icons.menu,
          onPress: (){
            if(isMenuOpened){
              _animationController.reverse();
              setState((){
                isMenuOpened = false;
              });
              return;
            }
            _animationController.forward();
            setState((){
              isMenuOpened = true;
            });
          },
            animation: _animation,
          items: [
            Bubble(
              title:"พยากรณ์อากาศ",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.sunny_snowing,
              titleStyle: const TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
                setState((){
                  page = 0;
                  isMenuOpened = false;
                });
              },
            ),
            Bubble(
              title:"ราคาผลผลิต",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.currency_exchange,
              titleStyle: const TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
                setState((){
                  page = 1;
                  isMenuOpened = false;
                });
              },
            ),
            Bubble(
              title:"คำนวณผลกำไร",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.calculate_outlined,
              titleStyle: const TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
                setState((){
                  page = 2;
                  isMenuOpened = false;
                });
              },
            ),
          ]
        )
    );
  }
}