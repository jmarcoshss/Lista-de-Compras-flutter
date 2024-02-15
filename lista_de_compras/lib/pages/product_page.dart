import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lista_de_compras/cards/product_card.dart';
import 'package:lista_de_compras/models/product_model.dart';
import 'package:lista_de_compras/pages/cart_page.dart';
import 'package:lista_de_compras/pages/product_formpage.dart';
import 'package:lista_de_compras/repositories/product_repository.dart';
import 'package:lista_de_compras/widget/transition.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.listid});

  final int listid;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var _product = <ProductModel>[];
  ProductRepository productRepository = ProductRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    _product = await productRepository.getProductDatabase(widget.listid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String totalValueCalculator() {
      double totalPrice = 0.0;
      for (var element in _product) {
        totalPrice += element.price * element.amount;
      }
      return totalPrice.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos  ${totalValueCalculator()} R\$'),
        actions: [
          IconButton(
              onPressed: () {
                transition(context, const CartPage());
              },
              icon: const Icon(Icons.exit_to_app)),
          IconButton(
              onPressed: () {
                transition(
                    context,
                    ProductFormpage(
                      listid: widget.listid,
                      type: 1,
                    ));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Center(
        child: MasonryGridView.builder(
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: _product.length,
            itemBuilder: (BuildContext bc, int index) {
              checker() async {
                var product = _product[index];
                product.checked = product.checked ? false : true;
                await productRepository.update(product);
              }

              var product = _product[index];
              return InkWell(
                onTap: () async {
                  setState(() {
                    checker();
                  });
                },
                child: Card(
                  color: product.checked
                      ? const Color.fromARGB(66, 161, 159, 159)
                      : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductCard(
                        name: product.name,
                        price: product.price,
                        unity: product.unity,
                        amount: product.amount,
                        checked: product.checked,
                        id: product.id,
                        listid: product.listid,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                productRepository.remove(product.id);
                                loadData();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () {
                                transition(
                                  context,
                                  ProductFormpage(
                                    type: 2,
                                    id: product.id,
                                    listid: product.listid,
                                    name: product.name,
                                    price: product.price.toString(),
                                    unity: product.unity,
                                    amount: product.amount.toString(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.green,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
