import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String category;
  String id;
  String title;
  String description;
  double price;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    dynamic data = snapshot.data;
    this.id = snapshot.documentID;
    this.title = data['title'];
    this.description = data['description'];
    this.price = data['price'] + 0.0;
    this.images = data['images'];
    this.sizes = data['sizes'];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      'title': this.title,
      'description': this.description,
      'price': this.price
    };
  }

}