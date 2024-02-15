// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/cart_model.dart';
import 'package:lista_de_compras/pages/cart_page.dart';
import 'package:lista_de_compras/repositories/cart_repository.dart';
import 'package:page_transition/page_transition.dart';

class CartFormpage extends StatelessWidget {
  CartFormpage(
      {super.key, required this.type, this.id, this.name, this.descripition});

  int type;
  int? id;
  String? name;
  String? descripition;
  String title = '';

  TextEditingController namecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  CartRepository cartRepository = CartRepository();

  String editingController(TextEditingController controller, String? content) {
    if (type == 2) {
      return controller.text = content!;
    } else {
      return controller.text;
    }
  }

  String titleManager() {
    if (type == 1) {
      return title = 'Nova Lista';
    } else {
      return title = 'Editando lista $name';
    }
  }

  @override
  Widget build(BuildContext context) {
    namecontroller.text = editingController(namecontroller, name);
    descriptioncontroller.text =
        editingController(descriptioncontroller, descripition);
    void close() {
      Navigator.pushReplacement(
        context,
        PageTransition(
            child: const CartPage(), type: PageTransitionType.bottomToTop),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titleManager()),
        actions: [
          IconButton(
              onPressed: () {
                close();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
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
                    if (type == 1) {
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
                          close();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text('ocorreu algum erro'),
                            ),
                          );
                        }
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
                            id!,
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
