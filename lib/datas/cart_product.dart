import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/datas/product_data.dart';

class CartProduct {

  String cid;
  String category;
  String pid;
  int quantity;
  String size;
  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    dynamic data = document.data;
    this.cid = document.documentID;
    this.category = data['category'];
    this.pid = data['pid'];
    this.quantity = data['quantity'];
    this.size = data['size'];
  }

  Map<String, dynamic> toMap() {
    return {
      'category': this.category,
      'pid': this.pid,
      'quantity': this.quantity,
      'size': this.size,
      'product': productData.toResumedMap()
    };
  }

}