import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_product/controller/product_controller.dart';
import 'package:my_product/page/purchased_memo_page.dart';
import 'package:my_product/page/sale_memo_page.dart';
import 'package:my_product/screen/add_product_screen.dart';
import 'package:my_product/screen/edit_product_screen.dart';
import 'package:my_product/screen/purchased_product_screen.dart';
import 'package:my_product/screen/sold_product_screen.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController productController = Get.put(ProductController());
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    productController.fetchInitialProducts();
    productController.fetchProducts();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productController.fetchMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Obx(() {
            productController.productList.sort(
              (a, b) => (a.name).compareTo(b.name),
            );

            if (productController.productList.isEmpty) {
              return const Center(
                child: Text(
                  'এখনো কোনো পণ্য যোগ করা হয় নি',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontFamily: 'NotoSansBengali-Regular',
                  ),
                ),
              );
            }
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: productController.productList.length + 1,
              itemBuilder: (context, index) {
                if (index < productController.productList.length) {
                  final product = productController.productList[index];

                  return Column(
                    children: [
                      ListTile(
                        leading: IconButton(
                          onPressed: () {
                            Get.to(EditProductScreen(product: product));
                          },
                          icon: Image.asset(
                            'images/edit.png',
                            height: 22.0,
                            width: 22.0,
                            color: Colors.pink,
                          ),
                        ),
                        title: Text(product.name),
                        titleTextStyle: const TextStyle(
                          color: Colors.pink,
                          fontFamily: 'NotoSansBengali-Regular',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: Row(
                          children: [
                            SizedBox(
                              width: 54,
                              child: Text(product.size)
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * .1),
                            SizedBox(
                              width: 54,
                              child: Text('৳ ${product.price}')
                            )
                          ],
                        ),
                        subtitleTextStyle: const TextStyle(
                          color: Color(0xFFDA6EBB),
                          fontFamily: 'NotoSansBengali-Regular',
                          fontSize: 12.0,
                        ),
                        trailing: Text(product.total.toString()),
                        leadingAndTrailingTextStyle: const TextStyle(
                          color: Colors.pink,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder:
                                (context) => Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Center(
                                        child: SizedBox(
                                          width: 28.0,
                                          child: Divider(thickness: 4.0),
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(
                                                  SoldProductScreen(
                                                    productName: product.name,
                                                    productSize: product.size,
                                                    totalProduct:
                                                        product.total
                                                            .toString(),
                                                    index: index,
                                                  ),
                                                );
                                              },
                                              child: SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    2,
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      'images/sale.png',
                                                      height: 28.0,
                                                      width: 28.0,
                                                      color: Colors.pink,
                                                    ),
                                                    const SizedBox(width: 12.0),
                                                    const Text(
                                                      'পণ্য বিক্রয়',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'NotoSansBengali-Regular',
                                                        color: Colors.pink,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(const SaleMemoPage());
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    'বিক্রয় মেমো',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'NotoSansBengali-Regular',
                                                      color: Colors.pink,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12.0),
                                                  Image.asset(
                                                    'images/recipe.png',
                                                    height: 28.0,
                                                    width: 28.0,
                                                    color: Colors.pink,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(
                                                  PurchasedProductScreen(
                                                    productName: product.name,
                                                    productSize: product.size,
                                                    totalProduct:
                                                        product.total
                                                            .toString(),
                                                    index: index,
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'images/buy.png',
                                                    height: 28.0,
                                                    width: 28.0,
                                                    color: Colors.pink,
                                                  ),
                                                  const SizedBox(width: 12.0),
                                                  const Text(
                                                    'পণ্য ক্রয়',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'NotoSansBengali-Regular',
                                                      color: Colors.pink,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(
                                                  const PurchasedMemoPage(),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    'ক্রয় মেমো',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'NotoSansBengali-Regular',
                                                      color: Colors.pink,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12.0),
                                                  Image.asset(
                                                    'images/recipe.png',
                                                    height: 28.0,
                                                    width: 28.0,
                                                    color: Colors.pink,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: const Divider(color: Color(0xFFFCB2E9)),
                      ),
                    ],
                  );
                } else {
                  return productController.hasMore
                  ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator(color: Colors.pink)),
                  )
                  : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'আর কোন পণ্য নেই',
                        style: TextStyle(
                          fontFamily: 'NotoSansBengali-Regular',
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          onPressed: () {
            Get.to(const AddProductScreen());
          },
          child: const Icon(Icons.add_shopping_cart, color: Colors.white),
        ),
      ),
    );
  }
}
