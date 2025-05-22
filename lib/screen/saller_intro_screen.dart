import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/model/saller_address.dart';
import 'package:my_product/widget/button_widget.dart';
import 'package:my_product/widget/text_field_widget.dart';

class SallerIntroScreen extends StatefulWidget {
  const SallerIntroScreen({super.key});

  @override
  State<SallerIntroScreen> createState() => _SallerIntroScreenState();
}

class _SallerIntroScreenState extends State<SallerIntroScreen> {
  final ProductController productController = Get.find<ProductController>();
  
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
void initState() {
  super.initState();
  
  dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading: const BackButton(color: Colors.white),
        title: const Text('বিক্রেতার তথ্য'),
        titleTextStyle: const TextStyle(color: Colors.white, fontFamily: 'NotoSansBengali-Regular', fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      title: "নাম :",
                      controller: nameController,
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 8),
                  Expanded(
                    child: TextFieldWidget(
                      title: "তারিখ :",
                      controller: dateController,
                    )
                  )
                ],
              ),
              const SizedBox(height: 18.0),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      title: "ঠিকানা :",
                      controller: areaController
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 8),
                  Expanded(
                    child: TextFieldWidget(
                      title: "মোবাইল :",
                      controller: phoneController,
                      keyboard: TextInputType.phone,
                    )
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .2),
              ButtonWidget(
                title: 'নিশ্চিত',
                onPressed: () {
                  SallerAddress address = SallerAddress(
                    name: nameController.text,
                    date: dateController.text,
                    area: areaController.text,
                    contact: phoneController.text
                  );

                  productController.addSallerAddress(address);

                  Get.back();
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}