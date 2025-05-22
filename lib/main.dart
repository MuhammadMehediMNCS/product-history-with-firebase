import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/firebase_options.dart';
import 'package:my_product/page/calculator_page.dart';
import 'package:my_product/page/otp_page.dart';
import 'package:my_product/page/product_page.dart';
import 'package:my_product/widget/button_widget.dart';
import 'package:my_product/widget/text_field_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  Get.put(ProductController());
  await GetStorage.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.pink),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width * 0.20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.pink,
                    width: 4.0
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'images/hand_shake.png',
                    color: Colors.pink,
                  ),
                ),
              )
            ),
            Text(
              'আপনার প্রতিষ্ঠানের পণ্যগুলোর তথ্য',
              style: TextStyle(fontFamily: 'NotoSansBengali-Regular', color: Colors.pink, fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'দেখুন ও ক্রয়-বিক্রয় করুন।',
              style: TextStyle(fontFamily: 'NotoSansBengali-Regular', color: Colors.pink, fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .10),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'একাউন্ট নাম্বার',
                style: const TextStyle(color: Colors.pink, fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold),
              ),
            ),
            IntlPhoneField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.pink)
                ),
              ),
              initialCountryCode: 'BD', // You can set 'IN', 'US', etc. as needed
              onChanged: (phone) {
              print(phone.completeNumber); // Full number with country code
              phoneController.text = phone.completeNumber; // Store it if needed
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: () {
                  Get.to(OtpPage());
                },
                child: RichText(
                  text: TextSpan(
                    text: 'পিন ভুলে গিয়েছেন?',
                    style: TextStyle(color: Colors.pink, fontSize: 18.0)
                  )
                ),
              ),
            ),
            TextFieldWidget(
              title: 'পিন নাম্বার',
              controller: passwordController,
              keyboard: TextInputType.number,
            ),
            SizedBox(height: 48.0),
            ButtonWidget(
              title: 'পরবর্তী',
              onPressed: () {}
            )
          ],
        ),
      ),
    );
  }
}

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