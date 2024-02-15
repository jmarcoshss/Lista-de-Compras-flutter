// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/product_model.dart';
import 'package:lista_de_compras/pages/product_page.dart';
import 'package:lista_de_compras/repositories/product_repository.dart';
import 'package:lista_de_compras/widget/transition.dart';

class ProductFormpage extends StatelessWidget {
  ProductFormpage({
    super.key,
    this.id,
    required this.listid,
    required this.type,
    this.name,
    this.price,
    this.unity,
    this.amount,
  });

  int? id = 0;
  int listid = 0;
  String? name = '';
  String? price = '';
  String? unity = '';
  String? amount = '';
  int type;
  String title = '';
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController unitycontroller = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();
  ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    String editingController(
        TextEditingController controller, String? content) {
      if (type == 2) {
        return controller.text = content!;
      } else {
        return controller.text;
      }
    }

    String titleManager() {
      if (type == 1) {
        return title = 'Novo Produto';
      } else {
        return title = 'Editando produto $name';
      }
    }

    namecontroller.text = editingController(namecontroller, name);
    pricecontroller.text = editingController(pricecontroller, price);
    unitycontroller.text = editingController(unitycontroller, unity);
    amountcontroller.text = editingController(amountcontroller, amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(titleManager()),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('Nome')),
                controller: namecontroller,
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                onTap: () {
                  pricecontroller.text = '';
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('Preço')),
                keyboardType: TextInputType.number,
                controller: pricecontroller,
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('Unidade')),
                controller: unitycontroller,
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                onTap: () {
                  amountcontroller.text = '';
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('Quantidade')),
                keyboardType: TextInputType.number,
                controller: amountcontroller,
              ),
              const SizedBox(
                height: 8,
              ),
              type == 1
                  ? Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              try {
                                if (namecontroller.text == '') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                          'Por favor digite o nome do produto '),
                                    ),
                                  );
                                } else {
                                  productRepository.save(
                                    ProductModel(
                                      0,
                                      listid,
                                      namecontroller.text,
                                      double.parse(
                                          emptyEqualZero(pricecontroller)),
                                      unitycontroller.text,
                                      double.parse(
                                          emptyEqualZero(amountcontroller)),
                                      false,
                                    ),
                                  );
                                  namecontroller.text = '';
                                  pricecontroller.text = '0.0';
                                  unitycontroller.text = '';
                                  amountcontroller.text = '0.0';
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                        'Por favor digite as frações do preço e da quantidade unsando ".". Ex: 2.25 '),
                                  ),
                                );
                              }
                            },
                            child: const Text('Salvar')),
                        TextButton(
                            onPressed: () {
                              transition(
                                  context,
                                  ProductPage(
                                    listid: listid,
                                  ));
                            },
                            child: const Text('voltar para o carrinho'))
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        try {
                          if (namecontroller.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content:
                                    Text('Por favor digite o nome do produto '),
                              ),
                            );
                          } else {
                            productRepository.update(
                              ProductModel(
                                id!,
                                listid,
                                namecontroller.text,
                                double.parse(emptyEqualZero(pricecontroller)),
                                unitycontroller.text,
                                double.parse(emptyEqualZero(amountcontroller)),
                                false,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text(
                                  'Por favor digite as frações do preço e da quantidade unsando ".". Ex: 2.25 '),
                            ),
                          );
                        }
                        transition(
                            context,
                            ProductPage(
                              listid: listid,
                            ));
                      },
                      child: const Text('salvar'))
            ],
          ),
        ),
      ]),
    );
  }

  String emptyEqualZero(TextEditingController controller) {
    if (controller.text == '') {
      controller.text = '0.0';
    } else {
      controller.text = controller.text;
    }
    return controller.text;
  }
}
