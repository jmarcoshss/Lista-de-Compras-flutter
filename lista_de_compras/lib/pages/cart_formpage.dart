// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/cart_model.dart';
import 'package:lista_de_compras/pages/cart_page.dart';
import 'package:lista_de_compras/repositories/cart_repository.dart';
import 'package:lista_de_compras/widget/transition.dart';

class CartFormpage extends StatefulWidget {
  CartFormpage(
      {super.key, required this.type, this.id, this.name, this.descripition});

  int type;
  int? id;
  String? name;
  String? descripition;

  @override
  State<CartFormpage> createState() => _CartFormpageState();
}

class _CartFormpageState extends State<CartFormpage> {
  String title = '';

  TextEditingController namecontroller = TextEditingController();

  TextEditingController descriptioncontroller = TextEditingController();

  CartRepository cartRepository = CartRepository();

  String editingController(TextEditingController controller, String? content) {
    if (widget.type == 2) {
      return controller.text = content!;
    } else {
      return controller.text;
    }
  }

  String titleManager() {
    if (widget.type == 1) {
      return title = 'Nova Lista';
    } else {
      return title = 'Editando lista ${widget.name}';
    }
  }

  @override
  Widget build(BuildContext context) {
    namecontroller.text = editingController(namecontroller, widget.name);
    descriptioncontroller.text =
        editingController(descriptioncontroller, widget.descripition);
    void close() {
      transition(context, const CartPage());
    }

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
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('Descrição')),
                controller: descriptioncontroller,
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (widget.type == 1) {
                      if (namecontroller.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text('Por favor digite o nome da lista'),
                          ),
                        );
                      } else {
                        try {
                          await cartRepository.save(
                            CartModel(
                              0,
                              namecontroller.text,
                              descriptioncontroller.text,
                            ),
                          );
                          
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text('ocorreu algum erro'),
                            ),
                          );
                        }
                        close();
                      }
                    } else {
                      if (namecontroller.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text('Por favor digite o nome da lista'),
                          ),
                        );
                      } else {
                        await cartRepository.update(
                          CartModel(
                            widget.id!,
                            namecontroller.text,
                            descriptioncontroller.text,
                          ),
                        );
                        close();
                      }
                    }
                  },
                  child: const Text('Salvar')),
            ],
          ),
        ),
      ]),
    );
  }
}
