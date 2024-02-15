import 'package:lista_de_compras/database/app_database.dart';
import 'package:lista_de_compras/models/product_model.dart';

class ProductRepository {
  
  Future<List<ProductModel>> getProductDatabase(int cartlistid) async {
    List<ProductModel> productlist = [];
    var db = await ListaDeComprasDataBase().getDatabase();
    var result = await db.rawQuery(
        'SELECT id, listid, name, price, unity, amount, checked FROM productlist WHERE listid = $cartlistid');
    for (var element in result) {
      productlist.add(
        ProductModel(
            int.parse(element['id'].toString()),
            int.parse(element['listid'].toString()),
            element['name'].toString(),
            double.parse(element['price'].toString()),
            element['unity'].toString(),
            double.parse(element['amount'].toString()),
            element['checked'] == 1
            ),
      );
    }
    return productlist;
  }
  Future<List<ProductModel>> getAllProductDatabase() async {
    List<ProductModel> productlist = [];
    var db = await ListaDeComprasDataBase().getDatabase();
    var result = await db.rawQuery(
        'SELECT id, listid, name, price, unity, amount, checked FROM productlist WHERE listid = listid');
    for (var element in result) {
      productlist.add(
        ProductModel(
            int.parse(element['id'].toString()),
            int.parse(element['listid'].toString()),
            element['name'].toString(),
            double.parse(element['price'].toString()),
            element['unity'].toString(),
            double.parse(element['amount'].toString()),
            element['checked'] == 1
            ),
      );
    }
    return productlist;
  }
  

  Future<void> save(ProductModel product) async {
    var db = await ListaDeComprasDataBase().getDatabase();
    await db.rawInsert(
        'INSERT INTO productlist(listid, name, price, unity, amount, checked) values(?,?,?,?,?,?)',
        [
          product.listid,
          product.name,
          product.price,
          product.unity,
          product.amount,
          product.checked
        ]);
  }

  Future<void> remove(int id) async {
    var db = await ListaDeComprasDataBase().getDatabase();
    await db.rawInsert('DELETE FROM productlist WHERE id = ?', [id]);
  }
  Future<void> removechild(int id) async {
    var db = await ListaDeComprasDataBase().getDatabase();
    await db.rawInsert('DELETE FROM productlist WHERE listid = ?', [id]);
  }

  Future<void> update(ProductModel productModel) async {
    var db = await ListaDeComprasDataBase().getDatabase();
    await db.rawInsert(
        'UPDATE productlist SET name = ?, listid = ?, price = ?, unity = ?, amount = ?, checked = ? WHERE id = ?',
        [
          productModel.name,
          productModel.listid,
          productModel.price,
          productModel.unity,
          productModel.amount,
          productModel.checked? 1 : 0,
          productModel.id
        ]);
  }
}
