import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
 const CartCard(
      {super.key,
      required this.name,
      required this.descripton,
      required this.totalValue});

  final String name;
  final String descripton;
  final String totalValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 200,
            child: Text(
              name,
              style: const TextStyle( fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )),
        SizedBox(
          width: 200,
          child: Text(
            descripton,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          "R\$: ${totalValue.replaceAll(RegExp(r'[.]'), ',')}",
          style: const TextStyle(color: Colors.green),
        )
      ],
    );
  }
}
