import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_product/page/calculator_page.dart';
import 'package:my_product/page/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedindex = 0;

  final List<Widget> pages = [
    const ProductPage(),
    const CalculatorPage()
  ];

  DateTime? doublePressed;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backHandeler = doublePressed == null || currentTime.difference(doublePressed!) > const Duration(seconds: 3);

    if (backHandeler) {
      doublePressed = currentTime;
      Fluttertoast.showToast(
        msg: "Double press back to leave the app.",
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER
      );

      return false;
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: pages[selectedindex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedindex,
          onTap: (index) {
            setState(() {
              selectedindex = index;
            });
          },
          backgroundColor: Colors.pink,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: const IconThemeData(color: Colors.white),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          items: [
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  selectedindex == 0 ? Colors.white : Colors.grey,
                  BlendMode.srcIn,
                ),
                child: Image.asset('images/product.png', height: 24.0, width: 24.0),
              ),
              label: 'পণ্যের তথ্য',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  selectedindex == 1 ? Colors.white : Colors.grey,
                  BlendMode.srcIn,
                ),
                child: Image.asset('images/calculator.png', height: 24.0, width: 24.0),
              ),
              label: 'ক্যালকুলেটর',
            ),
          ],
        ),
      ),
    );
  }
}