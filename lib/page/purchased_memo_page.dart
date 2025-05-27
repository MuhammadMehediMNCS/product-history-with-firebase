import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/screen/buyer_intro_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class PurchasedMemoPage extends StatefulWidget {

  const PurchasedMemoPage({super.key});

  @override
  State<PurchasedMemoPage> createState() => _PurchasedMemoPageState();
}

class _PurchasedMemoPageState extends State<PurchasedMemoPage> {
  final ProductController productController = Get.find<ProductController>();
  
  @override
  void initState() {
    super.initState();

    productController.fetchPurchasedMemos();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading: const BackButton(color: Colors.white),
        title: const Text("ক্রয় মেমো"),
        titleTextStyle: const TextStyle(color: Colors.white, fontFamily: 'NotoSansBengali-Regular', fontSize: 18.0, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const BuyerIntroScreen());
            },
            icon: const Icon(Icons.people, color: Colors.white)
          ),
          IconButton(
            onPressed: () async {
              if (productController.purchasedMemoList.isEmpty) {
                Get.snackbar("Info", "No data to export.");
                return;
              }

              if (await Permission.storage.request().isGranted) {
                Get.snackbar("Error", "Storage permission is required to export the PDF.");
                return;
              }

              try {
                final externalDir = await getExternalStorageDirectory();
                if (externalDir == null) {
                  Get.snackbar("Error", "Unable to access storage.");
                  return;
                }

                final Directory parentFolder = Directory('${externalDir.path}/Shapahar Hardware');
                final Directory saleFolder = Directory('${parentFolder.path}/Buy');

                if (!await parentFolder.exists()) await parentFolder.create(recursive: true);
                if (!await saleFolder.exists()) await saleFolder.create(recursive: true);

                // Generate a unique file name
                String baseFileName = 'sale_memo';
                String fileExtension = '.pdf';
                String filePath = '${saleFolder.path}/$baseFileName$fileExtension';

                int fileCount = 1;
                while (await File(filePath).exists()) {
                  filePath = '${saleFolder.path}/$baseFileName($fileCount)$fileExtension';
                  fileCount++;
                }

                final file = File(filePath);

                final pdf = pw.Document();
                final fontData = await rootBundle.load("fonts/NotoSansBengali-Regular.ttf");
                final font = pw.Font.ttf(fontData.buffer.asByteData());

                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) {
                      return pw.Column(
                        children: [
                          pw.Text('বিসমিল্লাহির রাহমানির রাহিম', style: pw.TextStyle(font: font, fontSize: 10.0)),
                          pw.Text('সাপাহার হার্ডওয়ার', style: pw.TextStyle(font: font, fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
                          pw.Text('প্রোঃ মোঃ আজিজুল হাকিম', style: pw.TextStyle(font: font, fontSize: 12.0, fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                            'এখানে পিভিসি পাইপ ফিটিং, প্লাস্টিক সামগ্রী এবং ইলেকট্রিক ও\nহার্ডওয়্যার সামগ্রী খুচরা ও পাইকারী সুলভ মূল্যে পাওয়া যায়।',
                            style: pw.TextStyle(font: font, fontSize: 12.0),
                          ),
                          pw.Text('বিঃ দ্রঃ আনোয়ার সিমেন্ট সিট, বিআরবি, আরএফএল', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                          pw.Text('চৌমাশিয়া নওহাটার মোড় পেট্রোল পাম্পের দক্ষিণ পার্শ্বে, মহাদেবপুর, নওগাঁ।', style: pw.TextStyle(font: font, fontSize: 11.0, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 10.0),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('নাম : ${productController.sallerAddress.value.name ?? "................"}', style: pw.TextStyle(font: font)),
                              pw.Text('তারিখ : ${productController.sallerAddress.value.date ?? "................"}', style: pw.TextStyle(font: font)),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('ঠিকানা : ${productController.sallerAddress.value.name ?? "................"}', style: pw.TextStyle(font: font)),
                              pw.Text('মোবাইল : ${productController.sallerAddress.value.date ?? "................"}', style: pw.TextStyle(font: font)),
                            ],
                          ),
                          // ignore: deprecated_member_use
                          pw.Table.fromTextArray(
                            headers: ['পণ্যের বিবরণ', 'সাইজ', 'অর্ডার', 'নতুন', 'বাঁকি', 'টাকা'],
                            data: productController.purchasedMemoList.map((product) {
                              return [
                                product.productName,
                                product.productSize,
                                product.orderProduct,
                                product.newProduct,
                                product.dueProduct,
                                product.totalAmount
                              ];
                            }).toList(),
                            headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                            cellStyle: pw.TextStyle(font: font),
                          ),
                          pw.SizedBox(height: 44.0),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('বিক্রেতার স্বাক্ষর', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                              pw.Text('ক্রেতার স্বাক্ষর', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                            ]
                          )
                        ],
                      );
                    },
                  ),
                );

                await file.writeAsBytes(await pdf.save());

                final batch = productController.firestore.batch();
                final purchasedMemoDocs = await productController.firestore.collection('purchased-memo').get();
                for (var doc in purchasedMemoDocs.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();

                // Clear the data after saving
                productController.buyerAddress.update((val) {
                  val?.name = null;
                  val?.date = null;
                  val?.area = null;
                  val?.contact = null;
                });

                Get.snackbar("Success", "PDF exported successfully to ${file.path}");
              } catch (e) {
                Get.snackbar("Error", "Failed to export PDF: $e");
              }
            }, 
            icon: const Icon(Icons.file_download_outlined, color: Colors.white)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text('বিসমিল্লাহির রাহমানির রাহিম', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 10.0)),
            const Text('সাপাহার হার্ডওয়ার', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 18.0, fontWeight: FontWeight.bold)),
            const Text('প্রোঃ মোঃ আজিজুল হাকিম', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold)),
            const Text(
              'এখানে পিভিসি পাইপ ফিটিং, প্লাস্টিক সামগ্রী এবং ইলেকট্রিক ও\nহার্ডওয়্যার সামগ্রী খুচরা ও পাইকারী সুলভ মূল্যে পাওয়া যায়।',
              style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0),
            ),
            const Text('বিঃ দ্রঃ আনোয়ার সিমেন্ট সিট, বিআরবি, আরএফএল', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold)),
            const Text('চৌমাশিয়া নওহাটার মোড় পেট্রোল পাম্পের দক্ষিণ পার্শ্বে, মহাদেবপুর, নওগাঁ।', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 11.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            Obx(() {
              final buyerAddress = productController.buyerAddress.value;

              return Column(
                children: [
                  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .50,
                  child: Text('নাম: ${buyerAddress.name ?? "................"}', style: const TextStyle(fontFamily: 'NotoSansBengali-Regular'))
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .40,
                  child: Text('তারিখ: ${buyerAddress.date ?? "................"}', style: const TextStyle(fontFamily: 'NotoSansBengali-Regular'))
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context). size.width * .50,
                  child: Text('ঠিকানা: ${buyerAddress.area ?? "................"}', style: const TextStyle(fontFamily: 'NotoSansBengali-Regular'))
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .40,
                  child: Text('মোবাইল: ${buyerAddress.contact ?? "................"}', style: const TextStyle(fontFamily: 'NotoSansBengali-Regular'))
                ),
              ],
            ),
                ],
              );
            }),
            const SizedBox(height: 10.0),
            Container(
              color: Colors.grey,
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(child: Text('পণ্যের বিবরণ', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(child: Text('সাইজ', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('অর্ডার', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('নতুন', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('বাঁকি', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(child: Text('টাকা', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: productController.purchasedMemoList.length,
                  itemBuilder: (context, index) {
                    var buyProduct = productController.purchasedMemoList[index];
              
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(child: Text(buyProduct.productName, style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: Text(buyProduct.productSize, style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: Text(buyProduct.orderProduct.toString(), style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: Text(buyProduct.newProduct.toString(), style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: Text(buyProduct.dueProduct.toString(), style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: Text(buyProduct.totalAmount.toString(), style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                      ],
                    );
                  }
                );
              }),
            ),
            const SizedBox(height: 10.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('বিক্রেতার স্বাক্ষর', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold)),
                Text('ক্রেতার স্বাক্ষর', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10.0)
          ],
        ),
      )
    );
  }
}