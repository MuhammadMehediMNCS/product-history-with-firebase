import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/firebase_options.dart';
import 'package:my_product/page/forgot_otp_page.dart';
import 'package:my_product/page/home_page.dart';
import 'package:my_product/page/phone_verify_otp_page.dart';
import 'package:my_product/widget/button_widget.dart';
import 'package:my_product/widget/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              initialCountryCode: 'BD',
              onChanged: (phone) {
              phoneController.text = phone.completeNumber; // Store it if needed
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: () {
                  String phoneNumber = phoneController.text.trim();

                  if (phoneNumber.isEmpty) {
                    Get.snackbar(
                      'ত্রুটি', 'একাউন্ট নাম্বার ঘরটি পূরণ করুন',
                      backgroundColor: Colors.pink,
                      colorText: Colors.white
                    );
                  } else {
                    Get.to(ForgotOtpPage(phoneNumber: phoneNumber));
                  }
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
              isPassword: true,
            ),
            SizedBox(height: 48.0),
            ButtonWidget(
              title: 'পরবর্তী',
              onPressed: () async {
                String phoneNumber = phoneController.text.trim();
                String pin = passwordController.text.trim();

                if (phoneNumber.isEmpty || pin.isEmpty) {
                  Get.snackbar(
                    'ত্রুটি', 'ফোন নাম্বার ও পিন দিন',
                    backgroundColor: Colors.pink,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Check if user already exists with this phone number
                final QuerySnapshot snapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('phone', isEqualTo: phoneNumber)
                    .get();

                if (snapshot.docs.isNotEmpty) {
                  final storedPin = snapshot.docs.first['pin'];

                  if (storedPin == pin) {
                    Get.to(HomePage());
                  } else {
                    Get.snackbar(
                      'ভুল পিন', 'সঠিক পিন দিন',
                      backgroundColor: Colors.pink,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  // New user, go through phone verification
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phoneNumber,
                    verificationCompleted: (PhoneAuthCredential credential) async {
                      await FirebaseAuth.instance.signInWithCredential(credential);
                      await savePIN(pin);
                      Get.to(HomePage());
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      Get.snackbar(
                        'ভুল', e.message ?? 'অজানা ত্রুটি',
                        backgroundColor: Colors.pink,
                        colorText: Colors.white,
                      );
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      Get.to(() => PhoneVerifyOtpPage(
                        verificationId: verificationId,
                        pin: pin,
                      ));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                }
              }
            )
          ],
        ),
      ),
    );
  }

  Future<void> savePIN(String pin) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'phone': user.phoneNumber,
          'pin': pin,
        }, SetOptions(merge: true));
    }
  }
}