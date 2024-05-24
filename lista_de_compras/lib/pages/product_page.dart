import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lista_de_compras/cards/product_card.dart';
import 'package:lista_de_compras/models/product_model.dart';
import 'package:lista_de_compras/pages/cart_page.dart';
import 'package:lista_de_compras/pages/product_formpage.dart';
import 'package:lista_de_compras/repositories/product_repository.dart';
import 'package:lista_de_compras/widget/transition.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.listid, required this.listName});

  final int listid;
  final String listName;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var _product = <ProductModel>[];
  var _allproduct = <ProductModel>[];
  ProductRepository productRepository = ProductRepository();
  bool onlyChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    _product =
        await productRepository.getProductDatabase(widget.listid, onlyChecked);
    _allproduct = await productRepository.getAllProductDatabase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String totalValueCalculator(int cartid) {
      double totalPrice = 0.0;
      for (var element in _allproduct) {
        if (element.listid == cartid) {
          totalPrice += element.price * element.amount;
        }
      }
      return totalPrice.toStringAsFixed(2);
    }

    bool haveProduct() {
      if (_product.isEmpty) {
        return false;
      } else {
        return true;
      }
    }

    String emptyScreenTextSelector() {
      if (_product.isEmpty && onlyChecked == true) {
        return 'Você não tem nenhum item desmarcado nessa lista';
      } else {
        return 'Você não adicionou nenhum produto, para adicionar um produto, clique no + na parte superior da tela';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('${widget.listName}  '),
            Text(
              '${totalValueCalculator(widget.listid).replaceAll(RegExp(r'[.]'), ',')} R\$',
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await showModalBottomSheet<bool?>(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.8,
                        child: ProductFormpage(
                            listid: widget.listid,
                            type: 1,
                            listName: widget.listName),
                      );
                    }).whenComplete(() => loadData());
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mostrar somente os não marcados',
                          style: TextStyle(fontSize: 18),
                        ),
                        Switch(
                            activeColor: Colors.lightBlue,
                            value: onlyChecked,
                            onChanged: (bool value) {
                              onlyChecked = value;
                              loadData();
                            })
                      ],
                    ),
                  ),
                )),
            Expanded(
              flex: 13,
              child: Center(
                child: haveProduct()
                    ? MasonryGridView.builder(
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
                                            productRepository
                                                .remove(product.id);
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
                                                listName: product.listName,
                                                name: product.name,
                                                price: product.price.toString(),
                                                unity: product.unity,
                                                amount:
                                                    product.amount.toString(),
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
                        })
                    : Text(
                        emptyScreenTextSelector(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black38),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
