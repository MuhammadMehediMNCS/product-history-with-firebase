import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_product/page/home_page.dart';
import 'package:my_product/widget/button_widget.dart';
import 'package:my_product/widget/text_field_widget.dart';

class PhoneVerifyOtpPage extends StatefulWidget {
  final String verificationId;
  final String pin;

  const PhoneVerifyOtpPage({super.key, required this.verificationId, required this.pin});

  @override
  State<PhoneVerifyOtpPage> createState() => _PhoneVerifyOtpPageState();
}

class _PhoneVerifyOtpPageState extends State<PhoneVerifyOtpPage> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(color: Colors.white),
        title: Text('নাম্বার যাচাই চলছে'),
        titleTextStyle: const TextStyle(color: Colors.white, fontFamily: 'NotoSansBengali-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'images/password.png',
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .25,
                color: Colors.pink,
              ),
            ),
            Text(
              'একাউন্ট ভেরিফিকেশন',
              style: TextStyle(color: Colors.pink, fontFamily: 'NotoSansBengali-Regular', fontSize: 38.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'ভেরিফিকেশন কোডটি লিখুন',
              style: TextStyle(color: Colors.pink, fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.w700),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .10),
            SizedBox(
              width: MediaQuery.of(context).size.width * .50,
              child: TextFieldWidget(
                title: 'ওটিপি কোড',
                controller: otpController,
                keyboard: TextInputType.number,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .10),
            ButtonWidget(
              title: 'নিশ্চিত',
              onPressed: () async {
                final smsCode = otpController.text.trim();

                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: smsCode,
                );

                try {
                  // ignore: unused_local_variable
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                  await savePIN(widget.pin);
                  Get.offAll(() => HomePage());
                } catch (e) {
                  Get.snackbar('ত্রুটি', 'ওটিপি ভুল হয়েছে');
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