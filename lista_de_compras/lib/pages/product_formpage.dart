// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/product_model.dart';
import 'package:lista_de_compras/pages/product_page.dart';
import 'package:lista_de_compras/repositories/product_repository.dart';
import 'package:lista_de_compras/widget/transition.dart';

class ProductFormpage extends StatefulWidget {
  ProductFormpage({
    super.key,
    this.id,
    required this.listid,
    required this.type,
    required this.listName,
    this.name,
    this.price,
    this.unity,
    this.amount,
  });

  int? id = 0;
  int listid = 0;
  String listName = '';
  String? name = '';
  String? price = '';
  String? unity = '';
  String? amount = '';
  int type;

  @override
  State<ProductFormpage> createState() => _ProductFormpageState();
}

class _ProductFormpageState extends State<ProductFormpage> {
  String title = '';
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController unitycontroller = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();
  ProductRepository productRepository = ProductRepository();

  late FocusNode nameFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    String editingController(
        TextEditingController controller, String? content) {
      if (widget.type == 2) {
        return controller.text = content!;
      } else {
        return controller.text;
      }
    }

    String titleManager() {
      if (widget.type == 1) {
        return title = 'Novo Produto para ${widget.listName}';
      } else {
        return title = 'Editando produto ${widget.name}';
      }
    }

    namecontroller.text = editingController(namecontroller, widget.name);
    pricecontroller.text = editingController(pricecontroller, widget.price);
    unitycontroller.text = editingController(unitycontroller, widget.unity);
    amountcontroller.text = editingController(amountcontroller, widget.amount);

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
                focusNode: nameFocus,
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Nome'),
                controller: namecontroller,
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Preço'),
                keyboardType: TextInputType.number,
                controller: pricecontroller,
                
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: List.empty()
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 62,
                      child: TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Quantidade'),
                        keyboardType: TextInputType.number,
                        controller: amountcontroller,
                      ),
                    ),
                    DropdownButton(
                      elevation: 0,
                      hint: const Text('Unidade'),
                      value: widget.unity,
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'Kg',
                          child: Text('Kilograma'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Un',
                          child: Text('Unidades'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'L',
                          child: Text('Litros'),
                        ),
                      ],
                      onChanged: (value) => setState(
                        () => unitycontroller.text = widget.unity = value!,
                      ),
                    ),
                    
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              widget.type == 1
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
                                      widget.listid,
                                      widget.listName,
                                      namecontroller.text,
                                      double.parse(emptyEqualZero(
                                          pricecontroller.text
                                              .replaceFirst(RegExp(","), "."))),
                                      unitycontroller.text,
                                      double.parse(emptyEqualZero(
                                          amountcontroller.text)),
                                      false,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text('Produto salvo'),
                                    ),
                                  );
                                  nameFocus.requestFocus();
                                  namecontroller.text = '';
                                  pricecontroller.text = '';
                                  amountcontroller.text = '';
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                        'Por favor digite as frações do preço e da quantidade usando somente "." ou ",". Ex: 2.25 ou 2,25 '),
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
                                    listName: widget.listName,
                                    listid: widget.listid,
                                  ));
                            },
                            child: const Text('Voltar para a tela anterior'))
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
                                widget.id!,
                                widget.listid,
                                widget.listName,
                                namecontroller.text,
                                double.parse(emptyEqualZero(pricecontroller.text
                                    .replaceFirst(RegExp(","), "."))),
                                unitycontroller.text,
                                double.parse(
                                    emptyEqualZero(amountcontroller.text)),
                                false,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text(
                                  'Por favor digite as frações do preço e da quantidade unsando "." ou ",". Ex: 2.25 '),
                            ),
                          );
                        }
                        transition(
                            context,
                            ProductPage(
                              listName: widget.listName,
                              listid: widget.listid,
                            ));
                      },
                      child: const Text('salvar'))
            ],
          ),
        ),
      ]),
    );
  }

  String emptyEqualZero(String controller) {
    if (controller == '') {
      controller = '0.0';
    } else {
      controller = controller;
    }
    return controller;
  }
}
