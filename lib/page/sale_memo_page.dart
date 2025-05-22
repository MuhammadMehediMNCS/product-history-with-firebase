import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/screen/saller_intro_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class SaleMemoPage extends StatefulWidget {

  const SaleMemoPage({super.key});

  @override
  State<SaleMemoPage> createState() => _SaleMemoPageState();
}

class _SaleMemoPageState extends State<SaleMemoPage> {
  final ProductController controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();

    controller.fetchSaleMemos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading: const BackButton(color: Colors.white),
        title: const Text("বিক্রয় মেমো"),
        titleTextStyle: const TextStyle(color: Colors.white, fontFamily: 'NotoSansBengali-Regular', fontSize: 18.0, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const SallerIntroScreen());
            },
            icon: const Icon(Icons.person, color: Colors.white)
          ),
          IconButton(
            onPressed: () async {
              if (controller.saleMemoList.isEmpty) {
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
                final Directory saleFolder = Directory('${parentFolder.path}/Sale');

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
                              pw.Text('নাম : ${controller.sallerAddress.value.name ?? "................"}', style: pw.TextStyle(font: font)),
                              pw.Text('তারিখ : ${controller.sallerAddress.value.date ?? "................"}', style: pw.TextStyle(font: font)),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('ঠিকানা : ${controller.sallerAddress.value.name ?? "................"}', style: pw.TextStyle(font: font)),
                              pw.Text('মোবাইল : ${controller.sallerAddress.value.date ?? "................"}', style: pw.TextStyle(font: font)),
                            ],
                          ),
                          pw.Table.fromTextArray(
                            headers: ['বিবরণ', 'সাইজ', 'পরিমাণ', 'দর', 'হার %', 'টাকা'],
                            data: controller.saleMemoList.map((product) {
                              return [
                                product.productName,
                                product.productSize,
                                product.amount,
                                product.price,
                                product.percent,
                                product.totalAmount
                              ];
                            }).toList(),
                            headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                            cellStyle: pw.TextStyle(font: font),
                          ),
                          pw.SizedBox(height: 20),
                          pw.Text('বিঃ দ্রঃ বিক্রিত মাল ফেরত হয় না।', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 10.0),
                          pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text('বিক্রেতার স্বাক্ষর', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold))
                          ),
                        ],
                      );
                    },
                  ),
                );

                await file.writeAsBytes(await pdf.save());

                final batch = controller.firestore.batch();
                final saleMemoDocs = await controller.firestore.collection('sale-memo').get();
                for (var doc in saleMemoDocs.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();


                // Clear the data after saving
                controller.sallerAddress.update((val) {
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
            icon: const Icon(Icons.file_download_outlined, color: Colors.white),
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
              final sallerAddress = controller.sallerAddress.value;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .50,
                        child: Text('নাম : ${sallerAddress.name ?? "................"}', style: const TextStyle(fontFamily: 'NotoSansBengali-Regular'))
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .40,
                        child: Text('তারিখ : ${sallerAddress.date ?? "................"}', style: const TextStyle(fontFamily: 'NotoSansBengali-Regular'))
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context). size.width * .50,
                        child: Text('ঠিকানা : ${sallerAddress.area ?? "................"}', style: const TextStyle(fontFamily: 'NotoSansBengali-Regular'))
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .40,
                        child: Text('মোবাইল : ${sallerAddress.contact ?? "................"}', style: const TextStyle(fontFamily: 'NotoSansBengali-Regular'))
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
                    child: Center(child: Text('বিবরণ', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(child: Text('সাইজ', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('পরিমাণ', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 10.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(child: Text('দর', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('হার %', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontSize: 12.0, fontWeight: FontWeight.bold))),
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
                  itemCount: controller.saleMemoList.length,
                  itemBuilder: (context, index) {
                    var soldProduct = controller.saleMemoList[index];
              
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(child: Text(soldProduct.productName, style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: Text(soldProduct.productSize, style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: Text(soldProduct.amount.toString(), style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: Text(soldProduct.price.toString(), style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: Text("0${soldProduct.percent}%", style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: Text(soldProduct.totalAmount.toString(), style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)))
                        ),
                      ],
                    );
                  }
                );
              }),
            ),
            const SizedBox(height: 10.0),
            const Text('বিঃ দ্রঃ বিক্রিত মাল ফেরত হয় না।', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('বিক্রেতার স্বাক্ষর', style: TextStyle(fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold))
            ),
            const SizedBox(height: 10.0)
          ],
        ),
      )
    );
  }
}