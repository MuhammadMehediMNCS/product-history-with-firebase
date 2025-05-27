import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_product/page/home_page.dart';
import 'package:my_product/widget/button_widget.dart';
import 'package:my_product/widget/text_field_widget.dart';

class ForgotOtpPage extends StatefulWidget {
  final String phoneNumber;

  const ForgotOtpPage({super.key, required this.phoneNumber});

  @override
  State<ForgotOtpPage> createState() => _ForgotOtpPageState();
}

class _ForgotOtpPageState extends State<ForgotOtpPage> {
  TextEditingController otpController = TextEditingController();
  TextEditingController newPinController = TextEditingController();

  String? _verificationId;
  bool isOtpVerified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sendOtp();
  }

  void sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          isOtpVerified = true;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('ত্রুটি', e.message ?? 'ওটিপি পাঠাতে সমস্যা হয়েছে',
          backgroundColor: Colors.pink,
          colorText: Colors.white);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> verifyOtpAndProceed() async {
    String otp = otpController.text.trim();
    if (_verificationId == null || otp.isEmpty) {
      Get.snackbar('ত্রুটি', 'ওটিপি সঠিকভাবে লিখুন',
        backgroundColor: Colors.pink,
        colorText: Colors.white);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        isOtpVerified = true;
      });
    } catch (e) {
      Get.snackbar('ত্রুটি', 'ওটিপি ভুল হয়েছে',
        backgroundColor: Colors.pink,
        colorText: Colors.white);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveNewPin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String newPin = newPinController.text.trim();
      if (newPin.isEmpty) {
        Get.snackbar('ত্রুটি', 'নতুন পিন লিখুন',
          backgroundColor: Colors.pink,
          colorText: Colors.white);
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'pin': newPin}, SetOptions(merge: true));

      Get.snackbar('সফল', 'নতুন পিন সংরক্ষিত হয়েছে',
        backgroundColor: Colors.pink,
        colorText: Colors.white);

      Get.offAll(HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(color: Colors.white),
        title: Text('পাসওয়ার্ড পুনরুদ্ধার করুন'),
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
              'ওটিপি ভেরিফিকেশন',
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
            if (isOtpVerified)
              SizedBox(
                width: MediaQuery.of(context).size.width * .50,
                child: TextFieldWidget(
                  title: 'নতুন পিন',
                  controller: newPinController,
                  keyboard: TextInputType.number,
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height * .10),
            ButtonWidget(
              title: isOtpVerified ? 'নিশ্চিত' : 'পরবর্তী',
              onPressed: isOtpVerified ? saveNewPin : verifyOtpAndProceed,
            )
          ],
        ),
      ),
    );
  }
}