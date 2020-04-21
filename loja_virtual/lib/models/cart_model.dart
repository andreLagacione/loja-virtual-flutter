import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;
  String cupomCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItens();
    }
  }

  static CartModel of(BuildContext context) {
    return ScopedModel.of<CartModel>(context);
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    Firestore.instance.collection('users').document(user.firebaseUser.uid)
      .collection('cart').add(cartProduct.toMap()).then((doc) {
       cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance.collection('users').document(user.firebaseUser.uid)
        .collection('cart').document(cartProduct.cid).delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    updateData(cartProduct);
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    updateData(cartProduct);
  }

  void updateData(CartProduct cartProduct) {
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItens() async {
    QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').getDocuments();
    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void setCupom(String cupomCode, int discountPercentage) {
    this.cupomCode = cupomCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice() {
    double price = 0;

    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }

    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (products.length == 0) {
      return null;
    }

    isLoading = true;
    notifyListeners();

    double producstPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection('orders').add({
      'clientId': user.firebaseUser.uid,
      'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
      'shipPrice': shipPrice,
      'productsPrice': producstPrice,
      'discount': discount,
      'totalPrice': producstPrice - discount + shipPrice,
      'status': 1
    });

    await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('orders').document(refOrder.documentID).setData({
      'orderId': refOrder.documentID
    });

    QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    products.clear();
    cupomCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();
    return refOrder.documentID;
  }

}