import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/model/products.dart';
import 'package:my_product/widget/button_widget.dart';
import 'package:my_product/widget/text_field_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productName = TextEditingController();
  TextEditingController totalProduct = TextEditingController();
  TextEditingController productSize = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading: const BackButton(color: Colors.white),
        title: const Text('নতুন পণ্য'),
        titleTextStyle: const TextStyle(color: Colors.white, fontFamily: 'NotoSansBengali-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFieldWidget(
                      title: 'পণ্যের নাম :',
                      controller: productName
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .2),
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                      title: 'মোট পণ্য :',
                      controller: totalProduct,
                      keyboard: TextInputType.number,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      title: 'পণ্যের সাইজ :',
                      controller: productSize
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .2),
                  Expanded(
                    child: TextFieldWidget(
                      title: 'ক্রয় মূল্য',
                      controller: productPrice,
                      keyboard: TextInputType.number,
                    )
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .2),
              ButtonWidget(
                title: 'নিশ্চিত করুন',
                onPressed: () {
                  final name = productName.text.trim();
                  final total = totalProduct.text.trim();
                  final size = productSize.text.trim();
                  final price = productPrice.text.trim();

                  if (name.isNotEmpty && total.isNotEmpty && size.isNotEmpty && price.isNotEmpty) {
                    final product = Products(name: name, total: int.parse(total), size: size, price: int.parse(price));
                    productController.addProductToFirestore(product).then((_) {
                      Get.snackbar('সাফল্য', 'পণ্য সংরক্ষণ করা হয়েছে', backgroundColor: Colors.green, colorText: Colors.white);
                      Get.back();
                    });
                  } else {
                    Get.snackbar('ত্রুটি', 'সবগুলো ঘর পূরণ করুন', backgroundColor: Colors.red, colorText: Colors.white);
                  }
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