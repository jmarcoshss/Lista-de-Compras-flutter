import 'package:flutter/material.dart';
import 'package:lista_de_compras/cards/cart_card.dart';
import 'package:lista_de_compras/models/cart_model.dart';
import 'package:lista_de_compras/models/product_model.dart';
import 'package:lista_de_compras/pages/cart_formpage.dart';
import 'package:lista_de_compras/pages/product_page.dart';
import 'package:lista_de_compras/repositories/cart_repository.dart';
import 'package:lista_de_compras/repositories/product_repository.dart';
import 'package:lista_de_compras/widget/transition.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var _cart = <CartModel>[];
  CartRepository cartRepository = CartRepository();
  var _product = <ProductModel>[];
  ProductRepository productRepository = ProductRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    _cart = await cartRepository.getCartDatabase();
    _product = await productRepository.getAllProductDatabase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String totalPriceCalculator(int cartid) {
      double totalPrice = 0.0;
      for (var element in _product) {
        if (element.listid == cartid) {
          totalPrice += element.price * element.amount;
        }
      }
      return totalPrice.toStringAsFixed(2);
    }

    bool haveList() {
      if (_cart.isEmpty) {
        return false;
      } else {
        return true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartFormpage(
                              type: 1,
                            )));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: haveList()
            ? ListView.builder(
                itemCount: _cart.length,
                itemBuilder: (BuildContext bc, int index) {
                  var cart = _cart[index];
                  return InkWell(
                    onTap: () {
                      transition(
                        context,
                        ProductPage(
                          listid: cart.id,
                          listName: cart.name
                        ),
                      );
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            'Deseja Excluir ${cart.name}? essa ação excluirá todos os produtos da lista.'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                productRepository
                                                    .removechild(cart.id);
                                                cartRepository.remove(cart.id);
                                                loadData();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Confirmar')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancelar'))
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          CartCard(
                            name: cart.name,
                            descripton: cart.description,
                            totalValue: totalPriceCalculator(cart.id),
                          ),
                          IconButton(
                              onPressed: () {
                                transition(
                                    context,
                                    CartFormpage(
                                      type: 2,
                                      id: cart.id,
                                      name: cart.name,
                                      descripition: cart.description,
                                    ));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.green,
                              ))
                        ],
                      ),
                    ),
                  );
                })
            : const Text(
                'Você não tem nenhuma lista, para criar uma lista, clique no + na parte superior da tela',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black38),
              ),
      ),
    );
  }
}
