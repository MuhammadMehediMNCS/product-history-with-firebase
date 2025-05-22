import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_product/model/buyer_address.dart';
import 'package:my_product/model/products.dart';
import 'package:my_product/model/purchased_memo.dart';
import 'package:my_product/model/saller_address.dart';
import 'package:my_product/model/sale_memo.dart';

class ProductController extends GetxController {
  var productList = <Products>[].obs;
  var saleMemoList = <SaleMemo>[].obs;
  var sallerAddress = SallerAddress().obs;
  var purchasedMemoList = <PurchasedMemo>[].obs;
  var buyerAddress = BuyerAddress().obs;

  // 10 data per loading
  DocumentSnapshot? lastDocument;
  bool hasMore = true;
  bool isLoading = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void fetchInitialProducts() async {
    isLoading = true;
    final querySnapshot = await firestore
        .collection('products')
        .orderBy('name') // use appropriate field
        .limit(10)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      productList.value = querySnapshot.docs
          .map((doc) => Products.fromJson(doc.data(), doc.id))
          .toList();
    }
    isLoading = false;
  }

  void fetchMoreProducts() async {
    if (isLoading || !hasMore) return;
    isLoading = true;

    final querySnapshot = await firestore
        .collection('products')
        .orderBy('name')
        .startAfterDocument(lastDocument!)
        .limit(10)
        .get();
    
    final fetchedDocs = querySnapshot.docs;

    if (fetchedDocs.isNotEmpty) {
      lastDocument = fetchedDocs.last;
      productList.addAll(fetchedDocs
          .map((doc) => Products.fromJson(doc.data(), doc.id))
          .toList());
      
      if (fetchedDocs.length < 10) {
        hasMore = false;
      }
    } else {
      hasMore = false;
    }
    isLoading = false;
  }

  // Load products from Firestore
  void fetchProducts() {
    firestore.collection('products').snapshots().listen((snapshot) {
      productList.value = snapshot.docs
        .map((doc) => Products.fromJson(doc.data(), doc.id))
        .toList();
    });
  }

  // Load Sale_Memo from Firestore
  void fetchSaleMemos() {
    firestore.collection('sale-memo').snapshots().listen((snapshot) {
      saleMemoList.value = snapshot.docs
        .map((doc) => SaleMemo.fromJson(doc.data()))
        .toList();
    });
  }

  // Load Purchased_Memo from Firestore
  void fetchPurchasedMemos() {
    firestore.collection('purchased-memo').snapshots().listen((snapshot) {
      purchasedMemoList.value = snapshot.docs
      .map((doc) => PurchasedMemo.fromJson(doc.data()))
      .toList();
    });
  }

  // Add product to Firestore
  Future<void> addProductToFirestore(Products product) async {
    await firestore.collection('products').add(product.toJson());
  }

  // Update product to Firestore
  Future<void> updateProductInFirestore(Products product) async {
    await firestore
      .collection('products')
      .doc(product.docId)
      .update(product.toJson());
  }

  // Delete product from Firestore
  Future<void> deleteProductFromFirestore(String docId) async {
    await firestore.collection('products').doc(docId).delete();
  }

  // Sale_Memo history with Firestore
  Future<void> addSaleMemoToFirestore({
    required String productName,
    required String productSize,
    required int amount,
    required double price,
    required double percent,
    required double totalAmount,
    required DateTime dateTime,
  }) async {
    await firestore.collection('sale-memo').add({
      'productName': productName,
      'productSize': productSize,
      'amount': amount,
      'price': price,
      'percent': percent,
      'totalAmount': totalAmount,
      'dateTime': dateTime.toIso8601String(),
    });
  }

  // Add client address
  void addSallerAddress(SallerAddress address) {
     sallerAddress.value = address;
  }

  // Purchased_Memo history with Firestore
  Future<void> addPurchasedMemoToFirestore({
    required String productName,
    required String productSize,
    required int newProduct,
    required int orderProduct,
    required int dueProduct,
    required double price,
    required double totalAmount,
    required DateTime dateTime,
  }) async {
    await firestore.collection('purchased-memo').add({
      'productName': productName,
      'productSize': productSize,
      'newProduct': newProduct,
      'orderProduct': orderProduct,
      'dueProduct': dueProduct,
      'price': price,
      'totalAmount': totalAmount,
      'dateTime': dateTime.toIso8601String(),
    });
  }

  // Add Buyer address
  void addBuyerAddress(BuyerAddress address) {
    buyerAddress.value = address;
  }
}