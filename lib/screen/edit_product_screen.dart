import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/model/products.dart';
import 'package:my_product/widget/button_widget.dart';
import 'package:my_product/widget/text_field_widget.dart';


class EditProductScreen extends StatefulWidget {
  final Products product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController totalController;
  late TextEditingController sizeController;
  late TextEditingController priceConroller;

  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    totalController = TextEditingController(text: widget.product.total.toString());
    sizeController = TextEditingController(text: widget.product.size);
    priceConroller = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    totalController.dispose();
    sizeController.dispose();
    priceConroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const BackButton(color: Colors.white),
        title: const Text('এডিট করুন'),
        titleTextStyle: const TextStyle(color: Colors.white, fontFamily: 'NotoSansBengali-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
        actions: [
          IconButton(
            onPressed: () async {
              final confirm = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('আপনি কি নিশ্চিত?'),
                  titleTextStyle: TextStyle(color: Colors.pink),
                  content: const Text('এই পণ্যটি মুছে ফেলতে চান?'),
                  contentTextStyle: TextStyle(color: Colors.pink),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('না', style: TextStyle(color: Colors.pink)),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text('হ্যাঁ', style: TextStyle(color: Colors.pink)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await productController.deleteProductFromFirestore(widget.product.docId!);
                productController.productList.refresh();
                Get.back();
                Get.snackbar('সফল', 'পণ্যটি মুছে ফেলা হয়েছে',
                  backgroundColor: Colors.pink,
                  colorText: Colors.white
                );
              }
            },
            icon: Icon(Icons.delete_rounded, color: Colors.white, size: 28.0,)
          ),
          const SizedBox(width: 12.0,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFieldWidget(
                      title: 'পণ্যের নাম :',
                      controller: nameController,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .1),
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                      title: 'মোট পণ্য :',
                      controller: totalController,
                      enabled: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      title: 'পণ্যের সাইজ :',
                      controller: sizeController,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .2),
                  Expanded(
                    child: TextFieldWidget(
                      title: 'ক্রয় মূল্য', 
                      controller: priceConroller,
                      keyboard: TextInputType.number,
                    )
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .2),
              ButtonWidget(
                title: 'নিশ্চিত',
                onPressed: () async {
                  widget.product.name = nameController.text;
                  widget.product.total = int.parse(totalController.text);
                  widget.product.size = sizeController.text;
                  widget.product.price = int.parse(priceConroller.text);

                  await productController.updateProductInFirestore(widget.product);

                  productController.productList.refresh();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}