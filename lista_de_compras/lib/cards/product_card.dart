import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.unity,
    required this.amount,
    required this.checked,
    required this.id,
    required this.listid,
  });

  final String name;
  final double price;
  final String unity;
  final double amount;
  final bool checked;
  final int id;
  final int listid;
  

  

  @override
  Widget build(BuildContext context) {
    var result = price*amount;
    return SizedBox(
      height: 120,
     
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 140,
                  child: Text(name, overflow: TextOverflow.ellipsis,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)),
                Visibility(visible: checked, child: const Icon(Icons.check))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text("R\$ ${price.toStringAsFixed(2).replaceAll(RegExp(r'[.]'), ',')} por $unity"),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [ Text(amount.toStringAsFixed(2).replaceAll(RegExp(r'[.]'), ',')), Text(' $unity')],
            ),
            const SizedBox(
              height: 5,
            ),
            Text('R\$ ${result.toStringAsFixed(2).replaceAll(RegExp(r'[.]'), ',')}')
          ],
        ),
      ),
    );
  }
}
