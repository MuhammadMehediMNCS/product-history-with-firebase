import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/widget/button_widget.dart';
import 'package:my_product/widget/text_field_widget.dart';

class PurchasedProductScreen extends StatefulWidget {
  final String? productName;
  final String? productSize;
  final String? totalProduct;
  final int? index;

  const PurchasedProductScreen({
    super.key,
    this.productName,
    this.productSize,
    this.totalProduct,
    this.index
  });

  @override
  State<PurchasedProductScreen> createState() => _PurchasedProductScreenState();
}

class _PurchasedProductScreenState extends State<PurchasedProductScreen> {
  TextEditingController totalController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController orderController = TextEditingController();
  TextEditingController dueController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();

    totalController.text = widget.totalProduct ?? "0";
    newController.addListener(calculateProductValues);
    orderController.addListener(calculateProductValues);
    priceController.addListener(calculateProductValues);
  }

  @override
  void dispose() {
    newController.dispose();
    orderController.dispose();
    totalController.dispose();
    dueController.dispose();
    priceController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void calculateProductValues() {
    int newProduct = int.tryParse(newController.text) ?? 0;
    int orderProduct = int.tryParse(orderController.text) ?? 0;
    int productPrice = int.tryParse(priceController.text) ?? 0;

    int dueProduct = orderProduct - newProduct;
    int totalPrice = newProduct * productPrice;

    setState(() {
      dueController.text = dueProduct.toString();
      amountController.text = totalPrice.toString();
    });
  }

  void onConfirm() async {
    int totalProduct = int.tryParse(totalController.text) ?? 0;
    int newProduct = int.tryParse(newController.text) ?? 0;

    int updatedTotal = totalProduct + newProduct;
    if (updatedTotal < 0) {
      Get.snackbar("Error", "Sold amount cannot exceed total products.");
      return;
    }

    var updatedProduct = productController.productList[widget.index!];
    updatedProduct.total = updatedTotal;

    // Update in Firestore
    await productController.updateProductInFirestore(updatedProduct);

    // Save to Purchased_Memo in Firestore
    await productController.addPurchasedMemoToFirestore(
      productName: widget.productName ?? "No Name",
      productSize: widget.productSize ?? "No Size",
      newProduct: newProduct,
      orderProduct: int.parse(orderController.text),
      dueProduct: int.parse(dueController.text),
      price: double.tryParse(priceController.text) ?? 0,
      totalAmount: double.tryParse(amountController.text) ?? 0,
      dateTime: DateTime.now()
    );

    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading: const BackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productName ?? "No Name",
              style: const TextStyle(color: Colors.white, fontFamily: 'TiroBangla-Regular', fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6.0),
            Text(
              widget.productSize ?? "No Size",
              style: const TextStyle(color: Color(0xFFFCB2E9), fontFamily: 'TiroBangla-Regular', fontSize: 10.0, fontWeight: FontWeight.bold),
            )
          ],
        )
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
                      title: "মোট পণ্য :",
                      controller: totalController,
                      keyboard: TextInputType.number,
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 8),
                  Expanded(
                    child: TextFieldWidget(
                      title: "নতুন পণ্য :",
                      controller: newController,
                      keyboard: TextInputType.number,
                    )
                  )
                ],
              ),
              const SizedBox(height: 18.0),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      title: "অর্ডার পণ্য :",
                      controller: orderController,
                      keyboard: TextInputType.number,
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 8),
                  Expanded(
                    child: TextFieldWidget(
                      title: "বাঁকি পণ্য :",
                      controller: dueController,
                      keyboard: TextInputType.number,
                      enabled: false,
                    )
                  )
                ],
              ),
              const SizedBox(height: 18.0),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      title: "দর :",
                      controller: priceController,
                      keyboard: TextInputType.number,
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 8),
                  Expanded(
                    child: TextFieldWidget(
                      title: "টাকা :",
                      controller: amountController,
                      keyboard: TextInputType.number,
                      enabled: false,
                    )
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .2),
              ButtonWidget(
                title: 'নিশ্চিত',
                onPressed: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}