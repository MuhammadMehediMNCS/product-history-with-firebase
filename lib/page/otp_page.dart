import 'package:flutter/material.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

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
              'একাউন্ট ভেরিফিকেশন',
              style: TextStyle(color: Colors.pink, fontFamily: 'NotoSansBengali-Regular', fontSize: 38.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .10),
            Text('এখানে ভেরিফিকেশন কোডটি লিখুন'),

          ],
        ),
      ),
    );
  }
}