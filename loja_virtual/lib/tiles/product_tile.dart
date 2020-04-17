import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {

  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(this.product)
          )
        );
      },
      child: Card(
        child: this.type == 'grid' ? this.grid() : this.list()
      ),
    );
  }

  Widget grid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.8,
          child: Image.network(
              product.images[0],
              fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: this.buildText(product.title, product.price, true)
        )
      ],
    );
  }

  Widget list() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Image.network(
            product.images[0],
            fit: BoxFit.cover,
            height: 250,
          ),
        ),
        Flexible(
          flex: 1,
          child: this.buildText(product.title, product.price, false),
        ),
      ],
    );
  }

  Widget buildText(String title, double price, bool centerText) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: centerText ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w500
            ),
          ),
          Text(
            'R\$ ${price.toStringAsFixed(2)}',
            style: TextStyle(
                color: Color.fromARGB(255, 4, 125, 141),
                fontSize: 17,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
