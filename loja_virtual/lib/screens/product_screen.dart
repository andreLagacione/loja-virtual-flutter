import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';

class ProductScreen extends StatefulWidget {

  final ProductData product;
  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(this.product);
}

class _ProductScreenState extends State<ProductScreen> {

  String sizeSelected;
  final ProductData product;
  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: this.product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  this.product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${this.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5
                    ),
                    children: this.product.sizes.map((sizeItem) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            this.sizeSelected = sizeItem;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4)
                            ),
                            border: Border.all(
                              color: sizeItem == this.sizeSelected ? primaryColor : Colors.grey[500],
                              width: 3
                            )
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            sizeItem,
                            style: TextStyle(
                              color: sizeItem == this.sizeSelected ? primaryColor : Colors.grey[500],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: this.sizeSelected == null ? null : () {

                    },
                    child: Text(
                      'Adicionar ao carrinho',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Descrição',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  this.product.description,
                  style: TextStyle(
                      fontSize: 16
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
